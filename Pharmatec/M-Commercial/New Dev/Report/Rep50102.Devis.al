/// <summary>
/// Report QuoteReport (ID 50102).
/// </summary>
report 50102 QuoteReport
{
    ApplicationArea = All;
    Caption = 'Devis Pharmatec';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'devis.rdl';
    DefaultLayout = RDLC;

    dataset
    {

        dataitem(SalesHeader; "Sales Header")
        {
            RequestFilterFields = "Sell-to Customer No.", "Posting Date";

            column(Sell_to_Customer_No_;
            "Sell-to Customer No.")
            {
                IncludeCaption = true;
            }
            column(Stamp_Amount; "Stamp Amount")
            { }
            column(Document_Date; "Document Date")
            {

            }
            column(No_document; "No.")
            {

            }
            column(Order_Date; "Order Date")
            {

            }
            column(Sell_to_Customer_Name; "Sell-to Customer Name")
            {
                IncludeCaption = true;
            }
            column(Posting_Date; "Document Date")
            {
                IncludeCaption = true;
            }
            column(Sell_to_Address; "Sell-to Address")
            {
                IncludeCaption = true;
            }
            column(numcommande; ncommande)
            { }


            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemLinkReference = SalesHeader;

                column(No_;
                "No.")
                {
                    IncludeCaption = true;
                }
                column(Line_Discount__; "Line Discount %")
                {

                }
                column(Description; Description)
                {
                    IncludeCaption = true;
                }
                column(Quantity; Quantity)
                {
                    IncludeCaption = true;
                }
                column(Unit_Price; "Unit Price")
                {
                    IncludeCaption = true;
                }
                column(Line_Amount; "Line Amount")
                {
                    IncludeCaption = true;
                }
                column(Amount; Amount)
                {
                    IncludeCaption = true;
                }
                column(Item_Reference_No_; "Item Reference No.")
                {
                    IncludeCaption = true;
                }
                column(VAT__; "VAT %")
                {
                    IncludeCaption = true;
                }
                column(MontantNet; MontantNet)
                {

                }
                column(totalTVA; totalTVA)
                {

                }
                column(montant; montant)
                { }
                column(tva; tva)
                { }
                column(TotalBrut; TotalBrut)
                { }
                column(Remise; Remise)
                { }
                column(totalremise; totalremise)
                { }
                trigger OnAfterGetRecord()
                var
                begin

                    //"Sales Shipment Line".get("Document No.");
                    //"Sales Shipment Line".get("Document No.", "Line No.");
                    ncommande := '';
                    // if SalesShipmentHeader.FindLast() then
                    //   ncommande := SalesShipmentHeader."No.";


                    montant := Round("Sales Line".Amount);
                    tva := Round(montant * "VAT %" / 100);
                    TotalBrut += montant;
                    totalTVA := tva;
                    MontantNet := TotalBrut + totalTVA;
                    Remise := montant - (montant * "Line Discount %" / 100);
                    totalremise += Remise;

                end;

            }
            trigger OnAfterGetRecord()
            begin
                ncommande := '';
                SH2.SetRange("Document Type", "Document Type"::Order);
                SH2.SetFilter("Quote No.", "No.");
                if SH2.FindLast() then
                    ncommande := SH2."No.";



            end;

        }

    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {

            }
        }
    }
    var
        SH2: Record "Sales Header";
        ncommande: Code[25];
        MontantNet: Decimal;
        TotalBrut: Decimal;
        montant: Decimal;
        tva: Decimal;
        totalTVA: Decimal;
        Remise: Decimal;
        totalremise: Decimal;

}
