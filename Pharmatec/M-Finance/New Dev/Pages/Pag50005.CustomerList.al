namespace Pharmatec.Pharmatec;

using Microsoft.Sales.Customer;

page 50006 CustomerList
{
    APIGroup = 'customer';
    APIPublisher = 'Pharma_Tec';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'customerList';
    DelayedInsert = true;
    EntityName = 'Customer';
    EntitySetName = 'Customers';
    PageType = API;
    SourceTable = Customer;
    ODataKeyFields = SystemId;


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(SystemId; Rec.SystemId) { }
                field("No"; Rec."No.")
                {
                    Caption = 'Customer Code';
                }
                field("Name"; Rec.Name)
                {
                    Caption = 'Customer Name';
                }
                field(Solde; Rec.Balance) { }

            }
        }
    }
    trigger OnAfterGetRecord()


    begin


        Rec.calcfields(balance);



    end;

}
