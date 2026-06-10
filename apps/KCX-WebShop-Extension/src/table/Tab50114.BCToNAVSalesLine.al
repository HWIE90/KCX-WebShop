table 50114 "BC To NAV Sales Line"
{
    Caption = 'BC To NAV Sales Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document Type"; Enum "Sales Document Type")
        {
        }
        field(3; "Document No."; Code[20])
        {

        }
        field(4; "Line No."; Integer)
        {

        }
        field(5; Type; Enum "Sales Line Type")
        {

        }
        field(6; "No."; Code[20])
        {

        }

        field(7; "Location Code"; Code[10])
        {

        }
        field(11; Description; Text[100])
        {
        }
        field(15; Quantity; Decimal)
        {

        }
        field(22; "Unit Price"; Decimal)
        {
        }
        field(29; Amount; Decimal)
        {
        }

        field(30; "Amount Including VAT"; Decimal)
        {
        }
        field(103; "Line Amount"; Decimal)
        {
        }
        field(5402; "Variant Code"; Code[10])
        {
        }
        field(50000; "Type Of Change"; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
}