
report 50101 BPReport
{
    ApplicationArea = All;
    Caption = 'BP Pharmatec';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'BPReport.rdl';
    DefaultLayout = RDLC;
    dataset
    {

        dataitem(SalesHeader; "Sales Header")
        {
            RequestFilterFields = "No.";
            column(Sell_to_Customer_Name; "Sell-to Customer Name")
            {

            }
            column(Sell_to_Customer_No_; "Sell-to Customer No.")
            {

            }
            column(Sell_to_Address; "Sell-to Address")
            {

            }
            column(Sell_to_City; "Sell-to City")
            {

            }
            column(Sell_to_Phone_No_; "Sell-to Phone No.")
            {

            }
            column(Location_Code; "Location Code")
            {

            }
            column(No_; "No.")
            {

            }
            column(Posting_Date; "Posting Date")
            {

            }
            column(Salesperson_Code; "Salesperson Code")
            {

            }
            column(SalesPersonName; SalesPersonName)
            {

            }

            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document type" = FIELD("Document type"), "Document No." = FIELD("No.");
                DataItemLinkReference = SalesHeader;
                DataItemTableView = where("Qty. to Ship" = filter(<> 0));
                column(VAT__;
                "VAT %")
                {

                }
                column(Item_Reference_No_; "Item Reference No.")
                {

                }
                column(Quantity; Quantity_Line/*"Qty. to Ship"*/)
                {

                    //should be Quantity_Line
                }
                column(Shipment_Date; "Shipment Date")
                {

                }
                column(Unit_Price; "Unit Price")
                {

                }
                column(Amount; Amount)
                {

                }
                column(Line_Discount__; "Line Discount %")
                {

                }
                column(Description; Description)
                {

                }
                column(NoI_; "No.")
                { }
                column(VAT_Base_Amount; "VAT Base Amount")
                {

                }
                column(Lots; '')
                {

                }
                column(ExpirationDatesGlobal; '')
                {

                }
                column(EmplacementItem; '')
                {

                }

                dataitem(ReservationEntry; "Reservation Entry")
                {
                    DataItemLink = "Source ID" = FIELD("document No."), "Source Ref. No." = FIELD("Line No.");
                    DataItemLinkReference = "Sales Line";


                    column(Lot_No_; "Lot No.")
                    {

                    }
                    column(Expiration; "Expiration Date")
                    {

                    }
                    column(QtyLot; -"Quantity (Base)")
                    {

                    }
                    trigger OnPreDataItem()
                    begin
                        Quantity_line := "Sales Line"."Qty. to Ship";
                        SetFilter("Quantity (Base)", '<>0');
                        if FindFirst() then
                            Quantity_line := 0

                    end;

                    trigger OnAfterGetRecord()
                    var

                        ILE: Record "Item Ledger Entry";
                    begin
                        ExpirationILE := 0D;
                        ILE.SetCurrentKey("Item No.", "Applied Entry to Adjust");
                        ILE.SetFilter("Item No.", "Sales Line"."No.");
                        ILE.SetCurrentKey("Lot No.");
                        ILE.SetFilter("Lot No.", ReservationEntry."Lot No.");
                        if ILE.FindFirst()
                        then begin
                            ExpirationILE := ILE."Expiration Date";

                        end




                    end;

                }
            }
            trigger OnAfterGetRecord()
            var
                salesEvents: Codeunit SalesEvents;
                SalesP: record "Salesperson/Purchaser";
            begin
                if AssigLotNumbers then
                    salesEvents.AssignLotNoToSalesOrder("Document Type", "No.");






                SalesP.SetRange("Code", SalesHeader."Salesperson Code");

                if SalesP.FindFirst() then
                    SalesPersonName := SalesP.Name;

            end;


        }

    }


    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field("Affecter numéros de lot"; AssigLotNumbers)
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Affecter numéros de lot selon les date de péremption (FIFO)';
                    }
                }
            }
        }

    }
    trigger OnInitReport()
    begin
        AssigLotNumbers := true;
    end;

    var
        ExpirationILE: Date;
        AssigLotNumbers: Boolean;
        SalesPersonName: Text[50];
        Quantity_line: Decimal;
}
