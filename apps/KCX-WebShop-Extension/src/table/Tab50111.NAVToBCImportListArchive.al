table 50111 "NAV To BC Import List Archive"
{
    Caption = 'NAV To BC Buffer Archive';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; EntryNo; BigInteger)
        {
            AutoIncrement = true;
        }
        field(10; TableNo; Integer)
        {
        }
        field(11; "FieldNo"; Integer)
        {
        }
        field(12; TableName; Text[30])
        {
        }
        field(13; FieldName; Text[30])
        {
        }
        field(14; NAVContent; Text[250])
        {
        }
        field(15; RecordID; Text[250])
        {
        }
        field(16; TypeOfChange; Integer)
        {
        }
        field(20; Status; Integer)
        {
        }
    }

    keys
    {
        key(PK; EntryNo)
        {
            Clustered = true;
        }
        key(Key2; "RecordID", "FieldNo")
        {
        }
        key(Key3; TableNo, Status, TypeOfChange)
        {
        }
    }
}
