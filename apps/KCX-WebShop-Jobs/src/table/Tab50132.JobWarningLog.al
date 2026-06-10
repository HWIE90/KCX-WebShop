table 50132 "Job Warning Log"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Job Queue Entry ID"; Guid)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Warning Type"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Last Warning DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Job Queue Entry ID", "Warning Type")
        {
            Clustered = true;
        }
    }
}