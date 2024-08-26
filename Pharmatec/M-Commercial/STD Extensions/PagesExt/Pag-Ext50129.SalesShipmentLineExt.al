namespace Ticop_pharmatec.Ticop_pharmatec;

using Microsoft.Sales.History;

pageextension 50129 SalesShipmentLineExt extends "Sales Shipment Lines"
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
