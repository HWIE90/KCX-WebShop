permissionset 50100 "KCX WEBSHOP"
{
    Assignable = true;
    Caption = 'KCX WebShop';

    Permissions =
        codeunit "BC to NAV Event Handler" = X,
        codeunit "Release Sales Orders Job Queue" = X,
        codeunit "WebShop ERP-Interface Mgt." = X,
        codeunit "BC To NAV API Mgt." = X,
        codeunit "WebShop Correction Mgt." = X,
        page "NAV To BC Import List" = X,
        page "NAV To BC Import List Archive" = X,
        page "BC To NAV Customer" = X,
        page "BC To NAV Sales Header" = X,
        page "BC To NAV Sales Line" = X,
        page "WebShop Restore Dialog" = X,
        page "Missing DCE Item List" = X,
        page "Current Duplicate UVP List" = X,
        table "NAV To BC Import List" = X,
        tabledata "NAV To BC Import List" = RIMD,
        table "NAV To BC Import List Archive" = X,
        tabledata "NAV To BC Import List Archive" = RIMD,
        table "BC To NAV Export List" = X,
        tabledata "BC To NAV Export List" = RIMD,
        table "BC To NAV Sales Header" = X,
        tabledata "BC To NAV Sales Header" = RIMD,
        table "BC To NAV Sales Line" = X,
        tabledata "BC To NAV Sales Line" = RIMD,
        table "Missing DCE Item Buffer" = X,
        tabledata "Missing DCE Item Buffer" = RIMD,
        table "Current Duplicate UVP Buffer" = X,
        tabledata "Current Duplicate UVP Buffer" = RIMD;
}
