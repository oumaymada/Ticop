codeunit 50052 SalesEvents
{

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Factbox", 'OnBeforeDrillDown', '', false, false)]
    local procedure OnBeforeDrillDown(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef);
    var
        Opportunity: Record Opportunity;
    begin
        case DocumentAttachment."Table ID" of
            DATABASE::"Opportunity":
                begin
                    RecRef.Open(DATABASE::"Opportunity");
                    if Opportunity.Get(DocumentAttachment."No.") then
                        RecRef.GetTable("Opportunity");
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Details", 'OnAfterOpenForRecRef', '', false, false)]
    local procedure OnAfterOpenForRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef);
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
    begin
        case RecRef.Number of
            DATABASE::"Opportunity":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnAfterInitFieldsFromRecRef', '', false, false)]
    local procedure OnAfterInitFieldsFromRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
    begin
        case RecRef.Number of
            DATABASE::"Opportunity":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
        end;
    end;
    // Update sales person in sales line by sales header
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnRunOnBeforeCheckAndUpdate', '', false, false)]
    local procedure OnRunOnBeforeCheckAndUpdate(var SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin


            SalesLine.SetRange("Document Type", SalesHeader."Document Type");
            SalesLine.SetRange("Document No.", SalesHeader."No.");
            SalesLine.SetRange(SalesPerson, '');
            if SalesLine.FindSet() then
                SalesLine.ModifyAll(SalesPerson, SalesHeader."Salesperson Code");
        end;

    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterCopyItemJnlLineFromSalesLine', '', false, false)]
    local procedure OnAfterCopyItemJnlLineFromSalesLine(var ItemJnlLine: Record "Item Journal Line"; SalesLine: Record "Sales Line")
    begin

        ItemJnlLine."Salespers./Purch. Code" := SalesLine.SalesPerson;


    end;

    // << Ticop on validate Qty to ship the system will check in table reliqua Quota ,  sales order Qty en Qty Shipped
    // in this period stard day en end date

    // << -------------------------Ticop 18-07-2024  KJ commented ------------------

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnValidateQtyToShipOnAfterCheckQuantity', '', false, false)]
    local procedure OnValidateQtyToShipOnAfterCheckQuantity(CurrentFieldNo: Integer; var SalesLine: Record "Sales Line")
    var
        RecReliquat: Record Reliquat;
    begin
        /*
                RecReliquat.SetRange(SalesPerson, SalesLine.SalesPerson);
                RecReliquat.SetRange(Itemcode, SalesLine."No.");
                RecReliquat.SetFilter("Start Date", '<=%1', SalesLine."Shipment Date");
                RecReliquat.SetFilter("End Date", '%1|>=%2', 0D, SalesLine."Shipment Date");
                if RecReliquat.FindLast() then begin
                    RecReliquat.SetRange("Date Filter", RecReliquat."Start Date", RecReliquat."End Date");
                    RecReliquat.CalcFields("Qty In Sales Orders", "Qty Shiped");
                    if RecReliquat.Quota < (RecReliquat."Qty Shiped" + RecReliquat."Qty In Sales Orders") then
                        Message('Merci de vérifier le quota pour %1 article %2', RecReliquat.SalesPerson, RecReliquat.Itemcode);

                end;*/


    end;
    // >> ---------------------Ticop Kj 18-07-2024 Commented ---------------------------



    [EventSubscriber(ObjectType::Codeunit, codeunit::"sales-post", 'OnBeforePostSalesDoc', '', false, false)]
    procedure StampEvent(SalesHeader: Record "Sales Header")
    begin

        IF SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice THEN
            InsertStampLine(SalesHeader);
    end;

    local procedure InsertStampLine(Rec: Record "Sales Header")
    var

        GLSetup: Record "General Ledger Setup";
        Customer: Record Customer;
        RecLSalesLine: Record "Sales Line";
        RecLSalesLine1: Record "Sales Line";
        VarILineNo: Integer;
        GLAccount: Record 15;
    begin

        GLSetup.GET;
        GLSetup.TestField("Montant timbre fiscal");
        GLSetup.TestField("Compte timbre fiscal");
        Customer.get(rec."Bill-to Customer No.");

        IF Customer.Stamp THEN BEGIN
            RecLSalesLine.RESET;
            RecLSalesLine.SETRANGE("Document Type", Rec."Document Type");
            RecLSalesLine.SETRANGE("Document No.", Rec."No.");
            RecLSalesLine.SETRANGE(RecLSalesLine.Type, RecLSalesLine.Type::"G/L Account");
            RecLSalesLine.SETRANGE(RecLSalesLine."No.", GLSetup."compte timbre fiscal");
            IF RecLSalesLine.FIND('-') THEN BEGIN
                REPEAT
                    RecLSalesLine.DELETE;
                UNTIL RecLSalesLine.NEXT = 0;
            END;

            RecLSalesLine.RESET;
            RecLSalesLine.SETRANGE("Document Type", RecLSalesLine."Document Type"::Invoice);
            RecLSalesLine.SETRANGE("Document No.", Rec."No.");
            IF RecLSalesLine.FIND('-') THEN BEGIN
                IF RecLSalesLine.FINDLAST THEN
                    VarILineNo := RecLSalesLine."Line No." + 50;
                IF rec."Document Type" IN [rec."Document Type"::Invoice, rec."Document Type"::Order, rec."Document Type"::"Credit Memo",
                   rec."Document Type"::"Return Order"] THEN BEGIN
                    RecLSalesLine1.VALIDATE("Document Type", rec."Document Type");
                    RecLSalesLine1.VALIDATE("Document No.", rec."No.");
                    RecLSalesLine1."Line No." := VarILineNo;
                    RecLSalesLine1.VALIDATE(Type, RecLSalesLine1.Type::"G/L Account");

                    RecLSalesLine1.VALIDATE("No.", GLSetup."compte timbre fiscal");
                    RecLSalesLine1.VALIDATE("Sell-to Customer No.", rec."Sell-to Customer No.");
                    RecLSalesLine1.VALIDATE("Location Code", rec."Location Code");
                    RecLSalesLine1.Description := 'Timbre Fiscal Loi 93/53';
                    RecLSalesLine1.VALIDATE(Quantity, 1);

                    GLAccount.GET(GLSetup."compte timbre fiscal");

                    RecLSalesLine1.VALIDATE("Unit Price", GLSetup."Montant timbre fiscal");
                    RecLSalesLine1."VAT Prod. Posting Group" := GLAccount."VAT Prod. Posting Group";
                    RecLSalesLine1."Gen. Prod. Posting Group" := GLAccount."Gen. Prod. Posting Group";
                    RecLSalesLine1."VAT Bus. Posting Group" := rec."VAT Bus. Posting Group";
                    RecLSalesLine1."Gen. Bus. Posting Group" := rec."Gen. Bus. Posting Group";

                    RecLSalesLine1.INSERT;
                END;
            END;
        END;
    END;













    local procedure GetRemainingQtyFromItemLedgerEntries(ItemNo: Code[25];
    LocationCode: code[25]; var QteRestante: Decimal; var previousLotNo: Code[50]; var previousExperiationDate: Date; var All_previousLotNo: Text): Boolean
    var
        ILE: Record "Item Ledger Entry";
        TotalRestant: Decimal;
        ILE0: Record "Item Ledger Entry";
        reservedQty: Decimal;

    begin
        // ILE.setfilter("Entry No.", '>%1', entryNo);
        ILE.SetCurrentKey("Item No.", Positive, "Location Code", "Variant Code");
        ile.SetFilter("Item No.", ItemNo);
        ile.SetRange(Positive, true);
        ILE.SetFilter("Location Code", LocationCode);
        ile.SetCurrentKey("Item No.", Open, "Variant Code", Positive, "Lot No.", "Serial No.", "Package No.");
        ILE.SetRange(Open, true);
        ILE.SetCurrentKey("Lot No.");
        //ILE.SetFilter("Lot No.", '<>%1&<>%2', All_previousLotNo, '');
        ILE.SetFilter("Lot No.", All_previousLotNo);

        ILE.SetCurrentKey("Expiration Date", "Item No.");
        ILE.SetFilter("Expiration Date", '>=%1', previousExperiationDate);

        if ILE.FindFirst() then begin

            ILE0.SetCurrentKey("Item No.", Positive, "Location Code", "Variant Code");
            ILE0.SetFilter("Item No.", ItemNo);
            ILE0.SetRange(Positive, true);
            ILE0.SetFilter("Location Code", LocationCode);
            ILE0.SetCurrentKey("Item No.", Open, "Variant Code", Positive, "Lot No.", "Serial No.", "Package No.");
            ILE0.SetRange(Open, true);
            ILE0.SetCurrentKey("Lot No.");
            ILE0.SetFilter("Lot No.", ile."Lot No.");

            ILE0.SetCurrentKey("Expiration Date", "Item No.");
            ILE0.SetRange("Expiration Date", ILE."Expiration Date");
            ILE0.CalcSums("Remaining Quantity");


            TotalRestant := 0;
            reservedQty := ReservedQty(ItemNo, ILE."Lot No.", LocationCode);
            if reservedQty <= ILE0."Remaining Quantity" then
                TotalRestant := ILE0."Remaining Quantity" - reservedQty;


            if QteRestante <= TotalRestant then
                QteRestante := 0
            else
                QteRestante := QteRestante - TotalRestant;
            if All_previousLotNo = '' then
                All_previousLotNo := '<>' + ILE."Lot No."
            else
                All_previousLotNo := All_previousLotNo + '&<>' + ILE."Lot No.";
            previousLotNo := ILE."Lot No.";
            previousExperiationDate := ILE."Expiration Date";
            exit(true); //Lot trouvé
        end;
        exit(false);//Lot non trouvé
    end;

    procedure AssignLotNoToSalesOrder(DocType: Enum "Sales Document Type"; DocNo: Code[25])
    var
        SalesLine: Record "Sales Line";


        QteRestante: Decimal;
        QteReserve: Decimal;
        previousLotNo: Code[50];
        previousExperiationDate: Date;
        FindLotNo: Boolean;
        All_LotNo: Text;
        item: Record Item;

    begin
        if DocType <> DocType::Order then  //maybe can accepted when it s an invoice
            exit;

        SalesLine.SetRange("Document Type", DocType);
        SalesLine.SetFilter("document No.", DocNo);
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetFilter("Qty. to Ship", '<>0');

        SalesLine.FindFirst();
        repeat
            item.get(SalesLine."No.");
            if item."Item Tracking Code" <> '' then begin
                DeleteReservationEntry(SalesLine);
                QteRestante := SalesLine."Qty. to Ship";
                previousLotNo := '';
                previousExperiationDate := Today;
                All_LotNo := '';
                repeat
                    QteReserve := QteRestante;
                    FindLotNo := GetRemainingQtyFromItemLedgerEntries(SalesLine."No.", SalesLine."Location Code", QteRestante, previousLotNo, previousExperiationDate, All_LotNo);
                    if FindLotNo then begin
                        QteReserve := QteReserve - QteRestante;
                        InsertReservationEntry(SalesLine, previousLotNo, previousExperiationDate, QteReserve);
                    end;
                until (QteRestante = 0) OR not FindLotNo;

                if not FindLotNo then
                    Message('Attention !!! \Pas de lot à affecter pour %1 de %2  \Magasin %3', QteRestante, SalesLine."No.", SalesLine."Location Code");


            end;
        until SalesLine.next = 0;

        Message('Des lots ont été affectés...');
    end;

    local procedure InsertReservationEntry(SalesLine: Record "Sales Line"; LotNo: code[50]; ExperiationDate: Date; QtyToInsert: Decimal)
    var
        ReservationEntry: Record "Reservation Entry";


    begin


        ReservationEntry.Init();
        ReservationEntry."Source Type" := DATABASE::"Sales Line";
        ReservationEntry."Source Subtype" := SalesLine."Document Type".AsInteger();
        ReservationEntry."Source ID" := SalesLine."Document No.";
        ReservationEntry."Source Ref. No." := SalesLine."Line No.";
        ReservationEntry."Item No." := SalesLine."No.";
        ReservationEntry."Variant Code" := SalesLine."Variant Code";
        ReservationEntry."Location Code" := SalesLine."Location Code";

        ReservationEntry.validate("Quantity (Base)", -QtyToInsert);
        ReservationEntry."Lot No." := LotNo;
        ReservationEntry."Expiration Date" := ExperiationDate;
        ReservationEntry."Reservation Status" := ReservationEntry."Reservation Status"::Surplus;
        ReservationEntry."Created By" := 'TICOP';
        ReservationEntry.Validate("Item Tracking", ReservationEntry."Item Tracking"::"Lot No.");
        ReservationEntry."Creation Date" := today;
        ReservationEntry.insert;
    end;

    local procedure FusionDEVIS_YB(VAR NumeroDevis: Code[250])

    var

        NrecL36: Record "Sales Header";
        SalesHeaderNV: Record "Sales Header";
        recL36: Record "Sales Header";
        recL37: Record "Sales Line";
        recL37_Origin: Record "Sales Line";
        NewRecL37: Record "Sales Line";
        HeaderDeleted: Integer;
        Ligne: Integer;
        Archiv: Codeunit "ArchiveManagement";
    begin
        recL37.SETRANGE("Document Type", recL37."Document Type"::Quote);
        recL37.SETRANGE("Document No.", NumeroDevis);
        IF recL37.FINDLAST THEN BEGIN
            IF NrecL36.GET(recL37."Document No.") THEN BEGIN
                SalesHeaderNV.INIT();
                SalesHeaderNV := NrecL36;
                SalesHeaderNV.VALIDATE(SalesHeaderNV."Document Date", TODAY);
                SalesHeaderNV."No." := '';
                SalesHeaderNV.INSERT(TRUE);
                SalesHeaderNV.VALIDATE(SalesHeaderNV."Posting Date", TODAY);
                IF SalesHeaderNV.MODIFY() THEN BEGIN
                    Commit();
                END;
            END;
        END
        ELSE
            ERROR('');

        recL36.RESET;
        recL36.SETRANGE("Document Type", recL36."Document Type"::Quote);
        recL36.SETRANGE("No.", NumeroDevis);

        IF recL36.FINDFIRST THEN
            REPEAT
                Archiv.StoreSalesDocument(recL36, TRUE);
                recL37.RESET;
                recL37.SETRANGE("Document Type", recL37."Document Type"::Quote);
                recL37.SETRANGE("Document No.", recL36."No.");
                IF recL37.FINDFIRST THEN BEGIN
                    Archiv.StoreSalesDocument(recL36, TRUE);
                    REPEAT
                        recL37_Origin.RESET;
                        recL37_Origin.SETRANGE("Document Type", recL37_Origin."Document Type"::Quote);
                        recL37_Origin.SETRANGE("Document No.", SalesHeaderNV."No.");
                        recL37_Origin.SETFILTER("No.", recL37."No.");
                        IF recL37_Origin.FINDFIRST THEN BEGIN
                            recL37_Origin.VALIDATE(Quantity, recL37_Origin.Quantity + recL37.Quantity);
                            recL37_Origin."Qty. to Ship" := 0;
                            recL37_Origin."Qty. to Invoice" := 0;
                            recL37_Origin.MODIFY;
                        END
                        ELSE BEGIN
                            Ligne += 10000;
                            NewRecL37 := recL37;
                            NewRecL37."Document No." := SalesHeaderNV."No.";
                            NewRecL37."Line No." := Ligne;
                            NewRecL37."Qty. to Ship" := 0;
                            NewRecL37."Qty. to Invoice" := 0;
                            NewRecL37.INSERT;
                        END;
                        recL37.DELETE;
                    UNTIL recL37.NEXT = 0;
                END;
                recL36.DELETE;
                HeaderDeleted += 1;
            UNTIL recL36.NEXT = 0;


    end;

    //Archivage devis

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeModifyEvent', '', true, true)]
    local procedure OnBeforeModifySalesHeader(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; RunTrigger: Boolean)
    begin

        if Rec."Document Type" = Rec."Document Type"::Quote then begin

            if ChangeStatus(Rec, xRec) then
                if Rec.Status = Rec.Status::Released then
                    ArchiveQuote(Rec, RunTrigger);

        end;
    end;

    local procedure ChangeStatus(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"): Boolean
    begin

        if Rec.Status <> xRec.Status then
            exit(true);
        exit(false);
    end;


    local procedure ArchiveQuote(var SalesHeader: Record "Sales Header"; InteractionExist: Boolean)
    var

        Archiv: Codeunit "ArchiveManagement";
    begin

        Archiv.StoreSalesDocument(SalesHeader, true);
        Message('Le devis a été archivé.');
    end;


    //<< Ticop  Added By KJ to filter Quote lines Status Win for create order

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order", 'OnTransferQuoteToOrderLinesOnAfterSetFilters', '', true, true)]
    local procedure OnTransferQuoteToOrderLinesOnAfterSetFilters(var SalesQuoteHeader: Record "Sales Header"; var SalesQuoteLine: Record "Sales Line")
    begin
        if SalesQuoteHeader."Opportunity No." <> '' then begin
            SalesQuoteLine.SetRange("Statut lig. devis", SalesQuoteLine."Statut lig. devis"::"Gagné");
            SalesQuoteLine.FindSet();
        end;
    end;
    //>>Ticop  Added By KJ
    //<< ---------------------Ticop Kj Date 16/07/2024 ----------------------------------------
    // << Ticop Kj Date 16/07/2024 create contact with the same No of customer
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CustCont-Update", 'OnBeforeContactInsert', '', false, false)]
    local procedure OnBeforeContactInsert(Customer: Record Customer; var Contact: Record Contact)
    begin
        Contact."No." := Customer."No.";
    end;
    // >> Ticop Kj Date 16/07/2024 

    //<< ---------------------------Ticop 18-07-2024 OD --------------------------
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeInsertEvent', '', false, false)]
    local procedure MagasinParDefaut(var Rec: Record "Sales Line")
    var
        companyInf: Record "Company Information";
    begin
        companyInf.get();

        if Rec."Location Code" = '' then begin
            Rec."Location Code" := companyInf."Location Code";
        end;
    end;
    //>> ---------------------------Ticop 18-07-2024 OD --------------------------

    //<< ---------------------Ticop Kj Date 16/07/2024 ----------------------------------------
    // Ce code doit être confirmé avant d'être décommenté
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post (Yes/No)", 'OnBeforeConfirmSalesPost', '', true, true)]
    local procedure OnBeforeConfirmSalesPost(var SalesHeader: Record "Sales Header"; var HideDialog: Boolean; var IsHandled: Boolean; var DefaultOption: Integer; var PostAndSend: Boolean)
    begin

        If Confirm('Voulez-vous expédier la commande %1?', false, SalesHeader."No.") then begin
            DefaultOption := 1;
            SalesHeader.Ship := true;
            SalesHeader.Invoice := false;
            HideDialog := true;
        end
        else
            IsHandled := true;

    end;


    // >> Ticop Kj Date 16/07/2024
    procedure FusionDEVIS(ExternalDocumentNo: Code[25])

    var

        SalesHeader: Record "Sales Header";
        SalesHeaderNV: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesLineNV: Record "Sales Line";
        Ligne: Integer;
        Archiv: Codeunit "ArchiveManagement";
        CustomerNo: Code[20];
        PremierDevis: Code[20];
        OpportunityNo: Code[20];
        LesDevisSélectionnés: Text;
        Opportunity: Record Opportunity;
    begin

        if ExternalDocumentNo = '' then
            Error('Pas de filtre à appliquer');

        if not Opportunity.Get(ExternalDocumentNo) then
            Error('%1 n''est pas une opportunité', ExternalDocumentNo);

        Opportunity.TestField("Sales Document No.", '');

        //Tester si le mm client, si tous les devis sont lancés, pas d'opport
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Quote);
        SalesHeader.SetFilter("External Document No.", ExternalDocumentNo);


        if not Confirm('%1 devis seront fusionnés', true, SalesHeader.Count) then
            exit;
        if SalesHeader.Count = 0 then
            exit;
        SalesHeader.FindFirst();
        begin
            CustomerNo := SalesHeader."Sell-to Customer No.";
            PremierDevis := SalesHeader."No."; // récuparation du premier No pour le copier
        end;
        repeat
            if CustomerNo <> SalesHeader."Sell-to Customer No." then
                Error('Les clients sont différents');

            if SalesHeader."Opportunity No." <> '' then
                Error('%1 est déjà affecté à une opportunité ', SalesHeader."No.");

            if SalesHeader.Status <> SalesHeader.Status::Released then
                Error('%1 doit être lancé ', SalesHeader."No.");

            if SalesHeader."Salesperson Code" = '' then
                Error('%1 sans commercial ', SalesHeader."No.");

            if LesDevisSélectionnés = '' then
                LesDevisSélectionnés := SalesHeader."No."
            else
                LesDevisSélectionnés := LesDevisSélectionnés + '|' + SalesHeader."No.";
        until SalesHeader.next = 0;


        //Copier Header à partir de l'un des devis
        SalesHeader.Reset();
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Quote);
        SalesHeader.SetFilter("No.", PremierDevis);
        SalesHeaderNV.INIT();
        SalesHeaderNV := SalesHeader;
        SalesHeaderNV.Validate(Status, SalesHeaderNV.Status::Open);
        SalesHeaderNV."No." := '';
        SalesHeaderNV.INSERT(TRUE);


        SalesHeaderNV."External Document No." := '';
        SalesHeaderNV.VALIDATE("Document Date", TODAY);
        SalesHeaderNV.VALIDATE("Posting Date", TODAY);
        SalesHeader.Validate("Salesperson Code", '');
        SalesHeaderNV.validate("Opportunity No.", ExternalDocumentNo); //affectation de l'opportunité
        SalesHeaderNV.MODIFY();
        Commit();

        PremierDevis := SalesHeaderNV."No."; //Ecrasement pour réutilisation dans les lignes
        Message('Devis %1 a été créé', SalesHeaderNV."No.");

        SalesHeader.Reset();
        //Creation des Lignes
        SalesLine.SETRANGE("Document Type", SalesLine."Document Type"::Quote);
        SalesLine.SetFilter("Document No.", LesDevisSélectionnés);
        SalesLine.FindFirst();
        repeat
            SalesHeader.get(SalesHeader."Document Type"::Quote, SalesLine."Document No.");
            SalesLine.TestField("Statut lig. devis", 0);
            SalesLine.TestField("Qty. to Ship", 0);

            Ligne += 10000;
            SalesLineNV := SalesLine;
            SalesLineNV."Document No." := PremierDevis;
            SalesLineNV."Line No." := Ligne;
            SalesLineNV."Qty. to Ship" := 0;
            SalesLineNV."Qty. to Invoice" := 0;
            SalesLineNV.SalesPerson := SalesHeader."Salesperson Code";
            SalesLineNV.INSERT;
        until SalesLine.next = 0;

        //suppression des anciens devis
        SalesHeader.Reset();
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Quote);
        SalesHeader.SetFilter("No.", "LesDevisSélectionnés");

        SalesHeader.FINDFIRST;
        REPEAT
            //     Archiv.StoreSalesDocument(SalesHeader, TRUE);
            SalesHeader.DELETE(true); // supprime aussi les lignes ...
        until SalesHeader.next = 0;
    end;


    //<<<<<<< HEAD
    local procedure DeleteReservationEntry(SalesLine: Record "Sales Line")
    var
        ReservationEntry: Record "Reservation Entry";
    begin
        Message('Suppression réservation lot...');
        ReservationEntry.SetRange("Source Type", DATABASE::"Sales Line");
        ReservationEntry.SetRange("Source Subtype", SalesLine."Document Type".AsInteger());
        ReservationEntry.SetFilter("Source ID", SalesLine."Document No.");
        ReservationEntry.SetRange("Source Ref. No.", SalesLine."Line No.");
        ReservationEntry.SetFilter("Item No.", SalesLine."No.");
        ReservationEntry.SetFilter("Location Code", SalesLine."Location Code");
        if ReservationEntry.FindFirst() then
            ReservationEntry.DeleteAll();
    end;


    local procedure ReservedQty(ItemNo: Code[25]; LotNo: Code[50]; LocationCode: Code[25]): Decimal
    var
        ReservationEntry: Record "Reservation Entry";
    begin

        ReservationEntry.SetFilter("Item No.", ItemNo);
        ReservationEntry.SetFilter("Lot No.", LotNo);
        ReservationEntry.SetFilter("Location Code", LocationCode);

        ReservationEntry.SetRange("Reservation Status", ReservationEntry."Reservation Status"::Surplus);

        ReservationEntry.SetRange("Item Tracking", ReservationEntry."Item Tracking"::"Lot No.");
        ReservationEntry.SetFilter("Quantity (Base)", '<0');

        if ReservationEntry.FindFirst() then
            ReservationEntry.CalcSums("Quantity (Base)");

        exit(-ReservationEntry."Quantity (Base)")
    end;



}