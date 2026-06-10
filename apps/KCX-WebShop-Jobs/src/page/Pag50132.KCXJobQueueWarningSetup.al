page 50132 "KCX Job Queue Warning Setup"
{
    ApplicationArea = All;
    Caption = 'KCX Job Queue Warning Setup';
    PageType = Card;
    SourceTable = "KCX Job Queue Warning Setup";
    UsageCategory = Administration;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Active; Rec.Active)
                {
                    ToolTip = 'Specifies whether the job queue warning monitor is active.';
                }
                field(NotificationEmails; Rec."Notification Emails")
                {
                    ToolTip = 'Specifies the email recipients. Separate multiple addresses with semicolons.';
                }
                field(MonitoredUserIDs; Rec."Monitored User IDs")
                {
                    ToolTip = 'Specifies the job queue user IDs to monitor. Separate multiple user IDs with semicolons.';
                }
                field(ReadyWarningMinutes; Rec."Ready Warning Minutes")
                {
                    ToolTip = 'Specifies after how many minutes a ready job queue entry is reported when its earliest start date/time is exceeded.';
                }
                field(InProcessWarningMinutes; Rec."In Process Warning Minutes")
                {
                    ToolTip = 'Specifies after how many minutes a job queue entry in process is reported when it has not changed.';
                }
                field(WarningMailSubject; Rec."Warning Mail Subject")
                {
                    ToolTip = 'Specifies the subject used for warning emails.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        EnsureSetupExists();
    end;

    local procedure EnsureSetupExists()
    begin
        if Rec.Get('SETUP') then
            exit;

        Rec.Init();
        Rec."Primary Key" := 'SETUP';
        Rec.Insert(true);
    end;
}
