/// <summary>
/// Table Indicateur (ID 50003).
/// </summary>
table 50003 Indicateur
{
    Caption = 'Indicateur';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Clé"; Code[20])
        {
            Caption = 'Clé';
        }
        field(2; "Fournisseur à payer"; Decimal)
        {
            Caption = 'Fournisseur à payer';
            FieldClass = FlowField;
            //0-ESPECE FOURNISSEUR' | '11-CHEQUE FOURNISSEUR' | '12-EFEET FOURNISSEUR' | '13-VIREMENT FOURNISSEUR
            CalcFormula = sum("payment line".Amount where("Payment Class" = filter('*FOURNISSEUR*'), "Payment in Progress" = filter(true), "Copied To No." = filter(''),
            "Engagement financier" = filter('>0')
            ));
        }
        field(3; "Risque Cheque en PF"; Decimal)
        {
            Caption = 'Risque Cheque en PF';
            FieldClass = FlowField;
            CalcFormula = - sum("Payment Line".amount where("Payment Class" = filter('*CLIENT*'), "Copied To No." = filter(''), Risque = filter('CPF')));
        }
        field(4; "Risque Effet "; Decimal)
        {
            Caption = 'Risque Effet ';
            FieldClass = FlowField;
            CalcFormula = - sum("Payment Line".Amount where("Payment Class" = filter('*CLIENT*'), "Copied To No." = filter(''), Risque = filter('EEN')
             ));
        }
    }
    keys
    {
        key(PK; "Clé")
        {
            Clustered = true;
        }
    }
}
