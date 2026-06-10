codeunit 50103 "BC to NAV Event Handler"
{
    // Version List: KCX0.01, BC Webshop

    trigger OnRun()
    begin

    end;

    // -- Manuelle Auslösung des Exports über Action auf der Sales Order List Page Extension
    procedure StartManualExportToNAV(var SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
    begin
        SetExportSalesHeader(SalesHeader, Enum::"BCN Change Type"::Modify);
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindSet() then
            repeat
                SetExportSalesLine(SalesLine, Enum::"BCN Change Type"::Modify);
            until SalesLine.Next() = 0
    end;

    // --- Automatisiertes Befüllen der Exportliste ----------------------------

    local procedure SetExportSalesHeader(SalesHeader: Record "Sales Header"; TypeOfChange: enum "BCN Change Type")
    var
        BCToNAVSalesHeader: Record "BC To NAV Sales Header";
    begin
        IF BCToNAVSalesHeader.Get(SalesHeader."Document Type", SalesHeader."No.") THEN begin
            BCToNAVSalesHeader.TransferFields(SalesHeader);
            BCToNAVSalesHeader.Modify(false)
        end else begin
            BCToNAVSalesHeader.Init();
            BCToNAVSalesHeader."Document Type" := SalesHeader."Document Type";
            BCToNAVSalesHeader."No." := SalesHeader."No.";
            IF NOT (TypeOfChange = enum::"BCN Change Type"::Delete) THEN
                BCToNAVSalesHeader.TransferFields(SalesHeader);
            BCToNAVSalesHeader.Insert(false)
        end;
        case TypeOfChange of
            enum::"BCN Change Type"::Insert:
                BCToNAVSalesHeader."Type Of Change" := 0;
            enum::"BCN Change Type"::Modify:
                BCToNAVSalesHeader."Type Of Change" := 1;
            enum::"BCN Change Type"::Delete:
                BCToNAVSalesHeader."Type Of Change" := 2;
        end;
        BCToNAVSalesHeader.Modify(false);
    end;

    local procedure SetExportSalesLine(SalesLine: Record "Sales Line"; TypeOfChange: enum "BCN Change Type")
    var
        BCToNAVSalesLine: Record "BC To NAV Sales Line";
    begin
        IF BCToNAVSalesLine.Get(SalesLine."Document Type", SalesLine."Document No.", SalesLine."Line No.") THEN begin
            BCToNAVSalesLine.TransferFields(SalesLine);
            BCToNAVSalesLine.Modify(false)
        end else begin
            BCToNAVSalesLine.Init();
            BCToNAVSalesLine."Document Type" := SalesLine."Document Type";
            BCToNAVSalesLine."Document No." := SalesLine."Document No.";
            BCToNAVSalesLine."Line No." := SalesLine."Line No.";
            IF NOT (TypeOfChange = enum::"BCN Change Type"::Delete) THEN
                BCToNAVSalesLine.TransferFields(SalesLine);
            BCToNAVSalesLine.Insert(false)
        end;
        case TypeOfChange of
            enum::"BCN Change Type"::Insert:
                BCToNAVSalesLine."Type Of Change" := 0;
            enum::"BCN Change Type"::Modify:
                BCToNAVSalesLine."Type Of Change" := 1;
            enum::"BCN Change Type"::Delete:
                BCToNAVSalesLine."Type Of Change" := 2;
        end;
        BCToNAVSalesLine.Modify(false)
    end;

    // --- Event Handler: INSERT -----------------------------------------------

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterInsertEvent', '', true, true)]
    local procedure InsertTab18(var Rec: Record Customer; RunTrigger: Boolean)
    begin
        IF Rec.IsTemporary then
            exit;

        //Rec."DCE Has Login" := true;
        //Rec."DCE Shop Code" := 'B2B';
        //Rec."DCE Login E-Mail Addr." := 'Standardmailadresse';
        //case Rec."Country/Region Code" of
        //    'DE', 'AT':
        //        Rec."DCE Language Code" := 'DEU';
        //    else
        //        Rec."DCE Language Code" := 'ENU';
        //end;
        //Rec.Modify(false);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterInsertEvent', '', true, true)]
    local procedure InsertTab36(var Rec: Record "Sales Header"; RunTrigger: Boolean)
    begin
        IF Rec.IsTemporary then
            exit;

#pragma warning disable AL0603
        IF NOT CheckIfDCEOrder(Rec."Document Type", Rec."No.") THEN
#pragma warning restore AL0603
            EXIT;

        SetExportSalesHeader(Rec, Enum::"BCN Change Type"::Insert);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterInsertEvent', '', true, true)]
    local procedure InsertTab37(var Rec: Record "Sales Line"; RunTrigger: Boolean)
    var
        SalesHeader: Record "Sales Header";
    begin
        if Rec.IsTemporary then
            exit;

#pragma warning disable AL0603
        IF NOT CheckIfDCEOrder(Rec."Document Type", Rec."Document No.") THEN
#pragma warning restore AL0603
            EXIT;

        SetExportSalesLine(Rec, Enum::"BCN Change Type"::Insert);
    end;

    // --- Event Handler: MODIFY ----------------------------------------------

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterModifyEvent', '', true, true)]
    local procedure ModifyTab36(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; RunTrigger: Boolean)
    begin
        if Rec.IsTemporary then
            exit;

#pragma warning disable AL0603
        IF NOT CheckIfDCEOrder(Rec."Document Type", Rec."No.") THEN
#pragma warning restore AL0603
            EXIT;

        if IsReleaseOnlyChange(Rec, xRec) then
            exit;

        SetExportSalesHeader(Rec, Enum::"BCN Change Type"::Modify);
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterModifyEvent', '', true, true)]
    local procedure ModifyTab37(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; RunTrigger: Boolean)
    begin
        if Rec.IsTemporary then
            exit;

#pragma warning disable AL0603
        IF NOT CheckIfDCEOrder(Rec."Document Type", Rec."Document No.") THEN
#pragma warning restore AL0603
            EXIT;

        SetExportSalesLine(Rec, Enum::"BCN Change Type"::Modify);
    end;

    // --- Event Handler: DELETE ----------------------------------------------
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterDeleteEvent', '', true, true)]
    local procedure DeleteTab36(var Rec: Record "Sales Header"; RunTrigger: Boolean)
    begin
        if Rec.IsTemporary then
            exit;

#pragma warning disable AL0603
        IF NOT CheckIfDCEOrder(Rec."Document Type", Rec."No.") THEN
#pragma warning restore AL0603
            EXIT;

        SetExportSalesHeader(Rec, Enum::"BCN Change Type"::Delete);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterDeleteEvent', '', true, true)]
    local procedure DeleteTab37(var Rec: Record "Sales Line"; RunTrigger: Boolean)
    begin
        if Rec.IsTemporary then
            exit;

#pragma warning disable AL0603
        IF NOT CheckIfDCEOrder(Rec."Document Type", Rec."Document No.") THEN
#pragma warning restore AL0603
            EXIT;

        SetExportSalesLine(Rec, enum::"BCN Change Type"::Delete);
    end;

    // Helper Functions
    local procedure CheckIfDCEOrder(Status: Integer; DocumentNo: Code[20]): Boolean
    var
        SalesHeader: Record "Sales Header";
    begin
        EXIT(SalesHeader.GET(Status, DocumentNo) AND (SalesHeader."DCE Order No." <> '') AND (SalesHeader."Document Type" = SalesHeader."Document Type"::Order));
    end;

    local procedure IsReleaseOnlyChange(Rec: Record "Sales Header"; xRec: Record "Sales Header"): Boolean
    begin
        exit((Rec.Status = Rec.Status::Released) and (xRec.Status <> Rec.Status));
    end;
}

enum 50100 "BCN Change Type"
{
    Extensible = false;
    value(0; Insert) { Caption = 'Insert'; }
    value(1; Modify) { Caption = 'Modify'; }
    value(2; Delete) { Caption = 'Delete'; }
}
