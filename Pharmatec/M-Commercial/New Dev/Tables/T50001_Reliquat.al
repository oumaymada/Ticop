/// <summary>
/// Table Reliquat (ID 50001).
/// </summary>
table 50001 Reliquat
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; SalesPerson; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Commercial';
            TableRelation = "Salesperson/Purchaser";
        }
        field(2; Itemcode; code[25])
        {
            DataClassification = ToBeClassified;
            Caption = 'Article';
            TableRelation = Item;
        }
        field(3; Quota; integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Reliquat';
        }
        field(4; "Item cathegory"; code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Code cathégorie article';
            TableRelation = "Item Category";
        }
        field(5; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Date début';
        }
        field(6; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Date fin';

        }
        field(7; "Qty In Sales Orders"; Decimal)
        {
            DecimalPlaces = 0;
            Editable = false;

            Caption = 'Qté Commandée';
            FieldClass = FlowField;
            CalcFormula = sum("Sales Line"."Outstanding Quantity" where("Document Type" = const(Order)
                                                                         , SalesPerson = field(SalesPerson)
                                                                          , type = const(item)
                                                                          , "No." = field(Itemcode)
                                                                          , "Shipment Date" = field("Date Filter")));

        }
        field(8; "Date Filter"; Date)
        {
            Caption = 'Filtre date';
            FieldClass = FlowFilter;
        }
        field(9; "Qty Shiped"; Decimal)
        {
            DecimalPlaces = 0;
            Editable = false;

            Caption = 'Qté Livrée';
            FieldClass = FlowField;
            CalcFormula = sum("Value Entry"."Valued Quantity" where("Salespers./Purch. Code" = field(SalesPerson)
                                                                         , "Item No." = field(Itemcode)
                                                                         , "Valuation Date" = field("Date Filter")));

        }
    }

    keys
    {
        key(Key1; SalesPerson, Itemcode, "Start Date", "End Date")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        itm: Record item;

    procedure "Verif Quota"(Salesperson: code[20]; ItemCode: Code[25])
    var

    begin

    end;

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