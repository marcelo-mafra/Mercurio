unit server.permissions.impl;

interface

uses Soap.InvokeRegistry, System.Types, Soap.XSBuiltIns, System.Classes,
 server.permissions.intf, server.permissions.interfaces,
 server.permissions.controller.factory;

type
  { TMercurioPermissionsServer }
  TMercurioPermissionsServer = class(TInvokableClass, IMercurioPermissionsServer)
  strict private
    function GetController: IPermissionsController;

  public
    function NewPermission(const value: TMyPermission): TMyPermission; stdcall;
    function GetMyPermissions: UnicodeString; stdcall;
    function AsObjects: TMyPermissions; stdcall;

    property Controller: IPermissionsController read GetController;
  end;

implementation

{ TMercurioPermissionsServer }
function TMercurioPermissionsServer.GetController: IPermissionsController;
begin
 Result := TPermissionsControllerFactory.New;
end;

function TMercurioPermissionsServer.NewPermission(
  const value: TMyPermission): TMyPermission;
begin
 Result := self.Controller.NewPermission(value);
end;

function TMercurioPermissionsServer.GetMyPermissions: UnicodeString;
begin
 Result := self.Controller.GetMyPermissions;
end;

function TMercurioPermissionsServer.AsObjects: TMyPermissions;
begin
 Result := self.Controller.AsObjects;
end;

initialization
{ Invokable classes must be registered }
   InvRegistry.RegisterInvokableClass(TMercurioPermissionsServer);

end.
