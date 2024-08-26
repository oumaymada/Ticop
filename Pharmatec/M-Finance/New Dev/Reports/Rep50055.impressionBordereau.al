namespace Pharmatec.Pharmatec;

using Microsoft.Bank.Payment;
using Microsoft.Bank.BankAccount;
using Microsoft.Foundation.Company;

report 50055 "Bordereau Envoi à la banque"
{
    ApplicationArea = All;
    Caption = 'Bordereau Envoi à la banque';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Bordereau Envoi à la banque.RDL';
    dataset
    {

        dataitem(Paimentline; "Payment Line")
        {
            column(No_; "No.") { }

            Column(CurrencyCode; "Currency Code") { }
            Column(PaymentClass; "Payment Class") { }
            Column(StatusName; "Status Name") { }
            Column(Amount; Amount) { }
            Column(BankName; BankName) { }
            Column(societe; CompanyInfo.Name) { }
            Column(UserCreator; '') { }

            Column(PostDate; PostingDate) { }


            Column(compte; "Account No.") { }
            column(CompteBancaire; compteB) { }
            Column(Designation_PaymentLine; Designation) { }
            Column(Reftiree; "drawee reference") { }
            Column(Bank_Account_Name; "Bank Account Name") { }
            column(Bank_Account_Code; "Bank Account Code") { }
            column(Bank_Account_No_; "Bank Account No.") { }
            Column(AmountLine; abs("Amount")) { }
            Column(Echéance; "Due Date") { }

            column("Count"; Count)
            { }

            column(MontantH; MontantH) { }


            trigger OnPreDataItem()
            begin
                CompanyInfo.get;
                Montant := 0;

            end;

            trigger OnAfterGetRecord()


            begin


                //Message("No.");
                PaymentHeader.Get("No.");
                BankAccount.get(PaymentHeader."Account No.");
                BankName := BankAccount.Name + ' RIB :' + BankAccount."Bank Account No.";


                PostingDate := PaymentHeader."Posting Date";
                Montant := Montant + Amount;
                PaymentHeader.CalcFields(Amount);
                MontantH := abs(PaymentHeader.Amount);



            end;


        }



    }




    var
        NombrePièce: Integer;
        CompanyInfo: Record "Company Information";
        BankAccount: Record "Bank Account";// TODO DATA IN TABLE 
        PaymentHeader: Record "Payment Header";
        NBPIèce: integer;
        BankName: Text[100];
        PostingDate: Date;
        Montant: Decimal;
        MontantH: Decimal;
        compteB: Code[25];
}
