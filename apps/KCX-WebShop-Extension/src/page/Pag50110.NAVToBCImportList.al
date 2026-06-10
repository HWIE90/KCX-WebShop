page 50110 "NAV To BC Import List"
{
    ApplicationArea = All;
    Permissions = tabledata "G/L Entry" = rmid;
    Caption = 'NAV To BC Import List';
    PageType = List;
    SourceTable = "NAV To BC Import List";
    UsageCategory = Lists;

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
                field(Status; Rec.Status) { }
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
                Caption = 'F&unctions';
                Image = "Action";
                action("Change Payment &Tolerance")
                {
                    ApplicationArea = Suite;
                    Caption = 'Daten verarbeiten';
                    Image = ChangePaymentTolerance;
                    ToolTip = '...';

                    trigger OnAction()
                    var
                        WebShopERPInterfaceMgt: Codeunit "WebShop ERP-Interface Mgt.";
                    begin
                        WebShopERPInterfaceMgt.ImportNAVToBC(Rec);
                    end;
                }

                action("Archive Data")
                {
                    ApplicationArea = Suite;
                    Caption = 'Daten archivieren';
                    Image = ChangePaymentTolerance;
                    ToolTip = 'Archiviert erfolgreich eingelesene Daten mit Status 1';

                    trigger OnAction()
                    var
                        WebShopERPInterfaceMgt: Codeunit "WebShop ERP-Interface Mgt.";
                    begin
                        WebShopERPInterfaceMgt.ArchiveData();
                    end;
                }

                /*
                action("Info")
                {
                    ApplicationArea = Suite;
                    Caption = 'Info';
                    Image = ChangePaymentTolerance;
                    ToolTip = '...';

                    trigger OnAction()
                    var
                        TargetRec: RecordRef;
                        Field: FieldRef;
                    begin
                        TargetRec.Open(5447307);
                        TargetRec.FindLast();
                        Message('%1', TargetRec.RecordId);
                    end;
                }
                */
                /*
                action("Delete Table")
                {
                    ApplicationArea = Suite;
                    Caption = 'Tabelle Löschen';
                    Image = ChangePaymentTolerance;
                    ToolTip = '...';

                    trigger OnAction()
                    var
                        RecRef: RecordRef;
                    begin
                        RecRef.Open(5447307);
                        RecRef.DeleteAll(false);
                        Message('Tabelle gelöscht 5447307');
                    end;
                }
                */

            }
        }
    }
}