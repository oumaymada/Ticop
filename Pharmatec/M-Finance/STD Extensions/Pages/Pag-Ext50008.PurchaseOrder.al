namespace Pharmatec.Pharmatec;

using Microsoft.Purchases.Document;

pageextension 50008 "Purchase Order" extends "Purchase Order"
{
    layout
    {
        addlast(General)
        {
            field("APITEST"; Rec."No.")
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
            action(test)
            {
                trigger OnAction()
                begin

                    Rec."Posting Description" := format(cu.GetCustomer());
                    //cu.GetCustomer();



                end;
            }

        }



    }
    var
        cu: Codeunit "TCIOP API TESTING";
}






