unit server.permissions.impl;

interface

uses Soap.InvokeRegistry, System.Types, Soap.XSBuiltIns, server.permissions.intf,
 System.SysUtils, System.Json, System.Classes, server.permissions.data;

type

  { TMercurioPermissionsServer }
  TMercurioPermissionsServer = class(TInvokableClass, IMercurioPermissionsServer)
  public
    function NewPermission(const value: TMyPermission): TMyPermission; stdcall;
    function GetMyPermissions: UnicodeString; stdcall;
  end;

implementation

{ TMercurioPermissionsServer }

function TMercurioPermissionsServer.GetMyPermissions: UnicodeString;
var
 I: integer;
 JDocumment: TStringStream;
 StrData: TStringList;
begin
  JDocumment := TStringStream.Create('', TEncoding.UTF8);
  JDocumment.WriteString('{"ArrayPermissoes":[');
  StrData := TPermissionsData.GetPermissions;

  try
   if StrData.Count > 0 then
   begin
   for I := 0 to StrData.Count - 1 do
    begin
     if I < StrData.Count - 1 then
      JDocumment.WriteString(StrData.Strings[I] + ',')
     else
      JDocumment.WriteString(StrData.Strings[I]);
    end;
    end;
 //Escreve o símbolo de fim do conjunto no padrão json.
  JDocumment.WriteString(']}');
  Result := JDocumment.DataString;

  finally
   if Assigned(JDocumment) then FreeAndNil(JDocumment);
  end;

end;


function TMercurioPermissionsServer.NewPermission(
  const value: TMyPermission): TMyPermission;
begin
  Result := TPermissionsData.NewPermission(value);
end;

initialization
{ Invokable classes must be registered }
   InvRegistry.RegisterInvokableClass(TMercurioPermissionsServer);

end.
