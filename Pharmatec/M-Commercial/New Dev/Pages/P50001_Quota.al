page 50001 "Quota List"

{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Reliquat;
    Editable = true;
    Caption = 'Liste Quota';


    layout
    {
        area(Content)
        {
            repeater(Reliquats)
            {
                field(SalesPerson; Rec.SalesPerson)
                {
                    ApplicationArea = All;

                }
                field(Itemcode; Rec.Itemcode)
                {

                    trigger OnValidate()
                    var
                        Itm: Record "Item";
                    begin
                        if itm.get(Rec.Itemcode) then
                            Rec."Item cathegory" := itm."Item Category Code";
                    end;
                }
                field("Item cathegory"; Rec."Item cathegory")
                {
                    trigger OnValidate()
                    begin

                    end;
                }
                field(Reliquat; Rec.Quota)

                {
                    StyleExpr = BoolFavorable;
                    trigger OnValidate()

                    begin

                        //   VerifQuota();
                    end;


                }
                /*  field("Qty In Sales Orders"; Rec."Qty In Sales Orders")
                  {
                      trigger OnValidate()
                      begin

                      end;
                  }
                  field("Qty Shiped"; Rec."Qty Shiped") { }
  */
                field("Start Date"; Rec."Start Date") { }
                field("End Date"; Rec."End Date") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        // VerifQuota();
    end;

    trigger OnOpenPage()
    begin
        VerifQuota();
        CurrPage.Update();
        //  Rec.SetAutoCalcFields("Qty In Sales Orders");


    end;

    var
        BoolFavorable: Text;

    procedure VerifQuota()
    begin
        /*    Rec.SetRange("Date Filter", Rec."Start Date", Rec."End Date");
            Rec.SetAutoCalcFields(Rec."Qty In Sales Orders");
            if Rec.Quota < Rec."Qty In Sales Orders" then
                // Changer la couleur de la ligne 
                BoolFavorable := 'Attention'
            else
                BoolFavorable := 'None';
                */

    end;
}