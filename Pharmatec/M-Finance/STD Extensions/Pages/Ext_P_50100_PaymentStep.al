pageextension 50100 Ext_PaymentStep extends "Payment Step Card"
{
    layout
    {
        addafter("Source Code")
        {
            field("Impayé Client"; rec."Impayé Client")
            {
                ApplicationArea = All;
                Caption = 'Impayé Client';
                Editable = true;
                ToolTip = 'Constater l''impayé client lors de la validation de l''étape';
            }

            field("Comptabiliser RS Fournisseur"; Rec."Comptabiliser RS Fournisseur")
            {
                ApplicationArea = All;
                Editable = true;
                ToolTip = 'Constater la comptabilisation RS Fournisseur';
            }
        }

    }
}