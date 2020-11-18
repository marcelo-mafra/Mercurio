unit client.model.permissions.factory;

interface

uses
 System.Classes, System.SysUtils, client.interfaces.permissions, client.model.permissions,
 classes.permissions.types, client.serverintf.permissions;

type
  TFactoryPermissions = class
   public
    class function New: IPermissionsService;

  end;

implementation

{ TFactoryPermissions }

class function TFactoryPermissions.New: IPermissionsService;
begin
{Retorna uma interface que abstrai recursos de permissionamento do usuário.}
  Result := TPermissionsModel.Create as IPermissionsService;
end;


end.
