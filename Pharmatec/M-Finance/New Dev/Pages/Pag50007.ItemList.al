namespace Pharmatec.Pharmatec;

using Microsoft.Inventory.Item;

page 50007 ItemList
{
    APIGroup = 'item';
    APIPublisher = 'Item_Pharmatec';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'itemList';
    DelayedInsert = true;
    EntityName = 'Item';
    EntitySetName = 'Items';
    PageType = API;
    SourceTable = Item;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(SystemId; Rec.SystemId)
                {

                }
                field("No"; Rec."No.")
                {
                    Caption = 'Item No';
                }
                field(Description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(ItemCategoryCode; Rec."Item Category Code")
                {
                    caption = 'code categorie article';
                }
                field(Inventory; Rec.Inventory)
                {
                    caption = 'stock';
                }
                field(UnitPrice; Rec."Unit Price")
                {
                    caption = 'prix unitaire';
                }

            }
        }
    }
}
