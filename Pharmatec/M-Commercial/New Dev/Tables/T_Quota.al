table 50065 Quota
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Item; code[25])
        {
            DataClassification = ToBeClassified;
            Caption = 'Article';
            TableRelation = Item;

        }
        field(2; "Sales person"; code[25])
        {
            DataClassification = ToBeClassified;
            Caption = 'Commercial';
            TableRelation = "Salesperson/Purchaser";

        }

    }


    keys
    {
        key(Key1; Item, "Sales person")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

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