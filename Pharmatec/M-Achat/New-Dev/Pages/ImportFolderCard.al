page 50059 "Import folder card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Import Folder";

    layout
    {
        area(Content)
        {
            group(General)
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
                    DrillDownPageId = "Purchase Order List";
                }
                field("Invoice Count"; Rec."Invoice Count")
                {
                    ApplicationArea = all;
                    DrillDownPageId = "Purchase Invoices";
                }
                field("Réceptions validées"; Rec."Réceptions validées")
                {
                    ApplicationArea = all;

                }
            }
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

    var
        myInt: Integer;

    trigger OnAfterGetRecord()
    begin
        Rec."Creation Date" := Today;
    end;
}