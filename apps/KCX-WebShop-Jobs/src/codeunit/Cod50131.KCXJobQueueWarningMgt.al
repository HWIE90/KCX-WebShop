codeunit 50131 "KCX Job Queue Warning Mgt."
{
    trigger OnRun()
    begin
        CheckJobQueueWarnings();
    end;

    procedure SendTestMail()
    var
        Setup: Record "KCX Job Queue Warning Setup";
        Recipients: List of [Text];
    begin
        if not GetSetup(Setup) then
            Error(MissingSetupErr);

        BuildValueList(Setup."Notification Emails", Recipients);
        if Recipients.Count() = 0 then
            Error(MissingRecipientsErr);

        SendMail(Recipients, TestMailSubjectLbl, TestMailBodyLbl);
    end;

    procedure SendMail(Recipients: List of [Text]; Subject: Text; Body: Text)
    var
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
    begin
        EmailMessage.Create(Recipients, Subject, Body, false);
        Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
    end;

    procedure CheckJobQueueWarnings()
    var
        Setup: Record "KCX Job Queue Warning Setup";
        JobQueueEntry: Record "Job Queue Entry";
        Recipients: List of [Text];
        MonitoredUserIds: List of [Text];
        WarningMessage: TextBuilder;
        HasWarnings: Boolean;
    begin
        if not GetSetup(Setup) then
            exit;

        if not Setup.Active then
            exit;

        BuildValueList(Setup."Notification Emails", Recipients);
        if Recipients.Count() = 0 then
            exit;

        BuildValueList(Setup."Monitored User IDs", MonitoredUserIds);
        if MonitoredUserIds.Count() = 0 then
            exit;

        WarningMessage.AppendLine('Job Queue Warnings:');
        WarningMessage.AppendLine('');

        JobQueueEntry.SetFilter("User ID", BuildFilterFromList(MonitoredUserIds));

        if JobQueueEntry.FindSet() then
            repeat
                if CheckJobForWarning(JobQueueEntry, WarningMessage, Setup) then
                    HasWarnings := true;
            until JobQueueEntry.Next() = 0;

        if HasWarnings then
            SendMail(Recipients, Setup."Warning Mail Subject", WarningMessage.ToText());
    end;

    local procedure CheckJobForWarning(var JobQueueEntry: Record "Job Queue Entry"; var WarningMessage: TextBuilder; Setup: Record "KCX Job Queue Warning Setup"): Boolean
    var
        FoundNewWarning: Boolean;
    begin
        FoundNewWarning := CheckWarningType(JobQueueEntry, WarningMessage, 'Error', Setup);
        FoundNewWarning := CheckWarningType(JobQueueEntry, WarningMessage, 'NotRunTooLong', Setup) or FoundNewWarning;
        FoundNewWarning := CheckWarningType(JobQueueEntry, WarningMessage, 'InProcessTooLong', Setup) or FoundNewWarning;

        exit(FoundNewWarning);
    end;

    local procedure CheckWarningType(var JobQueueEntry: Record "Job Queue Entry"; var WarningMessage: TextBuilder; WarningType: Text[50]; Setup: Record "KCX Job Queue Warning Setup"): Boolean
    var
        JobWarningLog: Record "Job Warning Log";
    begin
        JobWarningLog.SetRange("Job Queue Entry ID", JobQueueEntry.ID);
        JobWarningLog.SetRange("Warning Type", WarningType);

        if IsWarningActive(JobQueueEntry, WarningType, Setup) then begin
            if JobWarningLog.FindFirst() then
                exit(false);

            WarningMessage.AppendLine(BuildWarningLine(JobQueueEntry, WarningType));

            JobWarningLog.Init();
            JobWarningLog."Job Queue Entry ID" := JobQueueEntry.ID;
            JobWarningLog."Warning Type" := WarningType;
            JobWarningLog."Last Warning DateTime" := CurrentDateTime();
            JobWarningLog.Insert();
            exit(true);
        end;

        if JobWarningLog.FindFirst() then
            JobWarningLog.Delete();

        exit(false);
    end;

    local procedure IsWarningActive(var JobQueueEntry: Record "Job Queue Entry"; WarningType: Text[50]; Setup: Record "KCX Job Queue Warning Setup"): Boolean
    begin
        case WarningType of
            'Error':
                exit(JobQueueEntry.Status = JobQueueEntry.Status::Error);
            'NotRunTooLong':
                exit((JobQueueEntry.Status = JobQueueEntry.Status::Ready) and
                     (JobQueueEntry."Earliest Start Date/Time" <> 0DT) and
                     (JobQueueEntry."Earliest Start Date/Time" < (CurrentDateTime() - MinutesToMilliseconds(Setup."Ready Warning Minutes"))));
            'InProcessTooLong':
                exit((JobQueueEntry.Status = JobQueueEntry.Status::"In Process") and
                     (JobQueueEntry.SystemModifiedAt < (CurrentDateTime() - MinutesToMilliseconds(Setup."In Process Warning Minutes"))));
            else
                exit(false);
        end;
    end;

    local procedure BuildWarningLine(var JobQueueEntry: Record "Job Queue Entry"; WarningType: Text[50]): Text
    begin
        exit(StrSubstNo(JobQueueWarningLineLbl,
            JobQueueEntry.ID,
            JobQueueEntry."User ID",
            JobQueueEntry.Description,
            JobQueueEntry.Status,
            WarningType,
            JobQueueEntry."Earliest Start Date/Time",
            JobQueueEntry.SystemModifiedAt));
    end;

    local procedure GetSetup(var Setup: Record "KCX Job Queue Warning Setup"): Boolean
    begin
        if Setup.Get('SETUP') then
            exit(true);

        Setup.Init();
        Setup."Primary Key" := 'SETUP';
        Setup.Insert(true);
        exit(true);
    end;

    local procedure BuildValueList(Values: Text; var ValueList: List of [Text])
    var
        RemainingText: Text;
        CurrentValue: Text;
        SeparatorPosition: Integer;
    begin
        RemainingText := DelChr(Values, '<>', ' ');

        while RemainingText <> '' do begin
            SeparatorPosition := StrPos(RemainingText, ';');
            if SeparatorPosition = 0 then begin
                CurrentValue := RemainingText;
                RemainingText := '';
            end else begin
                CurrentValue := CopyStr(RemainingText, 1, SeparatorPosition - 1);
                RemainingText := CopyStr(RemainingText, SeparatorPosition + 1);
            end;

            CurrentValue := DelChr(CurrentValue, '<>', ' ');
            if CurrentValue <> '' then
                ValueList.Add(CurrentValue);
        end;
    end;

    local procedure BuildFilterFromList(Values: List of [Text]): Text
    var
        Value: Text;
        FilterText: Text;
    begin
        foreach Value in Values do begin
            if FilterText <> '' then
                FilterText += '|';

            FilterText += Value;
        end;

        exit(FilterText);
    end;

    local procedure MinutesToMilliseconds(Minutes: Integer): Integer
    begin
        exit(Minutes * 60000);
    end;

    var
        TestMailSubjectLbl: Label 'KCX Job Queue warning test mail';
        TestMailBodyLbl: Label 'This is a test mail from the KCX Job Queue warning monitor.';
        JobQueueWarningLineLbl: Label 'Job ID: %1, User ID: %2, Description: %3, Status: %4, Warning: %5, Earliest Start: %6, Last Modified: %7';
        MissingSetupErr: Label 'KCX Job Queue Warning Setup is missing.';
        MissingRecipientsErr: Label 'No notification email recipients are configured in KCX Job Queue Warning Setup.';
}
