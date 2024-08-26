pageextension 50075 purchaseorderSubFormExt extends "Purchase Order Subform"
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


}