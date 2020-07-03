{ Invokable implementation File for TMercurioChatServer which implements IMercurioChatServer }

unit server.contatos.impl;

interface

uses Soap.InvokeRegistry, System.Types, Soap.XSBuiltIns, server.contatos.intf,
 System.SysUtils, System.Json, System.Classes, server.data.contatos;

type

  { TMercurioContatosServer }
  TMercurioContatosServer = class(TInvokableClass, IMercurioContatosServer)
  public
    function NewContato(const Value: TMyContato): TMyContato; stdcall;
    function GetMyContatos: UnicodeString; stdcall;
  end;

implementation


function TMercurioContatosServer.GetMyContatos: UnicodeString;
var
 I: integer;
 JDocumment: TStringStream;
 StrData: TStringList;
begin
  JDocumment := TStringStream.Create('', TEncoding.UTF8);
  JDocumment.WriteString('{"ArrayContatos":[');
  StrData := TContatosData.GetContatos;

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

  JDocumment.WriteString(']}');
  Result := JDocumment.DataString;

  finally
   if Assigned(JDocumment) then FreeAndNil(JDocumment);
  end;
end;

function TMercurioContatosServer.NewContato(
  const Value: TMyContato): TMyContato;
begin
  Result := TContatosData.NewContato(Value);
end;



initialization
{ Invokable classes must be registered }
   InvRegistry.RegisterInvokableClass(TMercurioContatosServer);
end.

