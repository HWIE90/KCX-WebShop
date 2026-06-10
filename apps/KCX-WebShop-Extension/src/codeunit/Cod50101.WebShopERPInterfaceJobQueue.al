codeunit 50101 "WebShop ERP-Interface JobQueue"
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

    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        NavToBC: Record "NAV To BC Import List";
        WebShopERPInterfaceMgt: Codeunit "WebShop ERP-Interface Mgt.";
        TableNoPar: Text;
        StatusPar: Text;
        TypeOfchangePar: Text;
    begin
        TableNoPar := SELECTSTR(1, Rec."Parameter String");
        StatusPar := SELECTSTR(2, Rec."Parameter String");
        TypeOfchangePar := SELECTSTR(3, Rec."Parameter String");

        IF TableNoPar = 'Archive' THEN begin
            WebShopERPInterfaceMgt.ArchiveData();
            EXIT;
        end else
            NavToBC.SetFilter(TableNo, TableNoPar);
        IF StatusPar IN ['0', '1', '2'] THEN
            NavToBC.SetFilter(Status, StatusPar);
        IF TypeOfchangePar IN ['0', '1', '2'] THEN
            NavToBC.SetFilter(TypeOfchange, TypeOfchangePar);

        WebShopERPInterfaceMgt.ImportNAVToBC(NavToBC);
    end;
}
