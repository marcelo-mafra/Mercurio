unit client.model.permissions.factory;

interface

uses
 System.Classes, System.SysUtils, client.interfaces.permissions, client.model.permissions,
 classes.permissions.types, client.serverintf.permissions;

type
  TFactoryPermissions = class
    class function New: IPermissionsService;
    class procedure RegisterPermission(Feature: TMercurioFeature;
      FeatureName, Usuario: string);
  end;

implementation

{ TFactoryPermissions }

class function TFactoryPermissions.New: IPermissionsService;
begin
{Retorna uma interface que abstrai recursos de permissionamento do usuário.}
  Result := TPermissionsModel.Create as IPermissionsService;
end;

class procedure TFactoryPermissions.RegisterPermission(
  Feature: TMercurioFeature; FeatureName, Usuario: string);
var
 PermissionObj: TMyPermission;
 PermissionsSvc: IPermissionsService;
begin
    PermissionObj := TMyPermission.Create;
    PermissionsSvc := self.New;

    try
      PermissionObj.FeatureId := Integer(Feature);
      PermissionObj.FeatureName := FeatureName;
      PermissionObj.Usuario := Usuario;
      PermissionObj.Enabled := True;
      PermissionObj := PermissionsSvc.IPermission.NewPermission(PermissionObj);

    finally
     FreeAndNil(PermissionObj);
    end;
end;

end.
