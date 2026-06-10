page 50114 "BC To NAV Sales Line"
{
    ApplicationArea = All;
    Caption = 'BC To NAV Sales Line';
    PageType = List;
    SourceTable = "BC To NAV Sales Line";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("DocumentType"; Rec."Document Type") { }
                field("DocumentNo"; Rec."Document No.") { }
                field("LineNo"; Rec."Line No.") { }
                field("Type"; Rec."Type") { }
                field("No"; Rec."No.") { }
                field("VariantCode"; Rec."Variant Code") { }
                field("LocationCode"; Rec."Location Code") { }
                field(Quantity; Rec.Quantity) { }
                field(UnitPrice; Rec."Unit Price") { }
                field(Amount; Rec.Amount) { }
                field(AmountIncludingVAT; Rec."Amount Including VAT") { }
                field("LineAmount"; Rec."Line Amount") { }
                field("TypeOfChange"; Rec."Type of Change") { }
                field(Description; Rec.Description) { }
            }
        }
    }
}
