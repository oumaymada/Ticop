namespace Pharmatec.Pharmatec;

using Microsoft.Bank.Payment;
using Microsoft.Finance.GeneralLedger.Journal;

pageextension 50058 PaymentSlipSubForm extends "Payment Slip Subform"
{
    layout
    {


        modify("Amount")
        {
            trigger OnAfterValidate()
            begin
                CurrPage.Update();
            end;
        }

        modify("Debit Amount")
        {
            Visible = false;
        }
        modify("credit Amount")
        {
            Visible = false;
        }
        modify("Document No.")
        {
            Visible = false;
        }

        addafter(Amount)
        {

            field("Montant base RS"; Rec."Montant base RS")
            {
                ApplicationArea = All;
                Visible = boolVisibleRS;
            }
            field("Code RS"; Rec."Code RS")
            {
                ApplicationArea = All;
                Visible = boolVisibleRS;
            }

        }
        modify(Control1)
        {
            Editable = BoolEdit;
            Enabled = BoolEdit;


        }
    }



    trigger OnAfterGetRecord()
    begin
        boolVisibleRS := Rec."Account Type" = Rec."Account Type"::Vendor;

    end;



    trigger OnAfterGetCurrRecord()
    var
        PH: Record 10865;
    begin
        PH.get(rec."no.");
        if PH."Status No." <> 0 then
            BoolEdit := false
        else
            BoolEdit := true;
        //Message('%1', rec."Status No.");
    end;

    /*local procedure IsHeaderStatusEditable(): Boolean
    var
        PaymentHeader: Record "Payment Header";
    begin
        PaymentHeader.Get(Rec."No.");
        exit(PaymentHeader."Status No." = 0);
    end;*/

    var
        boolVisibleRS: Boolean;
        BoolEdit: Boolean;
}
