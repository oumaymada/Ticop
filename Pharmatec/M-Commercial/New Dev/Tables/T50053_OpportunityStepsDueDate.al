table 50053 OpportunityStepsDueDate
{
    DataClassification = ToBeClassified;


    fields
    {
        field(1; "Opportunity No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'N° opportunité';
            TableRelation = Opportunity;
            Editable = false;

        }
        field(2; "Sales Cycle Code"; code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Code cycle vente';
            Editable = false;

        }
        field(3; "Stage"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Etape';
            Editable = false;
            //  TableRelation = "opportunity steps";

        }
        field(4; "Description"; text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description';
            Editable = true;

        }
        field(5; "Due Date Calculation"; DateFormula)
        {
            Caption = 'Formule date échéance';
        }
        field(6; "Due Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Date d''échéance';

        }
        field(7; "Completed %"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Réalisé %';

        }

    }

    keys
    {
        key(Key1; "Opportunity No", "Sales Cycle Code", Stage)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var


    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}