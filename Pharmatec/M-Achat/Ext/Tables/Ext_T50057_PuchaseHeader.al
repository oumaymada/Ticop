tableextension 50057 PurchaseHeaderExt extends "Purchase Header"
{
    fields
    {
        field(50001; "DI No."; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'No DI';
            TableRelation = if ("Document Type" = Const(order)) "Import Folder" where("Vendor No." = field("Pay-to Vendor No.")) else
            "import folder";
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}