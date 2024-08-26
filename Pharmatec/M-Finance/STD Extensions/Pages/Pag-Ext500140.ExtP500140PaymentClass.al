namespace Pharmatec.Pharmatec;

using Microsoft.Bank.Payment;

pageextension 50140 Ext_P500140_PaymentClass extends "Payment Class"
{
    layout
    {
        addafter("Line No. Series")
        {
            field("Max Valeur ligne"; rec."Max Valeur ligne")
            {
                ApplicationArea = all;
                Caption = 'Max Valeur ligne';
            }

        }
    }
}
