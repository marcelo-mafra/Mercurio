unit server.permissions.data.factory;

interface

 uses
  System.Classes, System.SysUtils,
  server.permissions.interfaces, server.permissions.data;

 type

   TPermissionsDataFactory = class
    private

    public
     class function New: IPermissionsData;
   end;

implementation

{ TPermissionsDataFactory }

class function TPermissionsDataFactory.New: IPermissionsData;
begin
 Result := TPermissionsDAO.Create as IPermissionsData;
end;

end.
