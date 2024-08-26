namespace Pharmatec.Pharmatec;

using Microsoft.CRM.Team;

pageextension 50015 Salesperson extends "Salesperson/Purchaser Card"
{

    layout
    {
        addafter(Name)
        {
            field(PWD; Rec.PWD)
            {
                ApplicationArea = all;
                Caption = 'Mot de Passe';
                ExtendedDatatype = Masked;
                ShowMandatory = true;

            }
            field(Active; Rec.Active)
            {
                ApplicationArea = all;
                Caption = 'Actif';

                ShowMandatory = true;

            }
            field("Code Secteur"; Rec."Code Secteur")
            {
                ApplicationArea = all;
                Caption = 'Code Secteur';

                ShowMandatory = true;
            }

        }

    }
}
