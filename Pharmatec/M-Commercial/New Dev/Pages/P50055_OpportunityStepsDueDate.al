page 50055 "Opportunity Steps Due D"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = OpportunityStepsDueDate;
    Editable = true;
    InsertAllowed = false;
    DeleteAllowed = false;
    Caption = 'Planning opportunité';

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Opportunity No"; Rec."Opportunity No")
                {
                    ApplicationArea = All;

                }
                field("Sales Cycle Code"; Rec."Sales Cycle Code")
                {
                    ApplicationArea = All;

                }

                field(Stage; Rec.Stage)
                {
                    ApplicationArea = All;

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Completed %"; Rec."Completed %")
                {
                    ApplicationArea = All;
                }

                field("Due Date Calculation"; Rec."Due Date Calculation")
                {
                    ApplicationArea = all;

                    trigger OnValidate()
                    var
                        oppo: Record Opportunity;
                    begin
                        oppo.SetRange(oppo."No.", Rec."Opportunity No");
                        if oppo.FindFirst() then begin
                            if oppo."DateEchéance" <> 0D then
                                Rec."Due Date" := CalcDate((Rec."Due Date Calculation"), oppo."DateEchéance")
                            else
                                Error('Date échéance doit avoir une valeur dans opportunité %1', oppo."No.");
                        end;

                    end;

                }
                field("Due Date"; rec."Due Date")
                {
                    ApplicationArea = All;

                }
            }
        }
    }


}