unit server.permissions.data.factory;

interface

 uses
  System.Classes, System.SysUtils,
  server.permissions.data, server.permissions.interfaces;

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
 Result := TDAOPermissions.Create as IPermissionsData;
end;

end.
