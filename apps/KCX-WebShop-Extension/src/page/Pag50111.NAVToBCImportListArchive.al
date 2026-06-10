page 50111 "NAV To BC Import List Archive"
{
    ApplicationArea = All;
    Caption = 'NAV To BC Import List Archive';
    PageType = List;
    SourceTable = "NAV To BC Import List Archive";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(EntryNo; Rec.EntryNo) { }

                field(TableNo; Rec.TableNo) { }
                field(TableName; Rec.TableName) { }
                field("FieldNo"; Rec.FieldNo) { }
                field(FieldName; Rec.FieldName) { }
                field(NAVContent; Rec.NAVContent) { }
                field(NAVRecordID; Rec.RecordID) { }
                field(TypeOfChange; Rec.TypeOfChange) { }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                action("Restore Archived Item Entries")
                {
                    ApplicationArea = Suite;
                    Caption = 'Restore Archived Item Entries';
                    Image = Restore;
                    ToolTip = 'Restores archived item import entries from the selected period back to the import list.';

                    trigger OnAction()
                    var
                        WebShopCorrectionMgt: Codeunit "WebShop Correction Mgt.";
                    begin
                        WebShopCorrectionMgt.RunRestoreArchivedEntries();
                    end;
                }

                action("Show Missing DCE Items")
                {
                    ApplicationArea = Suite;
                    Caption = 'Show Missing DCE Items';
                    Image = CheckList;
                    ToolTip = 'Shows DCE webshop items that do not have a corresponding item in Business Central.';

                    trigger OnAction()
                    var
                        WebShopCorrectionMgt: Codeunit "WebShop Correction Mgt.";
                    begin
                        WebShopCorrectionMgt.ShowMissingDCEItemsWithoutBCItem();
                    end;
                }

                action("Show Current Duplicate UVP Prices")
                {
                    ApplicationArea = Suite;
                    Caption = 'Show Current Duplicate UVP Prices';
                    Image = Price;
                    ToolTip = 'Shows all currently valid UVP entries from table 5276536 where more than one active entry exists per article.';

                    trigger OnAction()
                    var
                        WebShopCorrectionMgt: Codeunit "WebShop Correction Mgt.";
                    begin
                        WebShopCorrectionMgt.ShowCurrentDuplicateUVPPrices();
                    end;
                }

                action("Set Customer Location Code to 1")
                {
                    ApplicationArea = Suite;
                    Caption = 'Set Customer Location Code to 1';
                    Image = Change;
                    ToolTip = 'Updates all customers with a non-empty location code other than 1 to location code 1.';

                    trigger OnAction()
                    var
                        WebShopCorrectionMgt: Codeunit "WebShop Correction Mgt.";
                    begin
                        WebShopCorrectionMgt.UpdateCustomerLocationCodeToOne();
                    end;
                }
            }
        }
    }
}
