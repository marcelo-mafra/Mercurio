unit server.permissions.interfaces;

interface

 uses
  System.Classes, server.common.interfaces, server.permissions.intf;

 type
   IPermissionsData = interface(IServerInterface)
     ['{46FF1CDC-CA04-412C-A0C4-3A78295A203A}']
     function NewPermission(const value: TMyPermission): TMyPermission;
     function GetMyPermissions: UnicodeString; overload;
     procedure GetMyPermissions(List: TStringList); overload;
     function AsObjects: TMyPermissions;
   end;

 type
   IPermissionsController = interface(IServerInterface)
     ['{E0EB14C1-381B-4D6E-AA8A-1D9BAF40EC6F}']
     function NewPermission(const value: TMyPermission): TMyPermission;
     function GetMyPermissions: UnicodeString; overload;
     procedure GetMyPermissions(List: TStringList); overload;
     function AsObjects: TMyPermissions;
   end;



 type
   IPermissionsList = interface(IServerInterface)
     ['{3C77C502-3DE2-4A57-8D89-2F3675DAA828}']
     procedure AddObject(var List: TMyPermissions; const value: TMyPermission);

   end;

implementation

end.
