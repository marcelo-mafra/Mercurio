unit server.permissions.controller.factory;

interface

 uses
  System.Classes, System.SysUtils, server.permissions.interfaces,
  server.permissions.controller;

 type
   TPermissionsControllerFactory = class
    private

    public
     class function New: IPermissionsController;
   end;

implementation

{ TPermissionsControllerFactory }

class function TPermissionsControllerFactory.New: IPermissionsController;
begin
 Result := TPermissionsController.New;
end;

end.
