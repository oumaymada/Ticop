
report 50005 "Reliquat Opportunité"
{
    ApplicationArea = All;
    Caption = 'Reliquat Opportunité Pharmatec';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'SuiviArticle.rdl';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem(Opportunity; Opportunity)
        {
            RequestFilterFields = "No.";
            column(numcommande; ncommande)
            { }
            // column(Quote_No; "Quote No")
            //{ }
            column(No_; "No.")
            { }



            dataitem(Header; "Sales Header Archive")
            {
                DataItemLink = "Opportunity No." = field("No.");
                DataItemLinkReference = Opportunity;
                DataItemTableView = where("Document Type" = const(Quote));


                column(Quote_No; "no." + '-' + format(ArchivedQuote."Version No.")) { }
                column(Sell_to_Customer_No_; "Sell-to Customer No.")
                { }
                column(Sell_to_Customer_Name; "Sell-to Customer Name")
                { }
                column(Sell_to_E_Mail; "Sell-to E-Mail")
                { }



                dataitem(Line; "Sales Line Archive")
                {
                    DataItemLink = "Document type" = field("Document type"),
                                                     "Document No." = field("No."),
                                                     "version No." = field("version No.");
                    DataItemLinkReference = Header;

                    column(No_Article;
                    "No.")
                    { }
                    column(Description; Description)
                    { }
                    column(Quantity_devis; Quantity)
                    { }
                    column(Quantity_cmd; Quantity_cmd)
                    { }
                    column(Quantity_BL; Quantity_BL) { }


                    trigger OnAfterGetRecord()
                    var
                        BL: Record "Sales Shipment Header";
                        LineBL: Record "Sales Shipment Line";
                        OrderLine: Record "Sales Line";

                    begin
                        Quantity_cmd := 0;
                        Quantity_BL := 0;

                        OrderLine.setrange("Document Type", OrderLine."Document Type"::Order);
                        OrderLine.SetRange("Document No.", ncommande);
                        OrderLine.setfilter("No.", line."No.");
                        if OrderLine.FindFirst() then begin
                            OrderLine.CalcSums("Outstanding Qty. (Base)");
                            Quantity_cmd := OrderLine."Outstanding Qty. (Base)";
                        end;


                        bl.SetFilter(bl."Opportunity No.", Opportunity."No.");
                        if BL.FindFirst() then
                            repeat
                                LineBL.SetFilter("Document No.", bl."No.");
                                LineBL.setfilter("No.", line."No.");
                                if LineBL.FindFirst() then begin
                                    LineBL.CalcSums(Quantity);
                                    Quantity_BL += Linebl.Quantity;
                                end;
                            until bl.Next() = 0;

                        //CurrReport.Skip();


                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange("Statut lig. devis", "Statut lig. devis"::"Gagné");
                    end;
                }
                trigger OnPreDataItem()
                begin
                    SetRange("Version No.", ArchivedQuote."Version No.");

                end;
            }

            trigger OnAfterGetRecord()
            var
                SH: Record "Sales Header";

            begin
                SH.SetRange("Document Type", sh."Document Type"::Order);
                sh.SetFilter(sh."Opportunity No.", "No.");
                if sh.FindFirst() then
                    ncommande := SH."No.";
                ArchivedQuote.SetRange("Document Type", sh."Document Type"::Quote);
                ArchivedQuote.SetFilter("Opportunity No.", "No.");
                ArchivedQuote.FindLast();


            end;

        }

    }

    var
        Quantity_BL: Decimal;
        Quantity_cmd: Decimal;
        ArchivedQuote: Record "Sales Header Archive";
        ncommande: Code[25];

}
