namespace Ticop_pharmatec.Ticop_pharmatec;

using Microsoft.Sales.Document;

pageextension 50128 SalesInvoiceSubform extends "Sales Invoice Subform"
{

    layout
    {
        addafter("No.")
        {
            field("Commercial"; Rec.SalesPerson)
            {
                ApplicationArea = all;
                Caption = 'Commercial';
            }
            field("Numéro Opportunité"; Rec."Opportunity No")
            {
                ApplicationArea = all;
                Caption = 'Numéro Opportunité';
            }
        }

    }
}
