table 50131 "KCX Job Queue Warning Setup"
{
    Caption = 'KCX Job Queue Warning Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(10; Active; Boolean)
        {
            Caption = 'Active';
            InitValue = true;
        }
        field(20; "Notification Emails"; Text[250])
        {
            Caption = 'Notification Emails';
        }
        field(30; "Monitored User IDs"; Text[250])
        {
            Caption = 'Monitored User IDs';
            InitValue = 'DS_DC.AG#EXT#;HENDRIK.WIELAND-EXT';
        }
        field(40; "Ready Warning Minutes"; Integer)
        {
            Caption = 'Ready Warning Minutes';
            InitValue = 60;
            MinValue = 1;
        }
        field(50; "In Process Warning Minutes"; Integer)
        {
            Caption = 'In Process Warning Minutes';
            InitValue = 60;
            MinValue = 1;
        }
        field(60; "Warning Mail Subject"; Text[100])
        {
            Caption = 'Warning Mail Subject';
            InitValue = 'Job Queue Warning';
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
