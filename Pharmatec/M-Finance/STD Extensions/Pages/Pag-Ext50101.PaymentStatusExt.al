namespace Pharmatec.Pharmatec;

using Microsoft.Bank.Payment;

pageextension 50101 "Payment Status Ext" extends "Payment status"
{

    layout
    {
        addafter("Payment in Progress")
        {
            field(Risque; Rec.Risque)
            {
                ApplicationArea = All;
                Caption = 'Risque';
                Editable = true;
                ToolTip = 'Vérifier si le statut en question représente un risque, ce champs sera récupéré dans les lignes de paiement';
            }

            field("Engagement financier"; Rec."Engagement financier")
            {
                ApplicationArea = All;
                Editable = true;
                ToolTip = 'Vérifier si le statut en question représente un engagement financier';
            }
        }
    }
}
