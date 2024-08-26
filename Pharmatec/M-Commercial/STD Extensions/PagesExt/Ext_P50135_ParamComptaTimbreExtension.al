

namespace SalesManagement.SalesManagement;

using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Finance.GeneralLedger.Account;

pageextension 50135 ParamComptaTimbre extends "General Ledger Setup"
{
    layout
    {
        addafter("Local Currency")
        {
            field("compte timbre fiscal"; rec."compte timbre fiscal")
            {
                ApplicationArea = all;
                Caption = 'Compte timbre fiscal';
            }
            field("Montant timbre fiscal"; rec."Montant timbre fiscal")
            {
                ApplicationArea = all;
                Caption = 'Montant timbre fiscal';
            }
        }
    }
}