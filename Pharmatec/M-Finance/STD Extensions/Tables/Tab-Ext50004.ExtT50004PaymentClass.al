namespace Pharmatec.Pharmatec;

using Microsoft.Bank.Payment;

tableextension 50004 Ext_T50004_PaymentClass extends "Payment Class"
{
    fields
    {
        field(50000; "Max Valeur ligne"; Decimal)
        {
            Caption = 'Max Valeur ligne';
            DataClassification = ToBeClassified;
        }

    }
}
