namespace Pharmatec.Pharmatec;

using Microsoft.Bank.Payment;
using Microsoft.Finance.GeneralLedger.Journal;

pageextension 50059 PaymentLinesListxt extends "Payment Lines List"
{
    layout
    {




        addafter(Amount)
        {

            field(Risque; Rec.Risque)
            {
                ApplicationArea = All;

            }
            field("Engagement financier"; Rec."Engagement financier")
            {
                ApplicationArea = All;

            }

        }
    }


}
