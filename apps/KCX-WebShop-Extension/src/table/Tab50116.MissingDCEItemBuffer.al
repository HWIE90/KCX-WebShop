table 50116 "Missing DCE Item Buffer"
{
    Caption = 'Missing DCE Item Buffer';
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
        field(3; "Item Shop Code"; Code[10])
        {
            Caption = 'Item Shop Code';
        }
        field(4; "Item Language Code"; Code[10])
        {
            Caption = 'Item Language Code';
        }
        field(5; "Category Line No."; Integer)
        {
            Caption = 'Category Line No.';
        }
        field(6; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
        }
        field(7; "DCE Record ID"; Text[250])
        {
            Caption = 'DCE Record ID';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(ItemNo; "Item No.")
        {
        }
    }
}
