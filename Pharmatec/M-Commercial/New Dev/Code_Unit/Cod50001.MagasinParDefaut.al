namespace Pharmatec.Pharmatec;

using Microsoft.Sales.Document;

codeunit 50001 MagasinParDefaut
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeInsertEvent', '', false, false)]
    local procedure MagasinParDefaut(var Rec: Record "Sales Line")
    begin
        if Rec."Location Code" = '' then begin
            Rec."Location Code" := 'PRINCIPAL';
        end;
    end;





}

