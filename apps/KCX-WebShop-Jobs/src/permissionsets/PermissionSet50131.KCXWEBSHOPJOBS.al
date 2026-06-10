permissionset 50131 "KCX WEBSHOP JOBS"
{
    Assignable = true;
    Caption = 'KCX WebShop Jobs';

    Permissions =
        codeunit "KCX Job Queue Warning Mgt." = X,
        page "KCX Job Queue Email Test" = X,
        page "KCX Job Queue Warning Setup" = X,
        table "KCX Job Queue Warning Setup" = X,
        tabledata "KCX Job Queue Warning Setup" = RIMD,
        table "Job Warning Log" = X,
        tabledata "Job Warning Log" = RIMD;
}
