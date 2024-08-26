namespace Pharmatec.Pharmatec;

page 50057 "Retenue à la source Card"
{
    PageType = List;
    SourceTable = "Retenue à la source";
    ApplicationArea = All;
    Caption = 'Retenue à la source';

    layout
    {
        area(content)
        {
            repeater("Liste de retenue")
            {

                field("Code Retenue"; Rec."Code Retenue")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Taux; Rec.Taux)
                {
                    ApplicationArea = All;
                }
                field("Compte GL"; Rec."Compte GL")
                {
                    ApplicationArea = All;
                }
            }

        }
    }
}