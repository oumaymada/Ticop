pageextension 50064 pourchaseorderExt extends "Purchase Order"
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
        addlast(processing)
        {


        }



    }
}


