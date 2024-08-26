namespace Pharmatec_Ticop.Pharmatec_Ticop;

using Microsoft.Sales.History;

tableextension 50133 SalesInvoiceHeader extends "Sales Invoice Header"
{
    fields
    {
        field(50000; "Stamp Amount"; Decimal)
        {
            Caption = 'Montant Timbre';
            DataClassification = ToBeClassified;
        }
    }
}
