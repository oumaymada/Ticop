namespace Ticop_pharmatec.Ticop_pharmatec;

using Microsoft.Purchases.Document;

report 50106 PurchaseOrderReport
{
    ApplicationArea = All;
    Caption = 'PurchaseOrderReport';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'PurchaseOrder.rdl';
    DefaultLayout = RDLC;
    dataset
    {

        dataitem(PurchaseHeader; "Purchase Header")
        {
            column(BuyfromVendorName; "Buy-from Vendor Name")
            {
            }
            column(Buy_from_Address; "Buy-from Address")
            {

            }
            column(Buy_from_City; "Buy-from City")
            {
            }
            column(BuyfromVendorNo; "Buy-from Vendor No.")
            {
            }
            column(Buy_from_Contact; "Buy-from Contact")
            { }
            column(Amount; Amount)
            { //AutoCalcField = true;
            }
            column(AmountIncludingVAT; "Amount Including VAT")
            {
            }





            column(No; "No.")
            {
            }
            column(Purchaser_Code; "Purchaser Code")
            { }
            column(Payment_Terms_Code; "Payment Terms Code")
            { }
            column(Order_Date; "Order Date")
            { }

            column(totalTVA; totalTVA)
            {

            }



            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemLinkReference = PurchaseHeader;
                DataItemTableView = order(ascending);

                column(Line_No_; "Line No.")
                {

                }
                column(DescriptionLine; Description)
                {

                }
                column(QuantityLine; Quantity)
                { }
                column(Unit_CostLine; "Unit Cost")
                { }
                column(Unit_Price; "Unit Price (LCY)")
                {

                }
                column(Item_Reference_No_; "No.")
                { }

                column(Amountline; Amount)
                { }
                column(Line_Amount; "Line Amount") { }
                column(Line_Discount__; "Line Discount %") { }

                column(Amount_Including_VATLine; "Amount Including VAT")
                { }

                column(Item_Category_CodeLine; "Item Category Code")
                { }

                column(VAT_Prod__Posting_GroupLine; "VAT Prod. Posting Group")
                { }
                column(VAT_Base_AmountLine; "VAT Base Amount")
                { }
                column(VAT__Line; "VAT %")
                { }






                /*  trigger OnAfterGetRecord()

                  begin



                     totalTVA += "Amount" * "VAT %";


                  end;

                  /*  trigger OnPostDataItem()
                    begin
                        totalTVA += "Amount Including VAT" - Amount;
                    end;*/




            }
            trigger OnAfterGetRecord()


            begin
                totalTVA += "Amount Including VAT" - Amount;
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
        /*MontantNet: Decimal;
        TotalBrut: Decimal;
        montant: Decimal;
        tva: Decimal;*/
        totalTVA: Decimal;

}
