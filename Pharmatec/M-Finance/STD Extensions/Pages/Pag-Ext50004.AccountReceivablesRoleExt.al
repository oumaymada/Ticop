namespace Pharmatec.Pharmatec;

using Microsoft.Finance.RoleCenters;

pageextension 50105 "Account Receivables Role Ext" extends "Account Receivables"
{

    layout
    {
        addfirst(RoleCenter)
        {
            part(Indicateur; Indicateur)
            {

            }

        }
    }
}
