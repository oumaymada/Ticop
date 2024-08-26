/// <summary>
/// Report InvoiceReport (ID 50103).
/// </summary>
report 50103 InvoiceReport
{
    ApplicationArea = All;
    Caption = 'Facture Pharmatec';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'facture.rdl';
    DefaultLayout = RDLC;
    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            RequestFilterFields = "Sell-to Customer No.";

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
            column(No_; "No.")
            {

            }
            column(Posting_Date; "Posting Date")
            {

            }
            column(Salesperson_Code; "Salesperson Code")
            {

            }
            column(Stamp_Amount; "Stamp Amount")
            { }




            dataitem("SalesInvLines"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                //DataItemLinkReference = "Sales Invoice Header";


                column(VAT__; "VAT %")
                {

                }

                column(Item_Reference_No_; "No.")
                { }
                column(Quantity; Quantity)
                {

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
                column(VAT_Base_Amount; "VAT Base Amount")
                {

                }
                column(MontantNet; MontantNet)
                {

                }
                column(totalTVA; totalTVA)
                {

                }
                column(TotalBrut; TotalBrut)
                { }
                column(tva; tva)
                { }
                column(baseHT; baseHT)
                { }
                column(TotalRemise; TotalRemise)
                { }
                column(montant; montant)
                { }
                column(txtMntTLettres; txtMntTLettres) { }
                dataitem("Item Ledger Entry"; "Item Ledger Entry")
                {
                    DataItemTableView = where("entry type" = filter(Sale));
                    DataItemLink = "Document No." = FIELD("Document No."), "Document line no." = FIELD("Line No.");
                    DataItemLinkReference = SalesInvLines;
                    column(Lots; "Lot no.")
                    { }
                    column(ExpirationDatesGLOBAL; "Expiration Date")
                    { }
                    column(ILE_Qty; -Quantity)
                    { }
                }

                trigger OnPreDataItem()
                var

                begin

                    SetFilter(Type, '%1|%2', Type::" ", type::Item);
                    MontantNet2 := "Sales Invoice Header"."Stamp Amount";
                end;

                trigger OnAfterGetRecord()
                begin

                    //SalesinvoiceL.SetRange("Document No.");
                    // SalesinvoiceL.CalcFields(Amount, "VAT Base Amount");
                    // SalesinvoiceL.SetRange("Document No.", "Line No.");
                    //   SalesinvoiceL.CalcFields(Amount, "VAT Base Amount");*/
                    // if SalesinvoiceL.FindFirst() then begin


                    montant := SalesinvoiceL.Amount;
                    tva := (Amount * "VAT %" / 100);
                    TotalBrut += montant;
                    totalTVA += tva;
                    MontantNet := TotalBrut + totalTVA;
                    MontantNet2 := MontantNet2 + tva + Amount;
                    baseHT += Amount;
                    TotalRemise += "Line Discount Amount";
                    txtMntTLettres := '';
                    MontTlettre."Montant en texte"(txtMntTLettres, MontantNet2);


                end;


                //end;

            }
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
        MontantNet: Decimal;
        TotalBrut: Decimal;
        ExpirationDatesGLOBAL: Text;
        montant: Decimal;
        tva: Decimal;
        totalTVA: Decimal;
        baseHT: Decimal;
        TotalRemise: Decimal;
        txtMntTLettres: text;
        MontantNet2: Decimal;
        timbrefixcal: decimal;
        SalesinvoiceH: Record "Sales Invoice Header";
        SalesinvoiceL: Record "Sales Invoice Line";
        MontTlettre: Codeunit "Montant Toute Lettres";

    local procedure GetLotNos(var ExpirationDates: Text) LotNo: Text[20];
    var
        ILE: Record "Item Ledger Entry";
    begin
        ExpirationDates := '';
        ILE.SetRange("Entry Type", ILE."Entry Type"::Sale);
        ILE.SetFilter("Document No.", "Sales Invoice Header"."No.");
        ILE.SetRange("Document Line No.", SalesinvoiceL."Line No.");
        if ile.FindFirst() Then
            repeat
                LotNo := LotNo + ' ' + ILE."Lot No.";
                ExpirationDates := ExpirationDates + ' ' + Format(ILE."Expiration Date");
            until ILE.Next() = 0;



    end;
}
