namespace Ticop_pharmatec.Ticop_pharmatec;

using Microsoft.Sales.Document;
using Microsoft.Sales.Customer;
using Microsoft.Finance.GeneralLedger.Setup;
using System.Security.User;

tableextension 50132 SalesHeader extends "Sales Header"
{
    fields
    {
        field(50000; "Stamp Amount"; Decimal)
        {
            Caption = 'Montant Timbre';
            DataClassification = ToBeClassified;
        }


        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()

            var
                CustomerRec: Record Customer;
                GLSetup: Record "General Ledger Setup";
            begin

                "Stamp Amount" := 0;
                GLSetup.get;

                if "Sell-to Customer No." <> '' then begin
                    if CustomerRec.Get("Sell-to Customer No.") and CustomerRec.Stamp then
                        "Stamp Amount" := GLSetup."Montant timbre fiscal";
                end;
            end;

        }

        modify("Salesperson Code")
        {
            trigger OnafterValidate()
            var
                UserSetup: record 91;
            begin
                if UserSetup.get(UserId) then begin

                    if UserSetup."Salespers./Purch. Code" <> '' then
                        SetSalespersonCode('', "Salesperson Code")
                end;
            end;






        }

    }



}