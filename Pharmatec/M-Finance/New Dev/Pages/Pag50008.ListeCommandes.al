namespace Pharmatec.Pharmatec;

using Microsoft.Sales.Document;

page 50008 ListeCommandes
{
    APIGroup = 'Commande';
    APIPublisher = 'Commande_Pharmatec';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'listeCommandes';
    DelayedInsert = true;
    EntityName = 'commande';
    EntitySetName = 'commandes';
    PageType = API;
    SourceTable = "Sales Header";
    SourceTableView = where("Document Type" = filter(Order));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(SystemId; Rec.SystemId)
                {

                }
                field("Document_Type"; Rec."Document Type")
                { }
                field("No"; Rec."No.")
                {

                }

                field("Posting_Date"; Rec."Posting Date")
                {

                }
                field("Sell_to_Customer_Name"; Rec."Sell-to Customer Name")
                {

                }
                field("Sell_to_Customer_No"; Rec."Sell-to Customer No.")
                {

                }
                field("Sell_to_Address"; Rec."Sell-to Address")
                { }
                field(Status; Rec.Status) { }
                field("Amount_Including_VAT"; Rec."Amount Including VAT") { }




            }
        }
    }

}
