/*namespace Pharmatec.Pharmatec;

using Microsoft.Bank.Payment;

pageextension 50041 PaymentSlip extends "Payment Slip"
{//Editable= BoolEdit;
    layout
    {

    }
    trigger OnAfterGetRecord()
    begin
        if Rec."Status No." <> 0 then
            Editable := false
        else
            Editable := true;
    end;

    var
        BoolEdit: Boolean;
        PH: Record "Payment Header";

}*/
