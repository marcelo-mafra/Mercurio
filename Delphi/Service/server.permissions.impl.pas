unit server.permissions.impl;

interface

uses Soap.InvokeRegistry, System.Types, Soap.XSBuiltIns, System.Classes,
 server.permissions.intf, server.permissions.interfaces,
 server.permissions.data.factory;

type
  { TMercurioPermissionsServer }
  TMercurioPermissionsServer = class(TInvokableClass, IMercurioPermissionsServer)
  strict private
    function GetPermissionsData: IPermissionsData;
  public
    function NewPermission(const value: TMyPermission): TMyPermission; stdcall;
    function GetMyPermissions: UnicodeString; stdcall;
    function AsObjects: TMyPermissions; stdcall;

    property PermissionsData: IPermissionsData read GetPermissionsData;
  end;

implementation

{ TMercurioPermissionsServer }
function TMercurioPermissionsServer.GetPermissionsData: IPermissionsData;
begin
 Result := TPermissionsDataFactory.New;
end;

function TMercurioPermissionsServer.NewPermission(
  const value: TMyPermission): TMyPermission;
begin
 Result := self.PermissionsData.NewPermission(value);
end;

function TMercurioPermissionsServer.GetMyPermissions: UnicodeString;
begin
 Result := self.PermissionsData.GetMyPermissions;
end;

function TMercurioPermissionsServer.AsObjects: TMyPermissions;
begin
 Result := self.PermissionsData.AsObjects;
end;

initialization
{ Invokable classes must be registered }
   InvRegistry.RegisterInvokableClass(TMercurioPermissionsServer);

end.
