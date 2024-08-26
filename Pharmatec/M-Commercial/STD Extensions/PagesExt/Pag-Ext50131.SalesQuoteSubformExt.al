namespace Ticop_pharmatec.Ticop_pharmatec;

using Microsoft.Sales.Document;
using Pharmatec_Ticop.Pharmatec_Ticop;

pageextension 50131 SalesQuoteSubformExt extends "Sales Quote Subform"
{
    layout
    {
        addafter(Description)
        {
            field("Commercial"; Rec.SalesPerson)
            {
                ApplicationArea = all;
                Caption = 'Commercial';
            }
        }
        addafter(Quantity)
        {
            field("Qté initial opp."; rec."Qté initial opp. ")
            {
                ApplicationArea = all;
                caption = 'Qté initial opp';

            }
            field("Statut lig. devis"; rec."Statut lig. devis")
            {
                ApplicationArea = all;
                Caption = 'Statut lig.devis';
                Editable = false;
            }
        }
    }
}
