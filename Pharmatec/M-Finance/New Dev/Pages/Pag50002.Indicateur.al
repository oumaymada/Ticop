namespace Pharmatec.Pharmatec;

page 50003 Indicateur
{
    UsageCategory = Administration;
    RefreshOnActivate = true;

    ApplicationArea = All;
    Caption = 'Indicateur';
    PageType = CardPart;
    SourceTable = Indicateur;
    Editable = true;

    layout
    {
        area(Content)
        {
            /*  repeater(General)
              {
                  field("Clé"; Rec."Clé")
                  {
                      ToolTip = 'Specifies the value of the Clé field.', Comment = '%';
                  }
                  field("Fournisseur à payer"; Rec."Fournisseur à payer")
                  {
                      ToolTip = 'Specifies the value of the Fournisseur à payer field.', Comment = '%';
                  }
                  field("Risque Cheque en PF"; Rec."Risque Cheque en PF")
                  {
                      ToolTip = 'Specifies the value of the Risque Cheque en PF field.', Comment = '%';
                  }
                  field("Risque Effet "; Rec."Risque Effet ")
                  {
                      ToolTip = 'Specifies the value of the Risque Effet field.', Comment = '%';
                  }
              }*/

            cuegroup(Cue)

            {
                Caption = 'Engagement et Risques';


                field(Engagement; rec."Fournisseur à payer")
                {
                    Caption = 'Engagement';
                    DecimalPlaces = 0;

                }

                field("Risque Cheque Client"; rec."Risque Cheque en PF")
                {
                    Caption = 'Risque chèque client';
                    DecimalPlaces = 0;

                }
                field("Risque Effet Client"; rec."Risque Effet ")
                {

                    Caption = 'Risque effet Client';
                    DecimalPlaces = 0;

                    //DrillDownPageId = 



                }







            }





        }
    }
    trigger OnOpenPage();
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
