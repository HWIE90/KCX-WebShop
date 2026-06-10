table 50112 "BC To NAV Export List"
{
    Caption = 'BC To NAV Export List';
    DataClassification = CustomerContent;

    fields
    {
        field(1; RecordID; RecordId)
        {
            DataClassification = SystemMetadata;
        }
        field(2; "Type Of Change"; Integer)
        {
            Caption = 'Type Of Change'; // Insert, Modify, Delete
            DataClassification = SystemMetadata;
        }
        field(3; "Table No"; Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(4; "RecID Text"; Text[200])
        {
            DataClassification = SystemMetadata;
        }
        field(5; DateTime; DateTime)
        {
            DataClassification = SystemMetadata;
        }
        field(6; "User ID"; Code[50])
        {
            Caption = 'User ID';
            TableRelation = User."User Name";
            ValidateTableRelation = false;
            NotBlank = true;
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; RecordID)
        {
            Clustered = true;
        }
        key(Key2; "RecID Text") { }
    }
}
