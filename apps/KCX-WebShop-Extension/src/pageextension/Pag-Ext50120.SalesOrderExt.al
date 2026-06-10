pageextension 50120 "Sales Order Ext" extends "Sales Order"
{
    actions
    {
        addlast(Processing)
        {
            group(WebShop)
            {
                action("Fill Missing Prices With UVP")
                {
                    ApplicationArea = All;
                    Caption = 'Fehlende Preise mit UVP füllen';
                    Image = Price;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Trägt in Artikelzeilen ohne Preis den aktuell gültigen UVP aus der UVP-Tabelle ein.';

                    trigger OnAction()
                    var
                        WebShopCorrectionMgt: Codeunit "WebShop Correction Mgt.";
                    begin
                        CurrPage.SaveRecord();
                        WebShopCorrectionMgt.FillMissingSalesOrderLinePricesWithCurrentUVP(Rec);
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }
}
