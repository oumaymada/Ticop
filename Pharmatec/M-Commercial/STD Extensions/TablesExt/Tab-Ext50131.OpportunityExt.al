namespace Ticop_pharmatec.Ticop_pharmatec;

using Microsoft.CRM.Opportunity;
using Microsoft.Sales.History;

tableextension 50131 OpportunityExt2 extends Opportunity
{
    fields
    {



        field(50002; "Shipments"; Integer)
        {
            caption = 'Nbre de BLs';
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = Count("Sales Shipment Header" where("Opportunity No." = field("No.")));
            Editable = false;
        }
        field(50003; "Période"; Integer)
        {
            BlankZero = true;
            ToolTip = 'Nombre d''année de renouvellement';
            InitValue = 1;
        }
        field(50004; "Fin de la première période"; Date)
        {

        }
        field(50005; "Date prochain rappel"; Date)
        {
        }

        field(50011; IsAppelOffre; Boolean)
        {
            Caption = 'Appel d''offre';
            DataClassification = ToBeClassified;
        }
        field(50012; DateEchéance; Date)
        {
            Caption = 'Date d''échéance';
            DataClassification = ToBeClassified;
        }

        modify("Salesperson Code")
        {
            trigger OnBeforeValidate()
            begin
                if "Salesperson Code" = ''
                then
                    Error('champs commercial obligatoir');
            end;

        }

    }

}
