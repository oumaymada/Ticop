namespace Ticop_pharmatec.Ticop_pharmatec;

using Microsoft.Sales.Archive;

tableextension 50127 SalesLineArchive extends "Sales Line Archive"
{
    fields
    {
        field(50000; salesperson; Code[25])
        {
            Caption = 'Commercial';
            DataClassification = ToBeClassified;
        }
        field(50001; "Statut lig. devis"; Option)
        {
            Caption = 'Statut lig. devis';
            DataClassification = ToBeClassified;
            OptionMembers = " ","Encours","Gagné","Perdu";


        }
    }
}
