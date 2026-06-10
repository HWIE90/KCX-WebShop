page 50113 "BC To NAV Sales Header"
{

    ApplicationArea = All;
    Caption = 'BC To NAV Sales Header';
    PageType = List;
    SourceTable = "BC To NAV Sales Header";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                // --- Schlüssel/Fachfelder (für Filter/DELETE besonders wichtig)
                field("Document Type"; Rec."Document Type") { }
                field("No"; Rec."No.") { }
                field("SellToCustomerNo."; Rec."Sell-to Customer No.") { }

                // --- übrige Felder (1:1 aus deiner List-Page übernommen)
                field("BillToContactNo"; Rec."Bill-to Contact No.") { }
                field("PromisedDeliveryDate"; Rec."Promised Delivery Date") { }
                field("PaymentMethodCode"; Rec."Payment Method Code") { }
                field(ShippingAgentCode; Rec."Shipping Agent Code") { }
                field(VATRegistrationNo; Rec."VAT Registration No.") { }
                field(GenBusPostingGroup; Rec."Gen. Bus. Posting Group") { }
                field(VATCountryRegionCode; Rec."VAT Country/Region Code") { }
                field(SellToCustomerName; Rec."Sell-to Customer Name") { }
                field(SellToCustomerName2; Rec."Sell-to Customer Name 2") { }
                field(SellToAddress2; Rec."Sell-to Address 2") { }
                field(SellToAddress; Rec."Sell-to Address") { }
                field(SellToCity; Rec."Sell-to City") { }
                field(SellToPostCode; Rec."Sell-to Post Code") { }
                field(BillToPostCode; Rec."Bill-to Post Code") { }
                field(BillToCounty; Rec."Bill-to County") { }
                field(BillToCountryRegionCode; Rec."Bill-to Country/Region Code") { }
                field(SellToCounty; Rec."Sell-to County") { }
                field(SellToContact; Rec."Sell-to Contact") { }
                field(SellToCountryRegionCode; Rec."Sell-to Country/Region Code") { }
                field(ShipToPostCode; Rec."Ship-to Post Code") { }
                field(ShipToCounty; Rec."Ship-to County") { }
                field(ShipToCountryRegionCode; Rec."Ship-to Country/Region Code") { }
                field(ShipmentMethodCode; Rec."Shipment Method Code") { }
                field(LocationCode; Rec."Location Code") { }
                field(ShortcutDimension1Code; Rec."Shortcut Dimension 1 Code") { }
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code") { }
                field(CustomerPostingGroup; Rec."Customer Posting Group") { }
                field(CurrencyCode; Rec."Currency Code") { }
                field(CurrencyFactor; Rec."Currency Factor") { }
                field(CustomerPriceGroup; Rec."Customer Price Group") { }
                field(CustomerDiscGroup; Rec."Customer Disc. Group") { }
                field(LanguageCode; Rec."Language Code") { }
                field(SalespersonCode; Rec."Salesperson Code") { }
                field(PaymentTermsCode; Rec."Payment Terms Code") { }
                field(BillToCustomerNo; Rec."Bill-to Customer No.") { }
                field(BillToName; Rec."Bill-to Name") { }
                field(BillToName2; Rec."Bill-to Name 2") { }
                field(BillToAddress; Rec."Bill-to Address") { }
                field(BillToAddress2; Rec."Bill-to Address 2") { }
                field(BillToCity; Rec."Bill-to City") { }
                field(BillToContact; Rec."Bill-to Contact") { }
                field(YourReference; Rec."Your Reference") { }
                field(ShipToCode; Rec."Ship-to Code") { }
                field(ShipToName2; Rec."Ship-to Name 2") { }
                field(ShipToName; Rec."Ship-to Name") { }
                field(ShipToAddress; Rec."Ship-to Address") { }
                field(ShipToAddress2; Rec."Ship-to Address 2") { }
                field(ShipToCity; Rec."Ship-to City") { }

                field(DocumentDate; Rec."Document Date") { }
                field(DueDate; Rec."Due Date") { }
                field(OrderDate; Rec."Order Date") { }
                field(PostingDate; Rec."Posting Date") { }
                field(ShipmentDate; Rec."Shipment Date") { }

                field(TypeOfChange; Rec."Type of Change") { }
                field(Status; Rec.Status) { }
                field(DCEOrderNo; Rec."DCE Order No.") { }
                field(PricesIncludingVAT; Rec."Prices Including VAT") { }
            }
        }
    }
}