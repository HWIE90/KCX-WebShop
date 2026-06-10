codeunit 50106 "WebShop Correction Mgt."
{
    var
        UVPPriceTableNoLbl: Label '5276536', Locked = true;
        UVPPriceTableNameLbl: Label 'PB365 TR Sales Price', Locked = true;
        UVPSalesCodeLbl: Label 'UVP', Locked = true;

    procedure RunRestoreArchivedEntries()
    var
        RestoreDialog: Page "WebShop Restore Dialog";
        StartDate: Date;
        EndDate: Date;
    begin
        RestoreDialog.SetDefaults(DMY2Date(1, 4, 2026), DMY2Date(15, 4, 2026));
        if RestoreDialog.RunModal() <> Action::OK then
            exit;

        StartDate := RestoreDialog.GetStartDate();
        EndDate := RestoreDialog.GetEndDate();
        RestoreArchivedImportEntries(StartDate, EndDate, 0);
    end;

    procedure RestoreArchivedImportEntries(StartDate: Date; EndDate: Date; FilterTableNo: Integer)
    var
        NavToBC: Record "NAV To BC Import List";
        NavToBCArchive: Record "NAV To BC Import List Archive";
        ProgressWindow: Dialog;
        TotalCount: Integer;
        CurrentCount: Integer;
        RestoredCount: Integer;
        SkippedCount: Integer;
        ModCount: Integer;
        StartDateTime: DateTime;
        EndDateTime: DateTime;
    begin
        if StartDate = 0D then
            Error('Start date is required.');
        if EndDate = 0D then
            Error('End date is required.');
        if EndDate < StartDate then
            Error('End date must be greater than or equal to start date.');

        StartDateTime := CreateDateTime(StartDate, 000000T);
        EndDateTime := CreateDateTime(EndDate, 235959T);

        NavToBCArchive.SetRange(Status, 1);
        NavToBCArchive.SetRange(SystemCreatedAt, StartDateTime, EndDateTime);
        if FilterTableNo <> 0 then
            NavToBCArchive.SetRange(TableNo, FilterTableNo);

        if not NavToBCArchive.FindSet() then begin
            if GuiAllowed then
                Message('No archive entries were found for the selected period.');
            exit;
        end;

        TotalCount := NavToBCArchive.Count;
        if GuiAllowed then
            ProgressWindow.Open('Restore archived import entries (#1 of #2)...');

        repeat
            CurrentCount += 1;
            ModCount += 1;

            if GuiAllowed and (ModCount = 1) then begin
                ProgressWindow.Update(1, Format(CurrentCount));
                ProgressWindow.Update(2, Format(TotalCount));
            end;

            if NavToBC.Get(NavToBCArchive.EntryNo) then
                SkippedCount += 1
            else begin
                NavToBC.Init();
                NavToBC.TransferFields(NavToBCArchive, false);
                NavToBC.Status := 0; // Ready for re-import
                NavToBC.EntryNo := NavToBCArchive.EntryNo; // Preserve original EntryNo for traceability
                NavToBC.Insert(false);
                RestoredCount += 1;
            end;

            if ModCount MOD 1000 = 0 then begin
                ModCount := 0;
                Commit();
            end;
        until NavToBCArchive.Next() = 0;

        if GuiAllowed then begin
            ProgressWindow.Close();
            Message('%1 archive entries restored, %2 skipped because the entry no. already exists in the import list.', RestoredCount, SkippedCount);
        end;
    end;

    procedure ShowMissingDCEItemsWithoutBCItem()
    var
        MissingBuffer: Record "Missing DCE Item Buffer" temporary;
        MissingPage: Page "Missing DCE Item List";
    begin
        BuildMissingDCEItemBuffer(MissingBuffer);
        MissingPage.Load(MissingBuffer);
        MissingPage.Run();
    end;

    procedure ShowCurrentDuplicateUVPPrices()
    var
        DuplicateUVPBuffer: Record "Current Duplicate UVP Buffer" temporary;
        DuplicateUVPPage: Page "Current Duplicate UVP List";
    begin
        BuildCurrentDuplicateUVPBuffer(DuplicateUVPBuffer);
        if DuplicateUVPBuffer.IsEmpty() then
            exit;

        DuplicateUVPPage.Load(DuplicateUVPBuffer);
        DuplicateUVPPage.Run();
    end;

    procedure FillMissingSalesOrderLinePricesWithCurrentUVP(var SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        UpdatedCount: Integer;
        MissingUVPCount: Integer;
        AmbiguousUVPCount: Integer;
        CurrentUVPPrice: Decimal;
        AmbiguousItems: Text;
    begin
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetRange("Unit Price", 0);
        SalesLine.SetFilter("No.", '<>%1', '');

        if not SalesLine.FindSet(true) then begin
            if GuiAllowed then
                Message('Es wurden keine Artikelzeilen ohne Preis gefunden.');
            exit;
        end;

        repeat
            case GetCurrentUVPPriceForSalesLine(SalesHeader, SalesLine, CurrentUVPPrice) of
                1:
                    begin
                        SalesHeader.Status := SalesHeader.Status::Open;
                        SalesHeader.Modify(false);

                        SalesLine.Validate("Unit Price", CurrentUVPPrice);
                        SalesLine.Modify(true);

                        SalesHeader.Status := SalesHeader.Status::released;
                        SalesHeader.Modify(false);

                        UpdatedCount += 1;
                    end;
                else
                    MissingUVPCount += 1;
            end;
        until SalesLine.Next() = 0;

        if GuiAllowed then
            Message(
                'UVP-Korrektur abgeschlossen.\%1 Zeile(n) aktualisiert.\%2 Zeile(n) ohne passenden UVP übersprungen.\%3 Zeile(n) wegen mehrdeutigem UVP übersprungen.%4',
                UpdatedCount,
                MissingUVPCount,
                AmbiguousUVPCount,
                GetAmbiguousItemsMessage(AmbiguousItems));
    end;

    procedure UpdateCustomerLocationCodeToOne()
    var
        Customer: Record Customer;
        ProgressWindow: Dialog;
        TotalCount: Integer;
        CurrentCount: Integer;
        UpdatedCount: Integer;
    begin
        Customer.SetFilter("Location Code", '<>%1&<>%2', '', '1');

        if not Customer.FindSet(true) then begin
            if GuiAllowed then
                Message('No customers were found with a location code other than 1.');
            exit;
        end;

        TotalCount := Customer.Count;
        if GuiAllowed then
            ProgressWindow.Open('Updating customer location code to 1 (#1 of #2)...');

        repeat
            CurrentCount += 1;
            if GuiAllowed then begin
                ProgressWindow.Update(1, Format(CurrentCount));
                ProgressWindow.Update(2, Format(TotalCount));
            end;

            Customer.Validate("Location Code", '1');
            Customer.Modify(false);
            UpdatedCount += 1;
        until Customer.Next() = 0;

        if GuiAllowed then begin
            ProgressWindow.Close();
            Message('%1 customers were updated to location code 1.', UpdatedCount);
        end;
    end;

    local procedure BuildMissingDCEItemBuffer(var MissingBuffer: Record "Missing DCE Item Buffer" temporary)
    var
        DCEItem: Record "DCEItem";
        Item: Record Item;
        EntryNo: Integer;
    begin
        MissingBuffer.Reset();
        MissingBuffer.DeleteAll();

        if not DCEItem.FindSet() then
            exit;

        repeat
            if not Item.Get(DCEItem."Item No.") then begin
                EntryNo += 1;
                //DCEItem.CalcFields("Description");

                MissingBuffer.Init();
                MissingBuffer."Entry No." := EntryNo;
                MissingBuffer."Item No." := DCEItem."Item No.";
                MissingBuffer."Item Shop Code" := DCEItem."Shop Code";
                MissingBuffer."Item Language Code" := DCEItem."Language Code";
                MissingBuffer."Category Line No." := DCEItem."Main Category Line No.";
                MissingBuffer."Item Description" := DCEItem."Description";
                MissingBuffer."DCE Record ID" := Format(DCEItem.RecordId);
                MissingBuffer.Insert();
            end;
        until DCEItem.Next() = 0;
    end;

    local procedure BuildCurrentDuplicateUVPBuffer(var DuplicateUVPBuffer: Record "Current Duplicate UVP Buffer" temporary)
    var
        TempActiveUVPBuffer: Record "Current Duplicate UVP Buffer" temporary;
        PriceRecordRef: RecordRef;
        ActivePriceCounts: Dictionary of [Text, Integer];
        EntryNo: Integer;
        ActiveEntryCount: Integer;
        ItemNo: Code[20];
        SalesType: Text[30];
        SalesCode: Code[20];
        CurrencyCode: Code[10];
        VariantCode: Code[10];
        UnitOfMeasureCode: Code[10];
        MinimumQuantity: Decimal;
        PriceKey: Text;
    begin
        ClearCurrentDuplicateUVPBuffer(DuplicateUVPBuffer);
        ClearCurrentDuplicateUVPBuffer(TempActiveUVPBuffer);

        OpenUVPPriceTable(PriceRecordRef);

        if not PriceRecordRef.FindSet() then
            exit;

        repeat
            if IsCurrentUVPPriceLine(PriceRecordRef) then begin
                ItemNo := GetRequiredCodeFieldValue(PriceRecordRef, 1, MaxStrLen(TempActiveUVPBuffer."Item No."));
                if ItemNo <> '' then begin
                    SalesType := GetFieldValueAsText(PriceRecordRef, 5, MaxStrLen(TempActiveUVPBuffer."Sales Type"));
                    SalesCode := GetCodeFieldValue(PriceRecordRef, 10, MaxStrLen(TempActiveUVPBuffer."Sales Code"));
                    CurrencyCode := GetCodeFieldValue(PriceRecordRef, 20, MaxStrLen(TempActiveUVPBuffer."Currency Code"));
                    VariantCode := GetCodeFieldValue(PriceRecordRef, 25, MaxStrLen(TempActiveUVPBuffer."Variant Code"));
                    UnitOfMeasureCode := GetCodeFieldValue(PriceRecordRef, 30, MaxStrLen(TempActiveUVPBuffer."Unit of Measure Code"));
                    MinimumQuantity := GetDecimalFieldValue(PriceRecordRef, 35);
                    PriceKey := GetDuplicateUVPKey(ItemNo, SalesType, SalesCode, CurrencyCode, VariantCode, UnitOfMeasureCode, MinimumQuantity);
                    EntryNo += 1;

                    TempActiveUVPBuffer.Init();
                    TempActiveUVPBuffer."Entry No." := EntryNo;
                    TempActiveUVPBuffer."Item No." := ItemNo;
                    TempActiveUVPBuffer."Item Key" := CopyStr(PriceKey, 1, MaxStrLen(TempActiveUVPBuffer."Item Key"));
                    TempActiveUVPBuffer."Sales Type" := SalesType;
                    TempActiveUVPBuffer."Sales Code" := SalesCode;
                    TempActiveUVPBuffer."Currency Code" := CurrencyCode;
                    TempActiveUVPBuffer."Variant Code" := VariantCode;
                    TempActiveUVPBuffer."Unit of Measure Code" := UnitOfMeasureCode;
                    TempActiveUVPBuffer."Minimum Quantity" := MinimumQuantity;
                    TempActiveUVPBuffer."Unit Price" := GetRequiredDecimalFieldValue(PriceRecordRef, 50);
                    TempActiveUVPBuffer."Starting Date" := GetDateFieldValue(PriceRecordRef, 15);
                    TempActiveUVPBuffer."Ending Date" := GetDateFieldValue(PriceRecordRef, 70);
                    TempActiveUVPBuffer."Source Record ID" := CopyStr(Format(PriceRecordRef.RecordId), 1, MaxStrLen(TempActiveUVPBuffer."Source Record ID"));
                    TempActiveUVPBuffer.Insert();

                    if ActivePriceCounts.Get(PriceKey, ActiveEntryCount) then
                        ActivePriceCounts.Set(PriceKey, ActiveEntryCount + 1)
                    else
                        ActivePriceCounts.Add(PriceKey, 1);
                end;
            end;
        until PriceRecordRef.Next() = 0;

        if not TempActiveUVPBuffer.FindSet() then
            exit;

        repeat
            ActiveEntryCount := 0;
            if ActivePriceCounts.Get(TempActiveUVPBuffer."Item Key", ActiveEntryCount) and (ActiveEntryCount > 1) then begin
                DuplicateUVPBuffer := TempActiveUVPBuffer;
                DuplicateUVPBuffer."Active Entry Count" := ActiveEntryCount;
                DuplicateUVPBuffer.Insert();
            end;
        until TempActiveUVPBuffer.Next() = 0;

        if DuplicateUVPBuffer.IsEmpty() and GuiAllowed then
            Message('No articles with multiple currently valid UVP entries were found in table %1 (%2).', GetUVPPriceTableNo(), UVPPriceTableNameLbl);
    end;

    local procedure ClearCurrentDuplicateUVPBuffer(var DuplicateUVPBuffer: Record "Current Duplicate UVP Buffer" temporary)
    begin
        DuplicateUVPBuffer.Reset();
        DuplicateUVPBuffer.DeleteAll();
    end;

    local procedure OpenUVPPriceTable(var PriceRecordRef: RecordRef)
    begin
        PriceRecordRef.Open(GetUVPPriceTableNo());
    end;

    local procedure GetUVPPriceTableNo(): Integer
    var
        UVPPriceTableNo: Integer;
    begin
        Evaluate(UVPPriceTableNo, UVPPriceTableNoLbl);
        exit(UVPPriceTableNo);
    end;

    local procedure IsCurrentUVPPriceLine(PriceRecordRef: RecordRef): Boolean
    var
        StartingDate: Date;
        EndingDate: Date;
        WorkDateValue: Date;
    begin
        WorkDateValue := Today;
        StartingDate := GetDateFieldValue(PriceRecordRef, 15);
        EndingDate := GetDateFieldValue(PriceRecordRef, 70);

        if (StartingDate <> 0D) and (StartingDate > WorkDateValue) then
            exit(false);
        if (EndingDate <> 0D) and (EndingDate < WorkDateValue) then
            exit(false);

        exit(true);
    end;

    local procedure GetRequiredCodeFieldValue(PriceRecordRef: RecordRef; FieldNo: Integer; MaxLength: Integer): Code[20]
    var
        ValueAsText: Text;
        Result: Code[20];
    begin
        ValueAsText := GetFieldValueAsText(PriceRecordRef, FieldNo, MaxLength);
        Evaluate(Result, ValueAsText);
        exit(Result);
    end;

    local procedure GetCodeFieldValue(PriceRecordRef: RecordRef; FieldNo: Integer; MaxLength: Integer): Code[20]
    var
        ValueAsText: Text;
        Result: Code[20];
    begin
        ValueAsText := GetFieldValueAsText(PriceRecordRef, FieldNo, MaxLength);
        Evaluate(Result, ValueAsText);
        exit(Result);
    end;

    local procedure GetRequiredDecimalFieldValue(PriceRecordRef: RecordRef; FieldNo: Integer): Decimal
    var
        FieldValue: Decimal;
    begin
        FieldValue := GetDecimalFieldValue(PriceRecordRef, FieldNo);
        exit(FieldValue);
    end;

    local procedure GetDecimalFieldValue(PriceRecordRef: RecordRef; FieldNo: Integer): Decimal
    var
        PriceFieldRef: FieldRef;
        PriceValue: Decimal;
    begin
        PriceFieldRef := PriceRecordRef.Field(FieldNo);
        if not Evaluate(PriceValue, Format(PriceFieldRef.Value)) then
            Error('Field %1 in table %2 could not be read as Decimal.', FieldNo, GetUVPPriceTableNo());

        exit(PriceValue);
    end;

    local procedure GetDateFieldValue(PriceRecordRef: RecordRef; FieldNo: Integer): Date
    var
        PriceFieldRef: FieldRef;
        DateValue: Date;
    begin
        PriceFieldRef := PriceRecordRef.Field(FieldNo);
        if Format(PriceFieldRef.Value) = '' then
            exit(0D);

        if not Evaluate(DateValue, Format(PriceFieldRef.Value)) then
            Error('Field %1 in table %2 could not be read as Date.', FieldNo, GetUVPPriceTableNo());

        exit(DateValue);
    end;

    local procedure GetFieldValueAsText(PriceRecordRef: RecordRef; FieldNo: Integer; MaxLength: Integer): Text
    var
        PriceFieldRef: FieldRef;
        FieldValueAsText: Text;
    begin
        PriceFieldRef := PriceRecordRef.Field(FieldNo);
        FieldValueAsText := Format(PriceFieldRef.Value);

        if MaxLength = 0 then
            exit(FieldValueAsText);

        exit(CopyStr(FieldValueAsText, 1, MaxLength));
    end;

    local procedure GetDuplicateUVPKey(ItemNo: Code[20]; SalesType: Text; SalesCode: Code[20]; CurrencyCode: Code[10]; VariantCode: Code[10]; UnitOfMeasureCode: Code[10]; MinimumQuantity: Decimal): Text
    begin
        exit(StrSubstNo('%1|%2|%3|%4|%5|%6|%7', ItemNo, SalesType, SalesCode, CurrencyCode, VariantCode, UnitOfMeasureCode, Format(MinimumQuantity)));
    end;

    local procedure GetCurrentUVPPriceForSalesLine(SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; var UnitPrice: Decimal): Integer
    var
        PriceRecordRef: RecordRef;
        CandidatePrice: Decimal;
        CandidateStartingDate: Date;
        BestPrice: Decimal;
        BestStartingDate: Date;
        FoundMatch: Boolean;
    begin
        Clear(UnitPrice);
        OpenUVPPriceTable(PriceRecordRef);
        PriceRecordRef.Field(1).SetRange(SalesLine."No.");
        PriceRecordRef.Field(10).SetRange(UVPSalesCodeLbl);

        if not PriceRecordRef.FindSet() then
            exit(0);

        repeat
            if IsLatestValidUVPPriceLine(PriceRecordRef) then begin
                CandidatePrice := GetRequiredDecimalFieldValue(PriceRecordRef, 50);
                CandidateStartingDate := GetDateFieldValue(PriceRecordRef, 15);

                if (not FoundMatch) or (CandidateStartingDate >= BestStartingDate) then begin
                    FoundMatch := true;
                    BestStartingDate := CandidateStartingDate;
                    BestPrice := CandidatePrice;
                end;
            end;
        until PriceRecordRef.Next() = 0;

        if not FoundMatch then
            exit(0);

        UnitPrice := BestPrice;
        exit(1);
    end;

    local procedure IsLatestValidUVPPriceLine(PriceRecordRef: RecordRef): Boolean
    begin
        exit(IsCurrentUVPPriceLine(PriceRecordRef));
    end;

    local procedure AddItemToMessageList(var ItemList: Text; ItemNo: Code[20])
    begin
        if ItemNo = '' then
            exit;

        if ItemList = '' then
            ItemList := ItemNo
        else
            ItemList += ', ' + ItemNo;
    end;

    local procedure GetAmbiguousItemsMessage(AmbiguousItems: Text): Text
    begin
        if AmbiguousItems = '' then
            exit('');

        exit(StrSubstNo('\Mehrdeutige Artikel: %1', AmbiguousItems));
    end;

}
