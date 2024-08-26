namespace Pharmatec.Pharmatec;

using Microsoft.Inventory.Item;

page 50011 ItemCategory
{
    APIGroup = 'Order';
    APIPublisher = 'OrderLine_Pharmatec';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'itemCategoryList';
    DelayedInsert = true;
    EntityName = 'ItemCategory';
    EntitySetName = 'ItemCategories';
    PageType = API;
    SourceTable = "Item Category";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                { Caption = 'Category Code'; }
                field(Description; Rec.Description)
                {
                    Caption = 'Description';
                }


            }

        }
    }
}
