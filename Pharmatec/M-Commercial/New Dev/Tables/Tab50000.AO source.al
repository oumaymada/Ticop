table 50000 "AO source"
{
    Caption = 'AO source';
    DataClassification = ToBeClassified;
    LookupPageId = "Reponse Appel d'offre";
    DrillDownPageId = "Reponse Appel d'offre";

    fields
    {
        field(1; Opportunity; Code[25])
        {
            Caption = 'Opportunité';
            TableRelation = Opportunity;
            Editable = false;

        }


        field(2; "Line Type"; Option)
        {
            Caption = 'Type Ligne';
            OptionMembers = " ","Appel","Réponse";
        }

        field(3; "Lot No."; Code[25])
        {
            Caption = 'Lot AO';
            trigger OnValidate()
            begin
                "Set internal No.";
            end;

        }
        field(4; "Line No."; Code[5])
        {
            Caption = 'N° Ligne';

            trigger OnValidate()
            begin
                "Set internal No.";
            end;
        }
        field(5; Winner; Code[25])
        {
            Caption = 'Gagnant';
            TableRelation = Contact where("Company Name" = filter('CONCURRENTS'));
            trigger OnValidate()
            var
                SalesHeader: Record "Sales Header";
                SalesHeaderArch: Record "Sales Header Archive";
            begin

                "Set internal No.";
                SalesHeader.SetRange("document type", SalesHeader."Document Type"::Quote);
                SalesHeader.SetFilter("Opportunity No.", Opportunity);
                if SalesHeader.FindFirst() then
                    Validate("Quote No.", SalesHeader."No.")
                else begin
                    SalesHeaderArch.SetRange("document type", SalesHeader."Document Type"::Quote);
                    SalesHeaderArch.SetFilter("Opportunity No.", Opportunity);
                    if SalesHeaderArch.FindFirst() then
                        Validate("Quote No.", SalesHeaderArch."No.");
                end;
            end;

        }
        field(6; "Win Type"; Option)
        {
            Caption = 'Type';
            OptionMembers = " ","Moins-disant","Mieux-disant";
        }


        field(7; "Winner Price"; Decimal)
        {
            Caption = 'Prix Gagnant';

        }

        field(8; "Line Description"; Code[25])
        {
            Caption = 'Désignation Ligne';


        }

        field(20; "Internal No."; Code[25])
        {
            Caption = 'Référence Pharmatec';
            TableRelation = Item;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                Item: record Item;
            begin
                if "Internal No." <> '' then
                    if "Internal No." <> '' then begin
                        Item.GET("Internal No.");
                        "Item Description" := Item.Description;
                        "User Code" := UserId;
                    end
                    else begin
                        "User Code" := '';
                        "Item Description" := '';
                    end;
            end;

        }

        field(21; "Quote No."; Code[20])
        {
            Caption = 'Devis';
            Editable = false;

            trigger OnValidate()
            var
                SalesLine: Record "Sales Line";
            //SalesLineArch: Record "Sales Line Archive";

            begin
                if ("Internal No." <> '') and ("Quote No." <> '') then begin
                    SalesLine.SetRange("document type", SalesLine."Document Type"::Quote);
                    SalesLine.SetFilter("document No.", "Quote No.");
                    SalesLine.SetFilter("No.", "Internal No.");

                    if SalesLine.FindFirst() then begin
                        if Winner = 'PHARMATEC' then
                            SalesLine."Statut lig. devis" := SalesLine."Statut lig. devis"::"Gagné"
                        else
                            if SalesLine."Statut lig. devis" <> SalesLine."Statut lig. devis"::"Gagné" then
                                SalesLine."Statut lig. devis" := SalesLine."Statut lig. devis"::Perdu;
                        SalesLine.Modify();
                    end
                end;
            end;

        }

        field(22; "User Code"; Code[25])
        {
            Caption = 'Code Utilisateur';
            Editable = false;


        }
        field(23; "Item Description"; Text[100])
        {
            Caption = 'Désignation article';
            Editable = false;


        }

        field(24; "Quantity"; Decimal)
        {
            Caption = 'Qté demandée article';



        }




    }


    keys
    {
        key(PK; Opportunity, "Line Type", "Lot No.", "Line No.", Winner)
        {
            Clustered = true;
        }
        key(key2; "Quote No.", "Internal No.")
        {

        }

    }
    local procedure "Set internal No."()
    var
        AO: Record "AO source";
    begin

        if ("Line Type" = "Line Type"::"Réponse") and ("Lot No." <> '') and ("Line No." <> '') and ("Internal No." = '') then begin
            if AO.Get(Opportunity, "Line Type"::Appel, "Lot No.", "Line No.", '') then
                Validate("Internal No.", ao."Internal No.");
        end;
    end;
}
