/// <summary>
/// PageExtension purchaseinvoiceExt (ID 50067) extends Record Purchase Invoice.
/// </summary>
pageextension 50067 purchaseinvoiceExt extends "Purchase Invoice"
{
    layout
    {
        addlast(General)
        {
            field("DI No."; Rec."DI No.")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        addlast(Release)
        {
            action(VentilerFrais)
            {
                Image = Allocate;
                trigger OnAction()
                var
                    ItemChargePurch: record "Item Charge Assignment (Purch)";
                    recLPurchaselineInv: record "Purchase Line";
                    recITEMCHARGE: Record "Item Charge";
                    recLpurchRCPLine: record "Purch. Rcpt. Line";
                    recLpurchRcpHeader: Record "Purch. Rcpt. Header";
                    NumLine: Integer;
                    CUItemchargePurch: Codeunit "Item Charge Assgnt. (Purch.)";
                    pg5805: page 5805;
                begin

                    Rec.TESTFIELD("DI No.");
                    IF CONFIRM('Etes-vous sûr de ventiler les les frais de cette facture sur la réception ? ', FALSE) THEN BEGIN

                        ItemChargePurch.SETRANGE("Document Type", Rec."Document Type");
                        ItemChargePurch.SETRANGE("Document No.", Rec."No.");
                        // ItemChargePurch.SETFILTER("Item Charge No.", '<>%1', 'DD');
                        ItemChargePurch.SetRange("Droit Douane", false);

                        ItemChargePurch.DELETEALL;

                        recLPurchaselineInv.SETCURRENTKEY("Document Type", "Document No.", Type, "No.");
                        recLPurchaselineInv.SETRANGE("Document Type", Rec."Document Type");
                        recLPurchaselineInv.SETRANGE("Document No.", Rec."No.");
                        recLPurchaselineInv.SETRANGE(Type, recLPurchaselineInv.Type::"Charge (Item)");
                        recLPurchaselineInv.SetRange(recLPurchaselineInv."Droit douane", false);
                        recLPurchaselineInv.SetRange(recLPurchaselineInv.TVA, false);
                        IF recLPurchaselineInv.FINDFIRST THEN
                            REPEAT
                                recITEMCHARGE.GET(recLPurchaselineInv."No.");
                                IF recITEMCHARGE.Affectable THEN BEGIN ///////////////////////NOOOOOOTTTTT
                                    recLpurchRcpHeader.SetRange("DI No.", Rec."DI No.");
                                    if recLpurchRcpHeader.FindFirst() then

                                        // A vérifier une seule réception par Dossier import 
                                        recLpurchRCPLine.SETRANGE(recLpurchRCPLine."Document No.", recLpurchRcpHeader."No.");
                                    recLpurchRCPLine.SETRANGE(recLpurchRCPLine.Type, recLpurchRCPLine.Type::Item);
                                    IF recLpurchRCPLine.FINDFIRST THEN BEGIN
                                        NumLine := 0;
                                        REPEAT
                                            ItemChargePurch."Document Type" := Rec."Document Type";
                                            ItemChargePurch."Document No." := Rec."No.";
                                            ItemChargePurch."Document Line No." := recLPurchaselineInv."Line No.";
                                            ItemChargePurch."Line No." := NumLine + 10000;
                                            ItemChargePurch."Item Charge No." := recLPurchaselineInv."No.";
                                            ItemChargePurch.VALIDATE("Item No.", recLpurchRCPLine."No.");
                                            ItemChargePurch."Applies-to Doc. Type" := ItemChargePurch."Applies-to Doc. Type"::Receipt;
                                            ItemChargePurch."Applies-to Doc. Line No." := recLpurchRCPLine."Line No.";
                                            ItemChargePurch."Unit Cost" := recLPurchaselineInv."Unit Cost";
                                            ItemChargePurch."DI No." := Rec."DI No.";
                                            //  ItemChargePurch.insert;
                                            //Message('%1', ItemChargePurch);
                                            CUItemchargePurch.CreateRcptChargeAssgnt(recLpurchRCPLine, ItemChargePurch);
                                            //CUItemchargePurch.SuggestAssgnt(recLPurchaselineInv, recLPurchaselineInv."Qty. to Assign", recLPurchaselineInv.Amount);
                                            CUItemchargePurch.AssignItemCharges(recLPurchaselineInv, recLPurchaselineInv.Quantity, recLPurchaselineInv."Line Amount", 2);
                                        UNTIL recLpurchRCPLine.NEXT = 0;
                                    END;
                                END;
                            UNTIL recLPurchaselineInv.NEXT = 0;
                        MESSAGE('Ventilation des frais avec succès');
                    END;
                end;
            }
            action(VentilerDD)

            {
                Image = Allocate;
                trigger OnAction()
                var
                    ItemChargePurch: record "Item Charge Assignment (Purch)";
                    recLPurchaselineInv: record "Purchase Line";
                    recITEMCHARGE: Record "Item Charge";
                    recLpurchRCPLine: record "Purch. Rcpt. Line";
                    recLpurchRcpHeader: Record "Purch. Rcpt. Header";
                    NumLine: Integer;
                    CUItemchargePurch: Codeunit "Item Charge Assgnt. (Purch.)";

                begin

                    Rec.TESTFIELD("DI No.");
                    ItemChargePurch.SETRANGE("Document Type", Rec."Document Type");
                    ItemChargePurch.SETRANGE("Document No.", Rec."No.");

                    ItemChargePurch.SETRANGE("Item Charge No.", 'DD');

                    ItemChargePurch.DELETEALL;


                    recLPurchaselineInv.SETRANGE("Document Type", Rec."Document Type");
                    recLPurchaselineInv.SETRANGE("Document No.", Rec."No.");
                    recLPurchaselineInv.SETRANGE(Type, recLPurchaselineInv.Type::"Charge (Item)");
                    recLPurchaselineInv.SETRANGE(recLPurchaselineInv."No.", 'DD');

                    IF recLPurchaselineInv.FINDFIRST THEN
                        repeat
                            recLpurchRcpHeader.SetRange("DI No.", Rec."DI No.");
                            if recLpurchRcpHeader.FindFirst() then

                                // A vérifier une seule réception par Dossier import
                                recLpurchRCPLine.SETRANGE(recLpurchRCPLine."Document No.", recLpurchRcpHeader."No.");
                            recLpurchRCPLine.SETRANGE(recLpurchRCPLine.Type, recLpurchRCPLine.Type::Item);
                            IF recLpurchRCPLine.FINDFIRST THEN BEGIN
                                NumLine := 0;

                                REPEAT
                                    ItemChargePurch."Document Type" := Rec."Document Type";
                                    ItemChargePurch."Document No." := Rec."No.";
                                    ItemChargePurch."Document Line No." := recLPurchaselineInv."Line No.";
                                    ItemChargePurch."Line No." := NumLine + 10000;
                                    ItemChargePurch."Item Charge No." := recLPurchaselineInv."No.";
                                    ItemChargePurch.VALIDATE("Item No.", recLpurchRCPLine."No.");

                                    ItemChargePurch."Applies-to Doc. Type" := ItemChargePurch."Applies-to Doc. Type"::Receipt;
                                    ItemChargePurch."Applies-to Doc. Line No." := recLpurchRCPLine."Line No.";

                                    ItemChargePurch."Unit Cost" := recLPurchaselineInv."Unit Cost";
                                    ItemChargePurch."DI No." := Rec."DI No.";
                                    ItemChargePurch."Droit Douane" := true;
                                    //ItemChargePurch.Insert();
                                    CUItemchargePurch.CreateRcptChargeAssgnt(recLpurchRCPLine, ItemChargePurch);
                                    CUItemchargePurch.AssignItemCharges(recLPurchaselineInv, recLPurchaselineInv.Quantity, recLPurchaselineInv."Line Amount", 0);

                                //CUItemchargePurch.AssignItemCharges(recLPurchaselineInv,recLPurchaselineInv.Quantity,2);
                                UNTIL recLpurchRCPLine.NEXT = 0;
                            END;
                        UNTIL recLPurchaselineInv.NEXT = 0;
                    MESSAGE('Ventilation de DD avec Succès');
                end;
            }
            action(ExtraireDD)

            {
                trigger OnAction()
                var
                    recPurchaseRCP: Record "Purch. Rcpt. Header";
                    RecLPurchRCPLine2: record "Purch. Rcpt. Line";
                    reclpurchLine: record "Purchase Line";
                    LineNo: Integer;
                // itm:record item;
                begin

                    Rec.TESTFIELD("DI No.");
                    recPurchaseRCP.SETRANGE(recPurchaseRCP."DI No.", rec."DI No.");
                    if recPurchaseRCP.FindFirst() then begin


                        RecLPurchRCPLine2.SETRANGE(RecLPurchRCPLine2."Document No.", recPurchaseRCP."No.");
                        RecLPurchRCPLine2.SETRANGE(RecLPurchRCPLine2.Type, RecLPurchRCPLine2.Type::Item);
                        RecLPurchRCPLine2.SETFILTER(Quantity, '<>%1', 0);
                        IF RecLPurchRCPLine2.FINDFIRST THEN
                            REPEAT
                                reclpurchLine.SETCURRENTKEY("Document Type", "Document No.", Type, "No.");
                                reclpurchLine.RESET;
                                reclpurchLine.SETRANGE("Document Type", Rec."Document Type");
                                reclpurchLine.SETRANGE("Document No.", Rec."No.");
                                reclpurchLine.SETRANGE("Buy-from Vendor No.", rec."Buy-from Vendor No.");
                                IF reclpurchLine.FINDLAST THEN
                                    LineNo := reclpurchLine."Line No." + 10000
                                ELSE
                                    LineNo := 10000;

                                reclpurchLine.SETCURRENTKEY("Document Type", "Document No.", Type, "No.");
                                reclpurchLine.SETRANGE("Document Type", rec."Document Type");
                                reclpurchLine.SETRANGE("Document No.", rec."No.");
                                reclpurchLine.SETRANGE("Buy-from Vendor No.", Rec."Buy-from Vendor No.");
                                reclpurchLine.SETRANGE(reclpurchLine.Type, reclpurchLine.Type::"Charge (Item)");
                                reclpurchLine.SETRANGE(reclpurchLine."No.", 'DD');
                                reclpurchLine.SETRANGE("Tariff No.", RecLPurchRCPLine2."Tariff No.");
                                reclpurchLine.SETRANGE("Entry Point", RecLPurchRCPLine2."Entry Point");

                                IF (NOT reclpurchLine.FINDFIRST) THEN BEGIN
                                    reclpurchLine.LOCKTABLE;
                                    reclpurchLine.INIT;
                                    reclpurchLine."Document Type" := Rec."Document Type";
                                    reclpurchLine."Document No." := Rec."No.";
                                    reclpurchLine."Line No." := LineNo;
                                    reclpurchLine.Type := reclpurchLine.Type::"Charge (Item)";
                                    reclpurchLine.VALIDATE(reclpurchLine."No.", 'DD');
                                    reclpurchLine."Entry Point" := RecLPurchRCPLine2."Entry Point";
                                    reclpurchLine."Tariff No." := RecLPurchRCPLine2."Tariff No.";
                                    reclpurchLine.VALIDATE(Quantity, 1);
                                    reclpurchLine.INSERT;
                                END;// ELSE BEGIN
                                    // reclpurchLine."Direct Unit Cost" += RecLPurchOrder.DroitDouane;
                                    //  reclpurchLine.VALIDATE("Direct Unit Cost");
                                    //   reclpurchLine.MODIFY;
                                    // END;


                            UNTIL RecLPurchRCPLine2.NEXT = 0;
                    end;
                end;
            }
        }
    }
}