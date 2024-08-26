table 50002 OrderLines
{
    Caption = 'OrderLines';
    DataClassification = ToBeClassified;
    TableType = Temporary;


    fields
    {
        field(1; LigneTempNo; Integer)
        {
            Caption = 'No';
        }
        field(2; HeaderNo; code[20])
        {

        }
        field(3; ClientNo; code[20])
        {

            TableRelation = Customer;

        }
        field(4; salespersoncode; code[20])
        {
            TableRelation = "Salesperson/Purchaser";
        }

        field(5; ItemNo; code[20])
        {

            TableRelation = Item;

        }
        field(6; Qty; Integer)
        {

        }


        field(8; "date document"; Date)
        { }
        field(9; remise; decimal) { }

    }
    keys
    {
        key(PK; LigneTempNo)
        {
            Clustered = true;

        }
    }
    /*trigger OnInsert()

    var
        ligne: Record "Sales Line";
        entete: record "Sales Header";
        seriesMgt: Codeunit "No. Series";
        SalesSetup: record "Sales & Receivables Setup";
        line: Integer;
    begin
        if not (entete.get(entete."Document Type"::Order, HeaderNo)) then begin
            entete.Init();
            // entete."No." := HeaderNo;// souche ??
            // entete.insert;
            SalesSetup.Get();
            entete."No." := seriesMgt.GetNextNo(SalesSetup."Order Nos.");
            entete."Document Type" := entete."Document Type"::Order;
            entete."Document Date" := "date document";
            entete."Sell-to Customer No." := ClientNo;
            entete.validate("Sell-to Customer No.", ClientNo);

            entete.insert();

            //entete.validate("Sell-to Customer No.", ClientNo);
            //entete."Document Date" := "date document";
            entete."Salesperson Code" := salespersoncode;
            entete.Modify();
            HeaderNo := entete."No.";


        end;

        ligne.SetRange("Document Type", ligne."Document Type"::Order);
        ligne.SetRange("Document No.", HeaderNo);
        if FindLast() then
            line := ligne."Line No." + 10000
        else
            line := 10000;


        ligne.init();

        ligne."Document Type" := ligne."Document Type"::Order;
        ligne."Document No." := HeaderNo;
        ligne."Line No." := line;
        ligne.type := ligne.type::Item;
        ligne.validate("Line Discount %", remise);
        ligne.validate("No.", ItemNo);
        ligne.validate(Quantity, Qty);


        //entete.Insert();
        ligne.Insert();
















    end;*/
    trigger OnInsert()

    var
        ligne: Record "Sales Line";
        entete: record "Sales Header";
        seriesMgt: Codeunit "No. Series";
        SalesSetup: record "Sales & Receivables Setup";
        line: Integer;
    begin


        //if (Rec.ClientNo <> '') and (rec.salespersoncode <> '') then begin


        entete.SetRange("Document Type", entete."Document Type"::Order);
        entete.setrange("Sell-to Customer No.", ClientNo);
        entete.SetRange("Salesperson Code", salespersoncode);
        entete.SetRange(Status, entete."status"::Open);
        entete.setrange("Document Date", today);

        //   Error(entete.GetFilters);
        //may be we gonna add filter location



        if entete.findfirst() then
            HeaderNo := entete."No."

        else begin
            entete.Init();
            // entete."No." := HeaderNo;// souche ??
            // entete.insert;
            SalesSetup.Get();
            entete."No." := seriesMgt.GetNextNo(SalesSetup."Order Nos.");
            entete."Document Type" := entete."Document Type"::Order;

            entete.insert();

            entete.validate("posting Date", Today);


            entete.validate("Sell-to Customer No.", ClientNo);

            entete.validate("Salesperson Code", salespersoncode);
            entete.Modify();
            HeaderNo := entete."No.";

        end;


        ligne.SetRange("Document Type", ligne."Document Type"::Order);
        ligne.SetRange("Document No.", HeaderNo);
        if ligne.FindLast() then
            line := ligne."Line No." + 10000
        else
            line := 10000;


        ligne.init();

        ligne."Document Type" := ligne."Document Type"::Order;
        ligne."Document No." := HeaderNo;
        ligne."Line No." := line;
        ligne.type := ligne.type::Item;

        ligne.validate("Line Discount %", remise);
        ligne.validate("No.", ItemNo);
        ligne.validate(Quantity, Qty);
        ligne.Insert();


        //entete.Insert();










        //end


    end;


}