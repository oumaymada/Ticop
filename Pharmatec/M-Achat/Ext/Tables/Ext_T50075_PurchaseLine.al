tableextension 50075 PurchaseLineExt extends "Purchase Line"
{
    fields
    {
        field(50101; "Tariff No."; Code[20])
        {
            Caption = 'Nomencalture Produit';
            DataClassification = ToBeClassified;
        }
        field(500102; "Droit douane"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50103; TVA; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                itm: Record item;
                ItemCharge: Record "Item Charge";
            begin
                if rec.Type = Rec.type::Item then begin
                    itm.get(rec."No.");
                    Rec.validate("Tariff No.", itm."Tariff No.");
                end;
                if rec.Type = rec.type::"Charge (Item)" then begin
                    ItemCharge.get(rec."No.");
                    "Droit douane" := ItemCharge."Droit Douane";
                    TVA := ItemCharge.TVA;

                end;
            end;
        }
    }

}