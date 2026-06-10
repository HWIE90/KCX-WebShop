page 50112 "BC To NAV Customer"
{
    ApplicationArea = All;
    Caption = 'BCToNAVCustomer';
    PageType = List;
    SourceTable = Customer;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No"; Rec."No.") { }
                field("LocationCode"; Rec."Location Code") { }
                field("ShipmentMethodCode"; Rec."Shipment Method Code") { }
                field("GenBusPostingGroup"; Rec."Gen. Bus. Posting Group") { }
                field("VATBusPostingGroup"; Rec."VAT Bus. Posting Group") { }
                field("CustomerPostingGroup"; Rec."Customer Posting Group") { }
                field("ShippingAgentCode"; Rec."Shipping Agent Code") { }
                field("ShippingAgentServiceCode"; Rec."Shipping Agent Service Code") { }
                field(Name; Rec.Name) { }
                field("Name2"; Rec."Name 2") { }
                field(Address; Rec.Address) { }
                field("Address2"; Rec."Address 2") { }
                field("PostCode"; Rec."Post Code") { }
                field("CountryRegionCode"; Rec."Country/Region Code") { }
                field(City; Rec.City) { }
                field("PhoneNo"; Rec."Phone No.") { }
                field("EMail"; Rec."E-Mail") { }
                field("VATRegistrationNo."; Rec."VAT Registration No.") { }
                field("LanguageCode"; Rec."Language Code") { }
                field("PaymentMethodCode"; Rec."Payment Method Code") { }
                field("PaymentTermsCode"; Rec."Payment Terms Code") { }
                field("CurrencyCode"; Rec."Currency Code") { }
                field("FinChargeTermsCode"; Rec."Fin. Charge Terms Code") { }
                field("ReminderTermsCode"; Rec."Reminder Terms Code") { }
                field("PricesIncludingVAT"; Rec."Prices Including VAT") { }
                field(DCEShopCode; Rec."DCE Shop Code") { }
                field(SalespersonCode; Rec."Salesperson Code") { }
            }
        }
    }
}
