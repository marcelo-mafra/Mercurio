unit client.model.listapermissions;

interface

uses
  System.SysUtils, System.Classes, client.interfaces.common, Generics.Collections,
  client.interfaces.baseclasses, classes.permissions.types, client.serverintf.permissions ;

type
   {Classe que representa uma lista de permissões.}
   TListaPermissions = class(TListaObjetos)
    private
       FAllowedFeatures: TMercurioFeatures;
       FList: TObjectList<TMyPermission>;
       function GetCount: integer;
       function GetIsEmpty: boolean;
       procedure ResetPermissions;

    public
       constructor Create;
       destructor Destroy; override;

       procedure AddItem(value: TMyPermission); reintroduce;
       procedure Clear;
       function HasPermission(const Feature: TMercurioFeature): boolean;
       function Remove(Value: TMyPermission): boolean;
       function FindObject(Index: integer): TMyPermission;

       property AllowedFeatures: TMercurioFeatures read FAllowedFeatures;
       property Count: integer read GetCount;
       property IsEmpty: boolean read GetIsEmpty;
   end;

implementation

{ TListaPermissions }

procedure TListaPermissions.AddItem(value: TMyPermission);
begin
 FList.Add(Value);
 FAllowedFeatures := FAllowedFeatures + [TMercurioFeature(Value.FeatureId)];
end;

procedure TListaPermissions.Clear;
begin
 FList.Clear;
 self.ResetPermissions;
end;

constructor TListaPermissions.Create;
begin
 FList := TObjectList<TMyPermission>.Create;
 FList.OwnsObjects := true;
 ResetPermissions;
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

function TListaPermissions.HasPermission(
  const Feature: TMercurioFeature): boolean;
begin
 Result := Feature in FAllowedFeatures;
end;

function TListaPermissions.Remove(Value: TMyPermission): boolean;
begin
 Result := FList.Remove(Value) >= 0;
 if Result then
   FAllowedFeatures := FAllowedFeatures - [TMercurioFeature(Value.FeatureId)];
end;

procedure TListaPermissions.ResetPermissions;
begin
 FAllowedFeatures := [];
end;

end.
