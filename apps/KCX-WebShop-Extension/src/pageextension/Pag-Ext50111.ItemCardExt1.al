pageextension 50111 "Item Card Ext 1" extends "Item Card"
{
    layout
    {
        addlast(InventoryGrp) // oder ein anderer Bereich, z. B. "General" oder "Item FastTab"
        {
            group("NAV Bestandsdaten")
            {
                Caption = 'NAV Bestandsdaten';
                field("NAV Inventory Location 1"; Rec."NAV Inventory Location 1")
                {
                    Caption = 'NAV Bestand Lager 1';
                    ApplicationArea = All;
                }
                field("NAV Inventory Location 1 no WA"; Rec."NAV Inventory Location 1 no WA")
                {
                    Caption = 'NAV Bestand Lager 1 ohne WA';
                    ApplicationArea = All;
                }
            }
        }
    }
}
