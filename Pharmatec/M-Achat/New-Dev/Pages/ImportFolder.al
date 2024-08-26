page 50058 "Import Folder List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Import Folder";
    CardPageId = "Import folder card";

    layout
    {
        area(Content)
        {
            repeater(Group1)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = All;

                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;

                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;

                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
                field("Closed Date"; Rec."Closed Date")
                {
                    ApplicationArea = all;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = all;
                }
                field("Currency Factor"; Rec."Currency Factor")
                {
                    ApplicationArea = all;
                }
                field("N° déclaration"; Rec."N° déclaration")
                {
                    ApplicationArea = all;
                }
                field("N° Titre Importation"; Rec."N° Titre Importation")
                {
                    ApplicationArea = all;
                }
                field("Nombre de colis"; Rec."Nombre de colis")
                {
                    ApplicationArea = all;
                }
                field("Order Count"; Rec."Order Count")
                {
                    ApplicationArea = all;
                    DrillDownPageId = "Purchase Order";
                }
                field("Invoice Count"; Rec."Invoice Count")
                {
                    ApplicationArea = all;
                    DrillDownPageId = "Purchase invoice";
                }
                field("Réceptions validées"; Rec."Réceptions validées")
                {
                    ApplicationArea = all;

                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

}