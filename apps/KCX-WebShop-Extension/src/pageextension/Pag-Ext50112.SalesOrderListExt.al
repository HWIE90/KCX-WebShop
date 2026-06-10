pageextension 50112 "Sales Order List Ext" extends "Sales Order List"
{
    actions
    {
        addlast(Processing)
        {
            group(WebShop)
            {
                action("Start Manual Export To NAV")
                {
                    Caption = 'Start Manual Export To NAV';
                    ApplicationArea = All;
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                        BCtoNaveEventHandler: Codeunit "BC to NAV Event Handler";
                    begin
                        BCtoNaveEventHandler.StartManualExportToNAV(Rec);
                        Message(StrSubstNo('Export to NAV process has been started. Order %1 is being processed.', Rec."No."));
                    end;
                }
            }
        }
    }
}
