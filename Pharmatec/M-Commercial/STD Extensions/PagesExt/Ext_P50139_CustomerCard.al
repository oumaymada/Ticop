namespace DefaultPublisher.SalesManagement;

using Microsoft.Sales.Customer;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Intrastat;




pageextension 50139 CustomerStampCard extends "customer Card"
{
    layout
    {
        addafter("Address")
        {
            field("Customer"; Rec.Stamp)
            {
                ApplicationArea = all;
                Caption = 'Timbre Fiscal';
            }
        }
        addafter("Credit Limit (LCY)")
        {
            field("Risque financier"; Rec."Risque financier")
            {
                ApplicationArea = all;
                StyleExpr = CreditColor;

            }
        }
        addafter("Bill-to Customer No.")
        {
            field("Client Initial"; rec."Client Initial")
            {

                ApplicationArea = all;
                Caption = 'Client Initial';

            }
        }
        addafter(Blocked)
        {
            field("Territory Code"; Rec."Territory Code")
            {
                Caption = 'Code Secteur';
                ApplicationArea = all;
                TableRelation = Territory;
                NotBlank = true;
                ShowMandatory = true;

            }
        }
    }
    trigger OnAfterGetRecord()

    begin
        if Rec."Risque financier" > Rec."Credit Limit (LCY)" then
            CreditColor := 'Unfavorable'
        else
            CreditColor := 'Favorable';
    end;

    var
        CreditColor: Text;
}