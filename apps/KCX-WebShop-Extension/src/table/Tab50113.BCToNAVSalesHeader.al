table 50113 "BC To NAV Sales Header"
{
    Caption = 'BC To NAV Sales Header';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document Type"; Enum "Sales Document Type")
        {

        }
        field(2; "Sell-to Customer No."; Code[20])
        {

        }
        field(3; "No."; Code[20])
        {

        }
        field(4; "Bill-to Customer No."; Code[20])
        {

        }
        field(5; "Bill-to Name"; Text[100])
        {

        }
        field(6; "Bill-to Name 2"; Text[50])
        {

        }
        field(7; "Bill-to Address"; Text[100])
        {

        }
        field(8; "Bill-to Address 2"; Text[50])
        {

        }
        field(9; "Bill-to City"; Text[30])
        {

        }
        field(10; "Bill-to Contact"; Text[100])
        {

        }
        field(11; "Your Reference"; Text[35])
        {

        }
        field(12; "Ship-to Code"; Code[10])
        {

        }
        field(13; "Ship-to Name"; Text[100])
        {

        }
        field(14; "Ship-to Name 2"; Text[50])
        {

        }
        field(15; "Ship-to Address"; Text[100])
        {

        }
        field(16; "Ship-to Address 2"; Text[50])
        {

        }
        field(17; "Ship-to City"; Text[30])
        {

        }
        field(18; "Ship-to Contact"; Text[100])
        {

        }
        field(19; "Order Date"; Date)
        {

        }
        field(20; "Posting Date"; Date)
        {

        }
        field(21; "Shipment Date"; Date)
        {

        }

        field(23; "Payment Terms Code"; Code[10])
        {

        }
        field(24; "Due Date"; Date)
        {

        }
        field(27; "Shipment Method Code"; Code[10])
        {

        }
        field(28; "Location Code"; Code[10])
        {

        }
        field(29; "Shortcut Dimension 1 Code"; Code[20])
        {

        }
        field(30; "Shortcut Dimension 2 Code"; Code[20])
        {

        }
        field(31; "Customer Posting Group"; Code[20])
        {

        }
        field(32; "Currency Code"; Code[10])
        {

        }
        field(33; "Currency Factor"; Decimal)
        {

        }
        field(34; "Customer Price Group"; Code[10])
        {

        }
        field(35; "Prices Including VAT"; Boolean)
        {

        }

        field(40; "Customer Disc. Group"; Code[20])
        {

        }
        field(41; "Language Code"; Code[10])
        {

        }
        field(43; "Salesperson Code"; Code[20])
        {

        }
        field(70; "VAT Registration No."; Text[20])
        {

        }
        field(74; "Gen. Bus. Posting Group"; Code[20])
        {

        }
        field(78; "VAT Country/Region Code"; Code[10])
        {

        }
        field(79; "Sell-to Customer Name"; Text[100])
        {

        }
        field(80; "Sell-to Customer Name 2"; Text[50])
        {

        }
        field(81; "Sell-to Address"; Text[100])
        {

        }
        field(82; "Sell-to Address 2"; Text[50])
        {

        }
        field(83; "Sell-to City"; Text[30])
        {

        }
        field(84; "Sell-to Contact"; Text[100])
        {

        }
        field(85; "Bill-to Post Code"; Code[20])
        {

        }
        field(86; "Bill-to County"; Text[30])
        {

        }
        field(87; "Bill-to Country/Region Code"; Code[10])
        {

        }
        field(88; "Sell-to Post Code"; Code[20])
        {

        }
        field(89; "Sell-to County"; Text[30])
        {

        }
        field(90; "Sell-to Country/Region Code"; Code[10])
        {

        }
        field(91; "Ship-to Post Code"; Code[20])
        {

        }
        field(92; "Ship-to County"; Text[30])
        {

        }
        field(93; "Ship-to Country/Region Code"; Code[10])
        {

        }
        field(99; "Document Date"; Date)
        {

        }
        field(104; "Payment Method Code"; Code[10])
        {

        }
        field(105; "Shipping Agent Code"; Code[10])
        {

        }
        field(120; Status; Enum "Sales Document Status")
        {

        }
        field(5052; "Sell-to Contact No."; Code[20])
        {

        }
        field(5053; "Bill-to Contact No."; Code[20])
        {

        }
        field(5791; "Promised Delivery Date"; Date)
        {

        }
        field(50000; "Type Of Change"; Integer)
        {
        }
        field(5447300; "DCE Order No."; Code[30])
        {
        }
    }

    keys
    {
        key(Key1; "Document Type", "No.")
        {
            Clustered = true;
        }
    }
}