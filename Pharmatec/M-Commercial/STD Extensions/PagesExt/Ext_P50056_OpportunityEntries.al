pageextension 50056 OpportunityEntries extends "Opportunity Entries"
{
    layout
    {
        modify("Sales Cycle Stage Description")
        {
            DrillDownPageId = "Opportunity Steps Due D";

            trigger OnDrillDown()
            begin
                Message('Show Opportunity Steps with due date');
            end;


        }

    }


}