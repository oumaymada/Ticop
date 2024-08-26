namespace Ticop_pharmatec.Ticop_pharmatec;

using Microsoft.Sales.Document;
using Microsoft.CRM.Opportunity;
//using Pharmatec_Ticop.Pharmatec_Ticop;

pageextension 50132 SalesQuoteExt extends "Sales Quote"
{
    layout
    {
        modify("External Document No.")
        {
            trigger OnAfterValidate()
            var
                oppo: Record Opportunity;
            begin
                if (Rec."External Document No." <> '') And oppo.get(Rec."External Document No.") then begin
                    if rec."Sell-to Contact No." <> oppo."Contact No." then
                        Error('Opportunité %1 et le devis %2 doivent avoir le même client', oppo."No.", Rec."No.");
                end;
            end;
        }

    }


    actions
    {
        modify(Release)
        {
            trigger OnAfterAction()
            var

            begin
                Rec.TestField(Rec."Salesperson Code");
            end;
        }

        addfirst(processing)
        {
            action("Identification des produits")
            {
                Image = AssemblyOrder;
                ApplicationArea = All;
                Caption = 'Identification des produits';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                var
                    Opportunity: Record Opportunity;
                    ImporAO: record "AO source";
                    SalesQuoteLine: Record "Sales Line";
                    InsertSalesQuoteLine: Record "Sales Line";
                    i: Integer;
                begin
                    rec.TestField("External Document No.");
                    Opportunity.Get(Rec."External Document No.");
                    Opportunity.TestField(Status, Opportunity.Status::"In Progress");

                    ImporAO.SetFilter(Opportunity, Rec."External Document No.");
                    ImporAO.SetRange("Line Type", ImporAO."Line Type"::Appel);
                    ImporAO.SetFilter("User Code", '%1|%2', UserId, '');
                    if ImporAO.FindFirst() then begin
                        Page.RunModal(50002, ImporAO);

                    end;
                    Commit();
                    SalesQuoteLine.SetRange("Document Type", SalesQuoteLine."Document Type"::Quote);
                    SalesQuoteLine.SetFilter("Document No.", Rec."No.");
                    if SalesQuoteLine.FindLast() then
                        i := SalesQuoteLine."Line No.";

                    ImporAO.SetFilter("User Code", UserId);
                    ImporAO.SetFilter("Internal No.", '<>%1', '');
                    if ImporAO.FindFirst() then
                        repeat
                            SalesQuoteLine.SetFilter("No.", ImporAO."Internal No.");
                            if NOT SalesQuoteLine.FindFirst() then begin
                                //Insertion d'une nouvelle ligne
                                i += 10000;
                                InsertSalesQuoteLine.init;
                                InsertSalesQuoteLine."Document Type" := SalesQuoteLine."Document Type";
                                InsertSalesQuoteLine.Type := InsertSalesQuoteLine.Type::Item;
                                InsertSalesQuoteLine."Document No." := rec."No.";
                                InsertSalesQuoteLine."Line No." := i;
                                InsertSalesQuoteLine.validate("Sell-to Customer No.", rec."Sell-to Customer No.");
                                InsertSalesQuoteLine.Validate("No.", ImporAO."Internal No.");
                                InsertSalesQuoteLine.Validate(Quantity, ImporAO.Quantity);
                                InsertSalesQuoteLine.Validate("Unit Price", 0);
                                InsertSalesQuoteLine."Description 2" := ImporAO."Line Description";
                                InsertSalesQuoteLine.insert;
                            end;
                        until ImporAO.Next() = 0;
                end;
            }
        }
    }
}
