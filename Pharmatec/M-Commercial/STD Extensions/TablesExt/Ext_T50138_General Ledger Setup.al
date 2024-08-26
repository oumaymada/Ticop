namespace SalesManagement.SalesManagement;

using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Finance.GeneralLedger.Account;

tableextension 50138 TableGLStampExtension extends "General Ledger Setup"
{
    fields
    {
        field(50137; "compte timbre fiscal"; Code[25])
        {
            Caption = 'Compte timbre fiscal';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }



        field(50138; "Montant timbre fiscal"; decimal)
        {
            Caption = 'Montant timbre fiscal';
            DataClassification = ToBeClassified;

        }
    }






}


