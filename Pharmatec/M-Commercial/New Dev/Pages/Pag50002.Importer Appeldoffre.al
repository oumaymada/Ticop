namespace Pharmatec_Ticop.Pharmatec_Ticop;

page 50002 "Importer Appel d'offre"
{
    ApplicationArea = All;
    Caption = 'Importer Appel d''offre';
    PageType = List;
    SourceTable = "AO source";
    SourceTableView = where("Line Type" = filter(Appel));
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

                field("Line Description"; rec."Line Description")
                {
                    ToolTip = 'Specifies the value of the Opportunity field.', Comment = '%';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Opportunity field.', Comment = '%';
                }

                field("Internal No."; Rec."Internal No.")
                {
                    ToolTip = 'Specifies the value of the Opportunity field.', Comment = '%';
                }

                field("Item Description"; Rec."Item Description")
                {

                }



            }
        }
    }
}
