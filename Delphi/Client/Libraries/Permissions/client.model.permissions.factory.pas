unit client.model.permissions.factory;

interface

uses
 System.Classes, client.interfaces.permissions, client.model.permissions;

type
  TFactoryPermissions = class
    class function New: IPermissionsService; overload;
    //class function New: TPermissionsModel; overload;
  end;

implementation

{ TFactoryPermissions }

class function TFactoryPermissions.New: IPermissionsService;
begin
{Retorna uma interface que abstrai recursos de permissionamento do usuário.}
  Result := TPermissionsModel.Create as IPermissionsService;
end;



end.
