
codeunit 50110 "BC To NAV API Mgt."
{
    [ServiceEnabled]
    procedure DeleteBCToNAVSalesHeader(inputValue: Code[20])
    var
        BcToNAVSalesHeader: Record "BC To NAV Sales Header";
    begin
        IF BcToNAVSalesHeader.GET(BcToNAVSalesHeader."Document Type"::Order, inputValue) THEN
            BcToNAVSalesHeader.DELETE(false);
    end;

    [ServiceEnabled]
    procedure DeleteBCToNAVSalesLine(inputValue: Code[20]; inputValue2: Integer)
    var
        BcToNAVSalesLine: Record "BC To NAV Sales Line";
    begin
        IF BcToNAVSalesLine.GET(BcToNAVSalesLine."Document Type"::Order, inputValue, inputValue2) THEN
            BcToNAVSalesLine.DELETE(false);
    end;
}

