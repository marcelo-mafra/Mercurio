{ Invokable implementation File for TMercurioChatServer which implements IMercurioChatServer }

unit server.contatos.impl;

interface

uses Soap.InvokeRegistry, System.Types, Soap.XSBuiltIns, server.contatos.intf,
 System.SysUtils, System.Json, System.Classes;

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
 JsonObj: TJsonObject;
 JsonPair: TJsonPair;
 JDocumment: TStringStream;
begin
  JDocumment := TStringStream.Create('', TEncoding.UTF8);
  JDocumment.WriteString('{"ArrayContatos":[');

  try
   for I := 0 to 10 do
   begin
     JsonObj := TJsonObject.Create;
     JsonObj.AddPair(TJsonPair.Create('FirstName', 'Marcelo' + Random.ToString));
     JsonObj.AddPair(TJsonPair.Create('LastName', 'Mafra'));

     if I < 10 then
      JDocumment.WriteString(JsonObj.Format + ',')
     else
      JDocumment.WriteString(JsonObj.Format);
   end;

  JDocumment.WriteString(']}');
  Result := JDocumment.DataString;

  finally
   if Assigned(JsonObj) then FreeAndNil(JsonObj);
   if Assigned(JDocumment) then FreeAndNil(JDocumment);
  end;
end;

function TMercurioContatosServer.NewContato(
  const Value: TMyContato): TMyContato;
begin
  Result := Value;
end;



initialization
{ Invokable classes must be registered }
   InvRegistry.RegisterInvokableClass(TMercurioContatosServer);
end.

