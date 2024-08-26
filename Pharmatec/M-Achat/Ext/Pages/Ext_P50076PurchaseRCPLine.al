pageextension 50076 PurchaseRCPLineExt extends "Purch. Receipt Lines"
{
    layout
    {
        addafter(Description)
        {
            field("Tariff No."; Rec."Tariff No.")
            {
                ApplicationArea = all;
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