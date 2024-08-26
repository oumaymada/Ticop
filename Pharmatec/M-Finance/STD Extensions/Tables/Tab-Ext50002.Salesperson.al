namespace Pharmatec.Pharmatec;

using Microsoft.CRM.Team;
using Microsoft.Inventory.Intrastat;

tableextension 50002 Salesperson extends "Salesperson/Purchaser"
{
    fields
    {
        field(50015; "PWD"; Code[25])
        {
            Caption = '';
            DataClassification = ToBeClassified;
            NotBlank = true;

        }
        field(50143; "Code Secteur"; Code[20])
        {
            Caption = 'Code Secteur';
            DataClassification = ToBeClassified;
            TableRelation = Territory.Code;
            NotBlank = true;
        }
        field(50016; "Active"; Boolean)
        {
            Caption = 'Actif';
            DataClassification = ToBeClassified;
            NotBlank = true;
            InitValue = true;


        }
    }
}
