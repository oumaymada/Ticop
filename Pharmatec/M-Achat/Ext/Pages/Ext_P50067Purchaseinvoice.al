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
                                            ItemChargePurch.FindLast();
                                            NumLine := ItemChargePurch."Line No.";
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
                    DroitDouaneLEntry: Record DroitDouaneLedgerEntry;
                    DroitDouaneLEntry2: Record DroitDouaneLedgerEntry;
                    LineNo: Integer;
                    percent: Decimal;


                begin

                    Rec.TESTFIELD("DI No.");
                    ItemChargePurch.SETRANGE("Document Type", Rec."Document Type");
                    ItemChargePurch.SETRANGE("Document No.", Rec."No.");

                    //ItemChargePurch.SETRANGE(ItemChargePurch."Droit Douane", true);

                    ItemChargePurch.DELETEALL;
                    // 



                    recLPurchaselineInv.SETRANGE("Document Type", Rec."Document Type");
                    recLPurchaselineInv.SETRANGE("Document No.", Rec."No.");
                    recLPurchaselineInv.SETRANGE(Type, recLPurchaselineInv.Type::"Charge (Item)");
                    //recLPurchaselineInv.SETRANGE(recLPurchaselineInv."No.", 'DD');
                    recLPurchaselineInv.SetRange(recLPurchaselineInv."Droit douane", true);

                    recLPurchaselineInv.FINDFIRST;
                    DroitDouaneLEntry.SetRange("DI No", rec."DI No.");
                    //DroitDouaneLEntry.FindFirst();
                    DroitDouaneLEntry.CalcSums(Amount);
                    if recLPurchaselineInv."Line Amount" <> DroitDouaneLEntry.Amount then
                        Error('La somme des Montants Droit douane pour Dossier Import %1 est différent de Montant %2', Rec."DI No.", recLPurchaselineInv."Line Amount")
                    else begin

                        DroitDouaneLEntry2.SetRange("DI No", rec."DI No.");
                        DroitDouaneLEntry2.FindFirst();
                        repeat
                            DroitDouaneLEntry2.TestField(Amount);
                            DroitDouaneLEntry2.TestField(NGP);
                            //DroitDouaneLEntry2.TestField(Origin);

                            recLpurchRcpHeader.SetRange("DI No.", Rec."DI No.");

                            recLpurchRcpHeader.FindFirst();

                            // A vérifier une seule réception par Dossier import
                            recLpurchRCPLine.SETRANGE(recLpurchRCPLine."Document No.", recLpurchRcpHeader."No.");
                            recLpurchRCPLine.SETRANGE(recLpurchRCPLine.Type, recLpurchRCPLine.Type::Item);
                            recLpurchRCPLine.SetRange("Tariff No.", DroitDouaneLEntry2.NGP);
                            recLpurchRCPLine.SetRange("Entry Point", DroitDouaneLEntry2.Origin);
                            recLpurchRCPLine.SetFilter(Quantity, '<>0');
                            IF recLpurchRCPLine.FINDFIRST THEN BEGIN


                                REPEAT
                                    LineNo += 1;
                                    ItemChargePurch.init;
                                    ItemChargePurch."Document Type" := Rec."Document Type";
                                    ItemChargePurch."Document No." := Rec."No.";
                                    ItemChargePurch."Document Line No." := recLPurchaselineInv."Line No.";

                                    ItemChargePurch."Line No." := LineNo; //ItemChargePurch."Line No." + 10000;

                                    ItemChargePurch.validate("Item Charge No.", recLPurchaselineInv."No.");
                                    ItemChargePurch.VALIDATE("Item No.", recLpurchRCPLine."No.");

                                    ItemChargePurch."Applies-to Doc. Type" := ItemChargePurch."Applies-to Doc. Type"::Receipt;
                                    ItemChargePurch."Applies-to Doc. No." := recLpurchRCPLine."Document No.";
                                    ItemChargePurch."Applies-to Doc. Line No." := recLpurchRCPLine."Line No.";

                                    ItemChargePurch.validate("Unit Cost", DroitDouaneLEntry2.Amount);
                                    ItemChargePurch."DI No." := Rec."DI No.";
                                    ItemChargePurch."Droit Douane" := true;
                                    //ItemChargePurch.

                                    percent := recLpurchRCPLine.Quantity * recLpurchRCPLine."Direct Unit Cost" * (1 - recLpurchRCPLine."Line Discount %" / 100)
                                    / GetTotalAmountNGP_inReceiptLines(recLpurchRCPLine."Document No.", DroitDouaneLEntry2.NGP, DroitDouaneLEntry2.Origin);

                                    ItemChargePurch.Validate("Amount to Assign", DroitDouaneLEntry2.Amount * percent);
                                    //ItemChargePurch.Validate("Qty. to Assign", percent);
                                    ItemChargePurch.Validate("Amount to Handle", DroitDouaneLEntry2.Amount * percent);
                                    // ItemChargePurch.Validate("Qty. to Handle", percent);

                                    ///Message('%1--%2', DroitDouaneLEntry2.Amount, percent);


                                    ItemChargePurch.Insert();
                                // Message('%1', ItemChargePurch);

                                // CUItemchargePurch.CreateRcptChargeAssgnt(recLpurchRCPLine, ItemChargePurch);

                                //TotalMtDD += 


                                UNTIL recLpurchRCPLine.NEXT = 0;




                                //      CUItemchargePurch.AssignItemCharges(recLPurchaselineInv, recLPurchaselineInv.Quantity, DroitDouaneLEntry2.Amount, 1);



                            END;

                        UNTIL DroitDouaneLEntry2.NEXT = 0;
                        MESSAGE('Ventilation de Droit Douane avec Succès');
                    end;

                end;
            }



        }
    }
    local procedure GetTotalAmountNGP_inReceiptLines(docNo: code[20]; Ngp: code[20]; Origin: code[20]) total: Decimal
    var
        recLpurchRCPLine: Record 121;
    begin
        recLpurchRCPLine.SetFilter("Document No.", docNo);

        recLpurchRCPLine.SetRange("Tariff No.", Ngp);
        recLpurchRCPLine.SetRange("Entry Point", Origin);
        recLpurchRCPLine.SetRange(Type, recLpurchRCPLine.Type::Item);
        recLpurchRCPLine.SetFilter(Quantity, '<>0');
        recLpurchRCPLine.FindFirst();
        repeat
            total += recLpurchRCPLine.Quantity * recLpurchRCPLine."Direct Unit Cost" * (1 - recLpurchRCPLine."Line Discount %" / 100);
        until recLpurchRCPLine.next = 0;
    end;
}