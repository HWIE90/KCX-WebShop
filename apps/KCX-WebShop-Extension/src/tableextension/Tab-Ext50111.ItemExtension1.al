tableextension 50111 "Item Extension 1" extends Item
{
    fields
    {
        field(50110; "NAV Inventory Location 1"; Decimal)
        {
            Caption = 'NAV Inventory Location 1';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50111; "NAV Inventory Location 1 no WA"; Decimal)
        {
            Caption = 'NAV Inventory Location 1 no WA';
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }
}