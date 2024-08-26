namespace Pharmatec.Pharmatec;

using Microsoft.Sales.Document;

page 50009 "Ligne Commande"
{
    APIGroup = 'LigneCommande';
    APIPublisher = 'Ligne_Commande_Pharmatec';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'ligneCommande';
    DelayedInsert = true;
    EntityName = 'lignes';
    EntitySetName = 'lignescommande';
    PageType = API;
    SourceTable = "Sales Line";
    SourceTableView = where("Document Type" = filter(Order));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(SystemId; Rec.SystemId)
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("documentType"; Rec."Document type")
                {
                }

                field("DocumentNo"; Rec."Document No.")
                {

                }

                field("lineNo"; Rec."line No.")
                {

                }
                field("PostingDate"; Rec."Posting Date")
                {

                }
                field("Sell_to_Customer_No"; Rec."Sell-to Customer No.")
                {

                }
                field(type; Rec.Type)
                {

                }
                field("No"; Rec."No.")
                {

                }
                field(Description; Rec.Description)
                {

                }
                field(Quantity; Rec.Quantity)
                {

                }
                field("QtyShippedBase"; Rec."Qty. Shipped (Base)")
                {

                }
                field("Outstanding_Quantity"; Rec."Outstanding Quantity")
                {

                }
                field("Unit_Price"; Rec."Unit Price")
                {

                }
                field("Remise"; Rec."Line Discount %")
                {

                }
                field("Amount"; Rec.Amount) { }
            }
        }
    }


}
