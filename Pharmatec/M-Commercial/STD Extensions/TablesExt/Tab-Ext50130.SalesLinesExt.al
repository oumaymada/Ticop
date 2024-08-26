namespace Ticop_pharmatec.Ticop_pharmatec;

using Microsoft.Sales.Document;
using Microsoft.CRM.Team;
using Microsoft.CRM.Opportunity;

tableextension 50130 SalesLinesExt extends "Sales Line"
{

    fields
    {
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                if "Document Type" = "Document Type"::Quote Then
                    "Qté initial opp. " := Quantity;

            end;
        }

        field(50001; "Statut lig. devis"; Option)
        {
            Caption = 'Statut lig. devis';
            DataClassification = ToBeClassified;
            OptionMembers = " ","Encours","Gagné","Perdu";

        }
        field(50002; "Qté initial opp. "; Decimal)
        {
            Caption = 'Qté initial opp.';
            DataClassification = ToBeClassified;
            Editable = false;
            DecimalPlaces = 0;
        }
        field(50000; "SalesPerson"; Code[25])
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
