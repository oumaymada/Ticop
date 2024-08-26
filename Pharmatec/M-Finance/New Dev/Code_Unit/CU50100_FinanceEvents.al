/// <summary>
/// Codeunit FinanceEvents (ID 50100).
/// </summary>
codeunit 50100 FinanceEvents
{
    EventSubscriberInstance = StaticAutomatic;
    Permissions = tabledata "Vendor Ledger Entry" = m;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Payment Management", 'OnAfterProcessPaymentStep', '', false, false)]
    local procedure ValiderImpayé(PaymentHeaderNo: Code[25]; PaymentStep: Record "Payment Step")
    var
        PL: Record "Payment Line";
        Customer: Record Customer;
        CustomerListToBlock: code[250];
    begin

        if (PaymentStep."Action Type" = PaymentStep."Action Type"::Ledger) and PaymentStep."Impayé Client" then begin
            PL.SetFilter("No.", PaymentHeaderNo);
            PL.SetRange("Account Type", pl."Account Type"::Customer);
            PL.FindFirst();
            repeat
                if CustomerListToBlock = '' then
                    CustomerListToBlock := PL."Account No."
                else
                    CustomerListToBlock := CustomerListToBlock + '|' + PL."Account No.";
            until PL.next = 0;
            Customer.SetFilter("No.", CustomerListToBlock);
            Customer.ModifyAll(Blocked, Customer.Blocked::Ship);


            Message('Blocage des comptes clients suivants : %1', CustomerListToBlock);

        end;
    end;




    [EventSubscriber(ObjectType::Codeunit, codeunit::"Payment Management", 'OnAfterProcessPaymentStep', '', false, false)]
    local procedure ValiderRetenueFournisseur(PaymentHeaderNo: Code[25]; PaymentStep: Record "Payment Step")
    var
        PL: Record "Payment Line";
        Customer: Record Customer;
        CustomerListToBlock: code[250];
    begin

        if PaymentStep."Comptabiliser RS Fournisseur" = PaymentStep."Comptabiliser RS Fournisseur"::Acune then
            exit;
        if PaymentStep."Action Type" <> PaymentStep."Action Type"::Ledger then
            exit;


        PL.SetFilter("No.", PaymentHeaderNo);
        PL.SetRange("Account Type", pl."Account Type"::Vendor);
        PL.FindFirst();
        repeat
            if PL."Montant RS" <> 0 then begin
                if PaymentStep."Comptabiliser RS Fournisseur" = PaymentStep."Comptabiliser RS Fournisseur"::Validation then
                    ComptabiliserRS(PL."Account No.", PL."Montant RS", PL."Code RS", PL."No.", 1, PL."Line No.")
                else
                    ComptabiliserRS(PL."Account No.", PL."Montant RS", PL."Code RS", PL."No.", -1, PL."Line No.")
            end;

        until PL.next = 0;
    end;




    local procedure ComptabiliserRS(VendorNo: Code[25]; RS_Amount: Decimal; Retenue: Code[25]; Bord: Code[25]; Signe: Integer; LineNo: integer)
    var
        recLRS: Record "Retenue à la source";
        Cpti: Code[20];
        GenJnlLine: Record "Gen. Journal Line";
        PH: Record "Payment Header";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
    begin

        PH.get(Bord);

        IF recLRS.GET("Retenue") THEN
            Cpti := recLRS."Compte GL";

        GenJnlLine.LOCKTABLE;
        GenJnlLine.INIT;
        GenJnlLine."Posting Date" := PH."Posting Date";
        GenJnlLine."Document Date" := PH."Posting Date";

        GenJnlLine.Description := 'Retenue à la source ';
        IF Signe = -1 then
            GenJnlLine.Description := 'Annulation Retenue à la source ';

        GenJnlLine."Sell-to/Buy-from No." := VendorNo;
        GenJnlLine."Bill-to/Pay-to No." := VendorNo;
        GenJnlLine."Source Type" := GenJnlLine."Source Type"::Vendor;
        GenJnlLine."Source No." := VendorNo;
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
        GenJnlLine."Account No." := Cpti;
        GenJnlLine."Document No." := Bord;
        GenJnlLine.VALIDATE(GenJnlLine.Amount, -RS_Amount * Signe);
        GenJnlLine."Source Currency Amount" := -RS_Amount * Signe;
        GenJnlLine."Amount (LCY)" := -RS_Amount * Signe;
        GenJnlLine."System-Created Entry" := TRUE;
        GenJnlLine."Allow Application" := TRUE;
        GenJnlLine."Source Type" := GenJnlLine."Source Type"::Vendor;
        GenJnlLine."Source Code" := 'RS FRS';
        GenJnlPostLine.RunWithCheck(GenJnlLine);

        GenJnlLine.INIT;
        GenJnlLine."Posting Date" := PH."Posting Date";
        GenJnlLine."Document Date" := PH."Posting Date";

        GenJnlLine.Description := 'Retenue à la source ';
        IF Signe = -1 then
            GenJnlLine.Description := 'Annulation Retenue à la source ';
        GenJnlLine."Sell-to/Buy-from No." := VendorNo;
        GenJnlLine."Bill-to/Pay-to No." := VendorNo;
        GenJnlLine."Source Type" := GenJnlLine."Source Type"::Vendor;
        GenJnlLine."Source No." := VendorNo;



        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
        GenJnlLine.validate("Account No.", VendorNo);      // <<=


        GenJnlLine."Document No." := PH."No.";


        GenJnlLine.VALIDATE(GenJnlLine.Amount, RS_Amount * Signe);
        GenJnlLine."Source Currency Amount" := RS_Amount * Signe;
        GenJnlLine."Amount (LCY)" := RS_Amount * Signe;




        GenJnlLine."System-Created Entry" := TRUE;
        GenJnlLine."Allow Application" := TRUE;


        GenJnlLine."Source Type" := GenJnlLine."Source Type"::Vendor;
        GenJnlLine."Source Code" := 'RS FRS';

        if signe = 1 then begin
            // lettrage RS
            GenJnlLine."Applies-to ID" := Bord + 'RS' + Format(LineNo);
            ApplyVendorInvoice(Bord, LineNo, RS_Amount);
        end;


        GenJnlPostLine.RunWithCheck(GenJnlLine);

    end;

    local procedure ApplyVendorInvoice(Bord: Code[25]; LineNo: Integer; MttLettrage: Decimal)
    var
        VendorLedgerEntries: Record "Vendor Ledger Entry";
        D_VendorLedgerEntries: Record "Detailed Vendor Ledg. Entry";
        ListVendorEntryNos: Text;
        PayLine: Record "payment line";
        DocNoApply: Code[20];
        DateApply: Date;
        ApplicationNo: Integer;
        RestantMttLettrage: Decimal;

    begin
        PayLine.get(Bord, LineNo);
        if PayLine."Entry No. Debit" = 0 then
            exit;
        if not VendorLedgerEntries.GET(PayLine."Entry No. Debit") then
            exit;

        D_VendorLedgerEntries.SetCurrentKey("Vendor Ledger Entry No.", "Posting Date");
        D_VendorLedgerEntries.SetRange("Vendor Ledger Entry No.", PayLine."Entry No. Debit");
        D_VendorLedgerEntries.SetRange("entry Type", D_VendorLedgerEntries."entry Type"::Application);
        if not D_VendorLedgerEntries.FindFirst() then
            exit;
        DocNoApply := D_VendorLedgerEntries."Document No.";
        DateApply := D_VendorLedgerEntries."Posting Date";
        ApplicationNo := D_VendorLedgerEntries."Application No.";

        D_VendorLedgerEntries.Reset();
        D_VendorLedgerEntries.SetCurrentKey("Application No.", "Vendor No.", "Entry Type");
        D_VendorLedgerEntries.SetFilter("Vendor No.", PayLine."Account No.");
        D_VendorLedgerEntries.SetRange("Entry Type", D_VendorLedgerEntries."Entry Type"::Application);
        D_VendorLedgerEntries.SetRange("Application No.", ApplicationNo);
        D_VendorLedgerEntries.SetFilter("Document No.", DocNoApply);
        D_VendorLedgerEntries.SetRange("Posting Date", DateApply);

        D_VendorLedgerEntries.SetFilter("Vendor Ledger Entry No.", '<>%1', PayLine."Entry No. Debit");
        if D_VendorLedgerEntries.FindFirst() then
            repeat
                if ListVendorEntryNos = '' then
                    ListVendorEntryNos := Format(D_VendorLedgerEntries."Vendor Ledger Entry No.")
                else
                    ListVendorEntryNos := ListVendorEntryNos + '|' + format(D_VendorLedgerEntries."Vendor Ledger Entry No.");
            until D_VendorLedgerEntries.Next() = 0;

        if ListVendorEntryNos = '' then
            exit;


        RestantMttLettrage := MttLettrage;
        VendorLedgerEntries.SetFilter("Entry No.", ListVendorEntryNos);
        VendorLedgerEntries.SetRange(Positive, false);
        VendorLedgerEntries.SetAutoCalcFields("Remaining Amt. (LCY)");
        VendorLedgerEntries.FindFirst();
        repeat
            if VendorLedgerEntries.open then begin
                VendorLedgerEntries."Applies-to ID" := Bord + 'RS' + Format(LineNo);
                if abs(VendorLedgerEntries."Remaining Amt. (LCY)") >= RestantMttLettrage then begin
                    VendorLedgerEntries.validate("Amount to Apply", -RestantMttLettrage);
                    RestantMttLettrage := 0;
                end
                else begin
                    VendorLedgerEntries.validate("Amount to Apply", VendorLedgerEntries."Remaining Amt. (LCY)");
                    RestantMttLettrage -= ABS(VendorLedgerEntries."Remaining Amt. (LCY)");
                end;

                VendorLedgerEntries.Modify();

            end;
        until (VendorLedgerEntries.Next() = 0) or (RestantMttLettrage = 0);


    end;

}