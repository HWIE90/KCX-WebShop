page 50118 "Missing DCE Item List"
{
    ApplicationArea = All;
    Caption = 'Missing DCE Items';
    Editable = false;
    PageType = List;
    SourceTable = "Missing DCE Item Buffer";
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
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                }
                field("Item Shop Code"; Rec."Item Shop Code")
                {
                    ApplicationArea = All;
                }
                field("Item Language Code"; Rec."Item Language Code")
                {
                    ApplicationArea = All;
                }
                field("Category Line No."; Rec."Category Line No.")
                {
                    ApplicationArea = All;
                }
                field("DCE Record ID"; Rec."DCE Record ID")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    procedure Load(var TempMissingBuffer: Record "Missing DCE Item Buffer" temporary)
    begin
        Rec.Reset();
        Rec.DeleteAll();

        if not TempMissingBuffer.FindSet() then
            exit;

        repeat
            Rec := TempMissingBuffer;
            Rec.Insert();
        until TempMissingBuffer.Next() = 0;
    end;
}
