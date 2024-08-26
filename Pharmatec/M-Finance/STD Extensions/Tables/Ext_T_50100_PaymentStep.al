tableextension 50100 Ext_PaymentStep extends "Payment Step"
{
    fields
    {
        field(50100; "Impayé Client"; Boolean)
        {
            Caption = 'Impayé Client';
            FieldClass = Normal;

            Editable = True;
        }

        field(50101; "Comptabiliser RS Fournisseur"; Option)
        {
            Caption = 'Comptabiliser RS Fournisseur';
            FieldClass = Normal;
            OptionMembers = Acune,Validation,Annulation;
            Editable = True;
        }
    }

}