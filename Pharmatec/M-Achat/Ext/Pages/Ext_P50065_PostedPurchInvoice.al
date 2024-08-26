pageextension 50065 purchaseinvoice extends "Posted Purchase Invoice"
{
    layout
    {
        addlast(General)
        {
            field("DI No."; Rec."DI No.")
            {
                ApplicationArea = all;
                Importance = Promoted;



            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}