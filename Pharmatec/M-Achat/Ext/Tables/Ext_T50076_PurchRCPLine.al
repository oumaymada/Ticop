tableextension 50076 purchaseRcpLineExt extends "Purch. Rcpt. Line"
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
    }


}