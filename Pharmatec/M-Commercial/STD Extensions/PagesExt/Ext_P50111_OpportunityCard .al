pageextension 50111 OpportunityCardExt extends "Opportunity Card"
{


    layout
    {
        modify("Sales Cycle Code")
        {
            DrillDownPageId = "Opportunity Steps Due D";
            trigger OnDrillDown()
            var
                OppstepDueDate: Page "Opportunity Steps Due D";
                recCycleVenteSteps: Record "Sales Cycle Stage";
            begin

                recOppStepsDueDate.SetRange("Opportunity No", Rec."No.");
                if not recOppStepsDueDate.FindSet() then begin
                    recCycleVenteSteps.SetRange("Sales Cycle Code", rec."Sales Cycle Code");
                    if recCycleVenteSteps.FindFirst() then
                        repeat
                            recOppStepsDueDate.init;
                            recOppStepsDueDate."Opportunity No" := Rec."No.";
                            recOppStepsDueDate."Sales Cycle Code" := Rec."Sales Cycle Code";
                            recOppStepsDueDate.Stage := recCycleVenteSteps.Stage;
                            recOppStepsDueDate.Description := recCycleVenteSteps.Description;
                            recOppStepsDueDate."Completed %" := recCycleVenteSteps."Completed %";
                            recOppStepsDueDate.Insert();


                        until recCycleVenteSteps.Next() = 0;
                end;

                recOppStepsDueDate.SetRange("Opportunity No", Rec."No.");
                OppstepDueDate.SetTableView(recOppStepsDueDate);
                OppstepDueDate.Run();
            end;

            trigger OnAfterValidate()


            begin

            end;
        }

        addfirst(FactBoxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;

                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(5092), "No." = FIELD("No.");

            }


        }

        addafter("No.")
        {
            field("Appel d'offre "; rec.IsAppelOffre)
            {
                ApplicationArea = all;
                Caption = 'Appel d''offre';

            }
            field("Date d'échéance"; rec."DateEchéance")
            {
                ApplicationArea = all;
                Caption = 'Date d''échéance';
                ShowMandatory = true;
            }


            group("Période et rappel")
            {
                field(Période; rec."Période")
                {
                    ApplicationArea = all;
                }
                field("Fin de la première période"; rec."Fin de la première période")
                {
                    ApplicationArea = all;
                    ShowMandatory = true;
                }
                field("Date prochain rappel"; rec."Date prochain rappel")
                {
                    ApplicationArea = all;
                    ShowMandatory = true;
                }

            }
        }

        modify("Salesperson Code")
        {
            ShowMandatory = true;
        }
    }
    actions
    {

        addfirst(processing)
        {
            action("Fusionner devis")
            {
                Promoted = true;
                Image = FindCreditMemo;
                PromotedCategory = Process;
                ApplicationArea = All;
                Caption = 'Fusionner devis';
                trigger OnAction()
                var
                    SalesEvents: Codeunit SalesEvents;
                begin
                    SalesEvents.FusionDEVIS(rec."No.");
                end;
            }
            action("Importer l'appel d'offre")
            {
                Promoted = true;
                Image = ImportChartOfAccounts;
                PromotedCategory = Process;
                ApplicationArea = All;
                Caption = 'Importer l''appel d''offre';
                RunObject = page "Importer Appel d'offre";
                RunPageLink = Opportunity = field("No.");
            }
            action("Réponse de l'appel d'offre")
            {
                Promoted = true;
                Image = SocialSecurityPercentage;
                PromotedCategory = Process;
                ApplicationArea = All;
                Caption = 'Réponse de l''appel d''offre';
                RunObject = page "Reponse Appel d'offre";
                RunPageLink = Opportunity = field("No.");
            }
            Action(Print)
            {
                Promoted = true;
                Image = Opportunity;
                PromotedCategory = Process;
                ApplicationArea = All;
                Caption = 'Imprimer reliquat';
                trigger OnAction()
                var
                    recOppo: record Opportunity;
                begin
                    Rec.TestField(Status);
                    recOppo.SetFilter("No.", rec."No.");
                    Report.Run(50005, true, false, recOppo);
                end;
            }
        }
    }
    var
        recOppStepsDueDate: Record OpportunityStepsDueDate;
}