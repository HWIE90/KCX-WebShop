codeunit 50102 "Release Sales Orders Job Queue"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange(Status, SalesHeader.Status::Open);
        SalesHeader.SetFilter("DCE Order No.", '<>%1', '');

        if Rec."Parameter String" <> '' then
            SalesHeader.SetFilter("No.", Rec."Parameter String");

        ReleaseSalesOrders(SalesHeader);
    end;

    local procedure ReleaseSalesOrders(var SalesHeader: Record "Sales Header")
    begin
        if not SalesHeader.FindSet(true) then
            exit;

        repeat
            if ShouldReleaseSalesHeader(SalesHeader) then
                ReleaseSingleSalesOrder(SalesHeader);
        until SalesHeader.Next() = 0;
    end;

    local procedure ShouldReleaseSalesHeader(SalesHeader: Record "Sales Header"): Boolean
    begin
        if not IsLastOpenWebShopOrder(SalesHeader) then
            exit(true);

        exit(SalesHeader."Posting Date" < Today);
    end;

    local procedure IsLastOpenWebShopOrder(SalesHeader: Record "Sales Header"): Boolean
    var
        LastSalesHeader: Record "Sales Header";
    begin
        LastSalesHeader.SetCurrentKey("Document Type", "No.");
        LastSalesHeader.SetRange("Document Type", SalesHeader."Document Type");
        LastSalesHeader.SetRange(Status, LastSalesHeader.Status::Open);
        LastSalesHeader.SetFilter("DCE Order No.", '<>%1', '');
        LastSalesHeader.SetFilter("No.", '%1', CopyStr(SalesHeader."No.", 1, 4) + '*');

        if not LastSalesHeader.FindLast() then
            exit(false);

        exit(LastSalesHeader."No." = SalesHeader."No.");
    end;

    [TryFunction]
    local procedure ReleaseSingleSalesOrder(var SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        ReleaseSalesDocument: Codeunit "Release Sales Document";
    begin
        // Set "Qty. to Assemble" to 0 on all sales lines as BC is only a pass-through system and assembly orders are not relevant
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindSet(true) then
            repeat
                if SalesLine."Qty. to Assemble to Order" <> 0 then begin
                    SalesLine.VALIDATE("Qty. to Assemble to Order", 0);
                    SalesLine.Modify();
                end;
            until SalesLine.Next() = 0;

        ReleaseSalesDocument.PerformManualRelease(SalesHeader);
    end;
}
