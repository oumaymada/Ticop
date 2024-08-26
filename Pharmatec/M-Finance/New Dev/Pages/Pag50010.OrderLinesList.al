namespace Pharmatec.Pharmatec;

page 50010 OrderLinesList
{
    APIGroup = 'Order';
    APIPublisher = 'OrderLine_Pharmatec';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'orderLinesList';
    DelayedInsert = true;
    EntityName = 'OrderLine';
    EntitySetName = 'OrderLines';
    PageType = API;
    SourceTable = OrderLines;



    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(clientNo; Rec.ClientNo)
                {
                    Caption = 'ClientNo';
                }
                field(headerNo; Rec.HeaderNo)
                {
                    Caption = 'HeaderNo';
                }
                field(itemNo; Rec.ItemNo)
                {
                    Caption = 'ItemNo';
                }
                field(ligneTempNo; Rec.LigneTempNo)
                {
                    Caption = 'No';
                }
                field(qty; Rec.Qty)
                {
                    Caption = 'Qty';
                }
                field(dateDocument; Rec."date document")
                {
                    Caption = 'date d''échéance';
                }
                field(remise; Rec.remise)
                {
                    Caption = 'remise';
                }
                field(salespersoncode; Rec.salespersoncode)
                {
                    Caption = 'salespersoncode';
                }
            }
        }
    }
}
