// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!

namespace DefaultPublisher.SalesManagement;

using Microsoft.Sales.Customer;
using Microsoft.Bank.Payment;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Intrastat;

tableextension 50140 CustomerStampExtension extends Customer
{
    fields
    {

        field(50004; "Client Initial"; Code[20])
        {//TICOP AM
            tablerelation = Customer;
        }

        field(50141; Stamp; Boolean)
        {//TICOP AM
            Caption = 'timbre';
            InitValue = true;
        }
        field(50142; "Risque financier"; Decimal)
        {//TICOP CB
            Caption = 'Risque financier';
            FieldClass = FlowField;
            CalcFormula = - sum("Payment Line".Amount where("Account No." = field("No."), Risque = filter(<> '')
            , "Copied To No." = filter('')));
            Editable = false;
        }
        field(50143; "Code Secteur"; Code[20])
        {
            Caption = 'Code Secteur';
            DataClassification = ToBeClassified;
            TableRelation = Territory.Code;
            NotBlank = true;
        }

    }

}







