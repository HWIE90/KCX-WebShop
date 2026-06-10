page 50115 "BC To NAV Default Dim. List"
{

    ApplicationArea = All;
    Caption = 'Default Dimension List';
    PageType = List;
    SourceTable = "Default Dimension";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("TableID"; Rec."Table ID") { }

                field("No"; Rec."No.") { }

                field("DimensionCode"; Rec."Dimension Code") { }

                field("DimensionValueCode"; Rec."Dimension Value Code") { }

            }
        }
    }
}
