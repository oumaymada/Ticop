namespace Ticop_pharmatec.Ticop_pharmatec;

using Microsoft.sales.Document;

pageextension 50130 ExtSalesOrder extends "Sales Order"
{
    actions
    {

        addfirst(processing)
        {
            action("Assing Lot No.")
            {
                Promoted = true;
                Image = Lot;
                PromotedCategory = Process;
                ApplicationArea = All;
                Caption = 'Affecter Lot';
                trigger OnAction()
                var
                    SalesEvents: Codeunit SalesEvents;
                begin
                    SalesEvents.AssignLotNoToSalesOrder(rec."Document Type", rec."No.");


                end;
            }
            action("Génerer Bon de Préparation")
            {
                Promoted = true;
                PromotedCategory = Report;
                ApplicationArea = All;
                Caption = 'Génerer Bon de Préparation';
                trigger OnAction()

                var
                    SalesOrder: record "Sales header";
                begin

                    SalesOrder.setfilter("no.", rec."no.");
                    report.runmodal(50101, true, true, SalesOrder);


                end;
            }
        }
    }
}