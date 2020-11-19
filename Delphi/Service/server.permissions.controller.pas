unit server.permissions.controller;

interface

 uses
  System.Classes, System.SysUtils, System.Json,
  server.permissions.intf, server.permissions.interfaces, server.permissions.data.factory;

 type

   TPermissionsController = class(TInterfacedObject, IPermissionsController)
    private
     function GetDAOInterface: IPermissionsData;

    public
     class function New: IPermissionsController;

     function NewPermission(const value: TMyPermission): TMyPermission;
     function GetMyPermissions: UnicodeString; overload;
     procedure GetMyPermissions(List: TStringList); overload;
     function AsObjects: TMyPermissions;

     property DAOInterface: IPermissionsData read GetDAOInterface;
   end;

implementation

{ TPermissionsController }
class function TPermissionsController.New: IPermissionsController;
begin
 Result :=  TPermissionsController.Create as IPermissionsController;
end;

function TPermissionsController.AsObjects: TMyPermissions;
begin
 Result := self.DAOInterface.AsObjects;
end;

procedure TPermissionsController.GetMyPermissions(List: TStringList);
begin
 self.DAOInterface.GetMyPermissions(List);
end;

function TPermissionsController.GetMyPermissions: UnicodeString;
begin
 Result := self.DAOInterface.GetMyPermissions;
end;

function TPermissionsController.GetDAOInterface: IPermissionsData;
begin
 Result := TPermissionsDataFactory.New;
end;

function TPermissionsController.NewPermission(
  const value: TMyPermission): TMyPermission;
begin
 Result := self.DAOInterface.NewPermission(value);
end;

end.
