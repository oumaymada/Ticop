pageextension 50053 OpportunityStatFact extends "Opportunity Statistics FactBox"
{
    layout
    {
        addlast(content)
        {
            field(Shipments; Rec.Shipments)
            {
                Caption = 'Nbre BLs';
                Editable = false;
            }

        }
    }
}