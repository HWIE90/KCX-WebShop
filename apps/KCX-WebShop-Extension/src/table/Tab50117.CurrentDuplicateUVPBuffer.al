table 50117 "Current Duplicate UVP Buffer"
{
    Caption = 'Current Duplicate UVP Buffer';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(3; "Sales Code"; Code[20])
        {
            Caption = 'Sales Code';
        }
        field(4; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
        }
        field(5; "Sales Type"; Text[30])
        {
            Caption = 'Sales Type';
        }
        field(6; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
        }
        field(7; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
        }
        field(8; "Minimum Quantity"; Decimal)
        {
            Caption = 'Minimum Quantity';
        }
        field(9; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
        }
        field(10; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(11; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(12; "Active Entry Count"; Integer)
        {
            Caption = 'Active Entry Count';
        }
        field(13; "Source Record ID"; Text[250])
        {
            Caption = 'Source Record ID';
        }
        field(14; "Item Key"; Text[250])
        {
            Caption = 'Item Key';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(ItemKey; "Item Key", "Entry No.")
        {
        }
    }
}
