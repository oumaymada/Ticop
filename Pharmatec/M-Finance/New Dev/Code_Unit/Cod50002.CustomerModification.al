

//using Microsoft.Sales.Customer;
codeunit 50002 "TCIOP API TESTING"
{

    [ServiceEnabled]


    procedure UpdateCustomer(customerId: Code[20]; name: Text[100]): Integer //
    var
        Customer: Record Customer;
    begin
        if Customer.get(customerId) Then begin
            Customer.validate(Name, name);
            Customer.Modify();
            exit(1);
        end
        else
            exit(-1);

    end;

    procedure Login(salespersoncode: text[50]; salespersonpsw: text[50]): integer

    var
        SalesP: record "Salesperson/Purchaser";

    begin
        if salespersonpsw = '' then
            exit(-2);
        if salesP.Get(salespersoncode) then begin
            if SalesP.PWD = salespersonpsw then begin
                if SalesP.Active then // field to add
                    exit(1);
                exit(-1);
            end;
            exit(0);
        end;
        exit(-2);
    end;

    procedure GetCustomer(): JsonArray
    var
        CustomerJsonArray: JsonArray;
        CustomerJsonObject: JsonObject;
        CustomerJsonText: Text;
        Customer: Record Customer;
    begin
        /*if filterCustomer <> '' then
            Customer.SetFilter("No.", filterCustomer);
        ;*/
        if Customer.FindSet() then
            repeat
                Clear(CustomerJsonObject);
                CustomerJsonObject.Add('code', Customer."No.");
                CustomerJsonObject.Add('name', Customer.Name);
                CustomerJsonArray.Add(CustomerJsonObject);

            until Customer.Next() = 0;
        //CustomerJsonArray.WriteTo(CustomerJsonText);
        //Error(Format(CustomerJsonArray));
        exit(CustomerJsonArray);
    end;
    /*procedure GetCustomers(): Text

    var
        CustomerJsonText: Text;
        JsonArrayText: Text;
        Customer: Record Customer;
    begin
        // Initialize the JSON array text
        JsonArrayText := '[';

        // Loop through customers and build JSON strings manually
        if Customer.FindSet() then
            repeat
                // Build JSON for each customer manually
                CustomerJsonText := '{' +
                    '"code": "' + Customer."No." + '",' +
                    '"name": "' + Customer.Name + '"' +
                    '}';

                // Append to the JSON array text
                if JsonArrayText <> '[' then
                    JsonArrayText := JsonArrayText + ',';

                JsonArrayText := JsonArrayText + CustomerJsonText;
            until Customer.Next() = 0;

        // Close the JSON array
        JsonArrayText := JsonArrayText + ']';
        Error('');

        // Return the JSON array as text without additional quotes
        exit(JsonArrayText);
    end;*/







    procedure multiplication(i: Integer; j: Integer): Integer
    begin
        exit(i * j)
    end;

    procedure UpdateCustomer2(CustomerID: Code[20]): Integer
    var
        Customer: Record Customer;

    begin
        if Customer.get(CustomerID) Then begin
            Customer.validate(Name, 'TTTTTT');
            Customer.Modify();
            exit(1);
        end
        else
            exit(-1);

    end;

    /*procedure GetCustomer(): JsonObject
    var
        Customer: Record Customer;
        JsonText: Text;
        FirstRecord: Boolean;
    begin
        JsonText := '[';
        FirstRecord := true;

        Customer.Reset();
        if Customer.FindSet() then begin
            repeat
                if not FirstRecord then
                    JsonText += ',';
                FirstRecord := false;

                JsonText += '{';
                JsonText += '"CustomerNo": "' + Customer."No." + '",';
                JsonText += '"Name": "' + Customer.Name + '"';
                JsonText += '}';
            until Customer.Next() = 0;
        end;

        JsonText += ']';
        exit(JsonText);
    end;*/

    /* procedure GetCustomers() : Text
 var
     Customer: Record Customer;
     CustomerJsonObject: JsonObject;
     CustomerJsonArray: JsonArray;
     CustomerJsonText: Text;
 begin
     CustomerJsonObject := JsonObject.Create();
     CustomerJsonArray := JsonArray.Create();

     Customer.Reset();
     if Customer.FindSet() then begin
         repeat
             var LineJsonObject: JsonObject;
             LineJsonObject := JsonObject.Create();

             LineJsonObject.Add('CustomerCode', Customer."No.");
             LineJsonObject.Add('CustomerName', Customer.Name);

             CustomerJsonArray.Add(LineJsonObject);
         until Customer.Next() = 0;
     end;

     CustomerJsonObject.Add('Customers', CustomerJsonArray);
     CustomerJsonObject.WriteTo(CustomerJsonText);
     exit(CustomerJsonText);
 end;*/

}