page 50119 "Current Duplicate UVP List"
{
    ApplicationArea = All;
    Caption = 'Current Duplicate UVP Prices';
    Editable = false;
    PageType = List;
    SourceTable = "Current Duplicate UVP Buffer";
    SourceTableTemporary = true;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Sales Code"; Rec."Sales Code")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Sales Type"; Rec."Sales Type")
                {
                    ApplicationArea = All;
                }
                field("Variant Code"; Rec."Variant Code")
                {

                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
                field("Minimum Quantity"; Rec."Minimum Quantity")
                {
                    ApplicationArea = All;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = All;
                }
                field("Active Entry Count"; Rec."Active Entry Count")
                {
                    ApplicationArea = All;
                }
                field("Source Record ID"; Rec."Source Record ID")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    procedure Load(var TempDuplicateBuffer: Record "Current Duplicate UVP Buffer" temporary)
    begin
        Rec.Reset();
        Rec.DeleteAll();

        if not TempDuplicateBuffer.FindSet() then
            exit;

        repeat
            Rec := TempDuplicateBuffer;
            Rec.Insert();
        until TempDuplicateBuffer.Next() = 0;
    end;
}
