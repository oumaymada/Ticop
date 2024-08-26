/// <summary>
/// Unknown Pharmatec_Ticop.
/// </summary>
namespace Pharmatec_Ticop.Pharmatec_Ticop;

using Microsoft.Sales.History;
using Microsoft.Inventory.Ledger;
using Microsoft.CRM.Team;

report 50004 BL
{
    Caption = 'BL Pharmatec';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'BL.rdl';
    DefaultLayout = RDLC;
    dataset
    {
        dataitem(SalesShipmentHeader; "Sales Shipment Header")
        {
            RequestFilterFields = "Sell-to Customer No.";
            column(Sell_to_Customer_No_; "Sell-to Customer No.")
            {

            }
            column(Posting_Date; "Posting Date")
            {

            }
            column(SalesPersonName; SalesPersonName)
            { }
            column(Salesperson_Code; "Salesperson Code")
            { }

            column(Sell_to_Customer_Name; "Sell-to Customer Name")
            { }
            column(Sell_to_Address; "Sell-to Address")
            { }
            column(Sell_to_City; "Sell-to City")
            { }
            column(Document_Date; "Document Date")
            { }
            column(No_; "No.")
            { }
            column(Order_No_; "Order No.")
            {

            }
            column(External_Document_No_; "External Document No.")
            { }

            dataitem("Sales Shipment Line"; "Sales Shipment Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemLinkReference = SalesShipmentHeader;
                DataItemTableView = where(Quantity = filter(<> 0));
                column(Item_Reference_No_; "No.")
                { }
                column(Description; Description)
                { }
                /*    column(Lots; GetLotNos(ExpirationDatesGLOBAL))
                    { }
                    column(ExpirationDatesGLOBAL; ExpirationDatesGLOBAL)
                    { }
                    column(Shipment_Date; "Shipment Date")
                    { }
                    */
                column(Quantity; Quantity)
                { }
                column(Unit_Price; "Unit Price")
                { }
                column(Line_Discount__; "Line Discount %")
                { }
                column(VAT__; "VAT %")
                { }
                column(VAT_Base_Amount; "VAT Base Amount")
                { }
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
                column(txtMntTLettres; txtMntTLettres) { }

                dataitem("Item Ledger Entry"; "Item Ledger Entry")
                {
                    DataItemTableView = where("entry type" = filter(Sale));
                    DataItemLink = "Document No." = FIELD("Document No."), "Document line no." = FIELD("Line No.");
                    DataItemLinkReference = "Sales Shipment Line";
                    column(Lots; "Lot no.")
                    { }
                    column(ExpirationDatesGLOBAL; "Expiration Date")
                    { }
                    column(ILE_Qty; -Quantity)
                    { }
                }

                trigger OnAfterGetRecord()
                var
                begin

                    //"Sales Shipment Line".get("Document No.");
                    //"Sales Shipment Line".get("Document No.", "Line No.");
                    ncommande := '';
                    // if SalesShipmentHeader.FindLast() then
                    //   ncommande := SalesShipmentHeader."No.";


                    montant := Round((("Sales Shipment Line".Quantity) * ("Sales Shipment Line"."Unit Price")) * ((100 - "Line Discount %") / 100));
                    tva := Round(montant * "VAT %" / 100);
                    TotalBrut += montant;
                    totalTVA := tva;
                    MontantNet := TotalBrut + totalTVA;
                    Remise := montant - (montant * "Line Discount %" / 100);
                    totalremise += Remise;
                    MontantNet2 := MontantNet2 + tva + montant;
                    txtMntTLettres := '';
                    MontTlettre."Montant en texte"(txtMntTLettres, MontantNet2);

                end;


            }

            trigger OnAfterGetRecord()

            var
                SalesP: record "Salesperson/Purchaser";
            begin
                SalesP.SetRange("Code", SalesShipmentHeader."Salesperson Code");

                if SalesP.FindFirst() then
                    SalesPersonName := SalesP.Name;
            end;


        }

    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    var
        MontantNet: Decimal;
        TotalBrut: Decimal;
        montant: Decimal;
        tva: Decimal;
        totalTVA: Decimal;
        ncommande: Code[25];
        ExpirationDatesGLOBAL: Text;
        Remise: Decimal;
        totalremise: Decimal;
        SalesPersonName: Text[50];
        MontTlettre: Codeunit "Montant Toute Lettres";
        txtMntTLettres: text;
        MontantNet2: Decimal;

    local procedure GetLotNos(var ExpirationDates: Text) LotNo: Text[30];
    var
        ILE: Record "Item Ledger Entry";
    begin
        ExpirationDates := '';
        ILE.SetRange("Entry Type", ILE."Entry Type"::Sale);
        ILE.SetFilter("Document No.", SalesShipmentHeader."No.");
        ILE.SetRange("Document Line No.", "Sales Shipment Line"."Line No.");
        if ile.FindFirst() Then
            repeat
                LotNo := LotNo + ' ' + ILE."Lot No.";
                ExpirationDates := ExpirationDates + ' ' + Format(ILE."Expiration Date");
            until ILE.Next() = 0;



    end;
}
