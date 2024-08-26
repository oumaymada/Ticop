namespace Pharmatec_Ticop.Pharmatec_Ticop;

page 50000 "Reponse Appel d'offre"
{
    ApplicationArea = All;
    Caption = 'Reponse Appel d''offre';
    PageType = List;
    SourceTable = "AO source";
    SourceTableView = where("Line Type" = filter(Réponse));
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(General)
            {


                field("Lot"; Rec."Lot No.")
                {
                    ToolTip = 'Specifies the value of the Opportunity field.', Comment = '%';
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Opportunity field.', Comment = '%';
                }
                field(Winner; Rec.Winner)
                {
                    ToolTip = 'Specifies the value of the Gagnant field.', Comment = '%';
                }

                field("Win Price"; Rec."Winner Price")
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                }
                field("Win Type"; Rec."Win Type")
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                }

                field("Internal No."; Rec."Internal No.")
                {
                    ToolTip = 'Specifies the value of the Opportunity field.', Comment = '%';
                    Editable = false;
                }

            }
        }
    }
}
