unit client.model.listapermissions;

interface

uses
  System.SysUtils, System.Classes, client.interfaces.common, Generics.Collections,
  client.interfaces.baseclasses, client.interfaces.permissions, client.serverintf.permissions ;

type
   {Classe que representa uma lista de permissões.}
   TListaPermissions = class(TListaObjetos)
    private
       FList: TObjectList<TMyPermission>;
       function GetCount: integer;
       function GetIsEmpty: boolean;

    public
       constructor Create;
       destructor Destroy; override;

       procedure AddItem(value: TMyPermission); reintroduce;
       function Remove(Value: TMyPermission): boolean;
       function FindObject(Index: integer): TMyPermission;

       property Count: integer read GetCount;
       property IsEmpty: boolean read GetIsEmpty;
   end;

implementation

{ TListaPermissions }

procedure TListaPermissions.AddItem(value: TMyPermission);
begin
 FList.Add(Value);
end;

constructor TListaPermissions.Create;
begin
 FList := TObjectList<TMyPermission>.Create;
 FList.OwnsObjects := true;
end;

destructor TListaPermissions.Destroy;
begin
  FList.Clear;
  FList.Free;
  inherited;
end;

function TListaPermissions.FindObject(Index: integer): TMyPermission;
begin
 Result := FList.Items[Index];
end;

function TListaPermissions.GetCount: integer;
begin
 Result :=  FList.Count;
end;

function TListaPermissions.GetIsEmpty: boolean;
begin
 Result := FList.Count = 0;
end;

function TListaPermissions.Remove(Value: TMyPermission): boolean;
begin
 Result := FList.Remove(Value) >= 0;
end;

end.
