namespace Ticop_pharmatec.Ticop_pharmatec;
using Microsoft.Sales.Archive;
//using Pharmatec_Ticop.Pharmatec_Ticop;

pageextension 50127 SalesQuoteArchiveSubform extends "Sales Quote Archive Subform"
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
            field("Statut lig. devis"; rec."Statut lig. devis")
            {
                ApplicationArea = all;
                Caption = 'Statut lig.devis';
            }
        }
    }

}
