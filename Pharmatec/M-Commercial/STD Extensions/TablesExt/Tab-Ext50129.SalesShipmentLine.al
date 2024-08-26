namespace Ticop_pharmatec.Ticop_pharmatec;

using Microsoft.Sales.History;
using Microsoft.CRM.Opportunity;
using Microsoft.CRM.Team;

tableextension 50129 SalesShipmentLine extends "Sales Shipment Line"
{
    fields
    {
        field(50000; SalesPerson; Code[25])
        {
            Caption = 'Commercial';
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
        }
        field(50003; "Opportunity No"; code[20])
        {
            Caption = 'Numéro Opportunité';
            DataClassification = ToBeClassified;
            TableRelation = "Opportunity";

        }
    }
}
