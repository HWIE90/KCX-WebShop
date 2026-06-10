codeunit 50100 "WebShop ERP-Interface Mgt."
{
    Permissions =
        tabledata "G/L Entry" = rmid,
        tabledata "Cust. Ledger Entry" = rmid,
        tabledata "Item Ledger Entry" = rmid,
        tabledata "Detailed Cust. Ledg. Entry" = rmid,
        tabledata "Value Entry" = rmid,
        tabledata "Sales Shipment Header" = rmid,
        tabledata "Sales Shipment Line" = rmid,
        tabledata "Sales Invoice Header" = rmid,
        tabledata "Sales Invoice Line" = rmid;

    trigger OnRun()
    begin

    end;

    procedure DeleteTable()
    var
        TabToDelete: Record Item;
    begin
        //TabToDelete.SetFilter("No.", '%1|%2', '571-20ML-01-*', '571-20ML-02-*');
        //Message('%1', TabToDelete.Count);
        //Message('Nicht aktiv');
        //TabToDelete.DeleteAll(true);
        Message('Not Active');
    end;

    procedure ArchiveData()
    var
        NavToBC: Record "NAV To BC Import List";
        NavToBCArchive: Record "NAV To BC Import List Archive";
        //Update Window
        ProgressWindow: Dialog;
        TotalCount: Integer;
        CurrentCount: Integer;
        ModCount: Integer;
    begin
        NavToBC.SetRange(Status, 1); //Archive successfully inserted records
        IF NavToBC.FindSet() then begin
            TotalCount := NavToBC.Count;
            IF GuiAllowed THEN
                ProgressWindow.OPEN('Archivierte Daten (#1 von #2)...');
            repeat
                CurrentCount += 1;
                ModCount += 1;
                IF GuiAllowed AND (ModCount = 1) THEN begin
                    ProgressWindow.UPDATE(1, Format(CurrentCount));
                    ProgressWindow.UPDATE(2, Format(TotalCount));
                end;

                NavToBCArchive.TransferFields(NavToBC, false);
                NavToBCArchive.EntryNo := NavToBC.EntryNo;
                IF NavToBCArchive.Insert(true) THEN;

                NavToBC.Delete();

                IF ModCount MOD 100 = 0 THEN begin
                    ModCount := 0;
                    COMMIT;
                end;
            until NavToBC.Next() = 0;
            IF GuiAllowed THEN
                ProgressWindow.CLOSE;
        end;
    end;

    procedure ImportNAVToBC(var NavToBCIpnut: Record "NAV To BC Import List")
    var
        NavToBC: Record "NAV To BC Import List";
        LastRecordID: Text;
        TargetRec: RecordRef;
        Field: FieldRef;
        TempFieldNo: Integer;
        FieldValueText: Text;
        FieldType: Integer;
        ShouldInsert: Boolean;
        RecID: RecordId;
        ProgressWindow: Dialog;
        TotalCount: Integer;
        CurrentCount: Integer;
        ModCount: Integer;
    begin
        NavToBC.CopyFilters(NavToBCIpnut);
        // Ladebalken initialisieren
        TotalCount := NAVToBC.Count;
        IF GuiAllowed THEN
            ProgressWindow.OPEN('Importiere Daten (#1 von #2)...');

        if NAVToBC.FindSet() then begin
            repeat
                IF GuiAllowed AND (ModCount = 1) THEN BEGIN
                    CurrentCount += 1;
                    ProgressWindow.UPDATE(1, Format(CurrentCount));
                    ProgressWindow.UPDATE(2, Format(TotalCount));
                END;

                if (NAVToBC."RecordID" <> LastRecordID) OR (NavToBC.TypeOfChange IN [2]) then begin
                    Evaluate(RecID, NAVToBC.RecordID);
                    Clear(TargetRec);
                    //TargetRec.Init();
                    IF NavToBC.TypeOfChange IN [0, 1] THEN begin
                        //Modify or Delete Record
                        IF NOT TargetRec.GET(RecID) THEN begin
                            TargetRec := RecID.GetRecord();
                            TargetRec.Insert(true);
                        end;
                    end else begin
                        //Delete Record
                        NAVToBC.Status := 2; //Fehler;
                        IF TargetRec.GET(RecID) THEN begin
                            TargetRec.Delete(true);
                        end;
                        NAVToBC.Status := 1; //Erfolg
                        NAVToBC.Modify(false);
                    end;
                    LastRecordID := NAVToBC."RecordID";
                end;

                IF NavToBC.TypeOfChange IN [0, 1] THEN begin
                    NAVToBC.Status := 2; //Fehler;
                    TempFieldNo := NAVToBC."FieldNo";
                    FieldValueText := NAVToBC."NAVContent";
                    //IsModified := false;

                    // Prüfen ob Feld existiert
                    if TargetRec.FieldExist(TempFieldNo) then begin
                        Field := TargetRec.Field(TempFieldNo);

                        IF TryToAssignFieldValues(Field, FieldValueText) then begin
                            TargetRec.Modify(true);
                            NAVToBC.Status := 1 //Erfolg
                        end else begin
                            IF GuiAllowed THEN
                                Error(GetLastErrorText);
                        end;
                    end;

                    NAVToBC.Modify(false);

                    ModCount += 1;
                    IF ModCount MOD 100 = 0 THEN begin
                        ModCount := 0;
                        COMMIT;
                    end;
                end;
            until NAVToBC.Next() = 0;
        end;

        IF GuiAllowed THEN BEGIN
            ProgressWindow.CLOSE;
        end;
    end;

    [TryFunction]
    local procedure TryToAssignFieldValues(var Field: FieldRef; var FieldValueText: Text)
    var
        IsModified: Boolean;
        IntegerVar: Integer;
        BigIntegerVar: BigInteger;
        DecimalVar: Decimal;
        DateVar: Date;
        TimeVar: Time;
        DateTimeVar: DateTime;
        BooleanVar: Boolean;
        OptionVar: Option;
    begin
        // Typgerechte Zuweisung
        case Field.Type() of
            Field.Type() ::Integer:
                begin
                    // EVALUATE konvertiert Text zu Zieltyp
                    IF Evaluate(IntegerVar, FieldValueText) then begin
                        Field.Value := IntegerVar;
                        IsModified := true;
                    end;
                end;
            Field.Type() ::BigInteger:
                begin
                    // EVALUATE konvertiert Text zu Zieltyp
                    IF Evaluate(BigIntegerVar, FieldValueText) then begin
                        Field.Value := BigIntegerVar;
                        IsModified := true;
                    end;
                end;
            Field.Type() ::Decimal:
                begin
                    // EVALUATE konvertiert Text zu Zieltyp
                    IF Evaluate(DecimalVar, FieldValueText) then begin
                        Field.Value := DecimalVar;
                        IsModified := true;
                    end;
                end;
            Field.Type() ::Date:
                begin
                    // EVALUATE konvertiert Text zu Zieltyp
                    IF Evaluate(DateVar, FieldValueText) then begin
                        Field.Value := DateVar;
                        IsModified := true;
                    end;
                end;
            Field.Type() ::Time:
                begin
                    // EVALUATE konvertiert Text zu Zieltyp
                    IF Evaluate(TimeVar, FieldValueText) then begin
                        Field.Value := TimeVar;
                        IsModified := true;
                    end;
                end;
            Field.Type() ::DateTime:
                begin
                    // EVALUATE konvertiert Text zu Zieltyp
                    IF Evaluate(DateTimeVar, FieldValueText) then begin
                        Field.Value := DateTimeVar;
                        IsModified := true;
                    end;
                end;
            Field.Type() ::Boolean:
                begin
                    // EVALUATE konvertiert Text zu Zieltyp
                    IF Evaluate(BooleanVar, FieldValueText) then begin
                        Field.Value := BooleanVar;
                        IsModified := true;
                    end;
                end;
            Field.Type() ::Option:
                begin
                    // EVALUATE konvertiert Text zu Zieltyp
                    IF Evaluate(OptionVar, FieldValueText) then begin
                        Field.Value := OptionVar;
                        IsModified := true;
                    end;
                end;
            Field.Type() ::Code,
            Field.Type() ::Text,
            Field.Type() ::Guid:
                begin
                    Field.Value := FieldValueText;
                    IsModified := true;
                end;
        end;

        IF Not IsModified then
            Error('Zuweisung fehlgeschlagen: "%1" für Feldtyp %2', FieldValueText, Format(Field.Type()));
    end;
}
