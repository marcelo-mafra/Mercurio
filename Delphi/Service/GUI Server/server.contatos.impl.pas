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
 JsonObj: TJsonObject;
 JsonPair: TJsonPair;
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
     JsonObj := TJsonObject.Create;
     JsonObj.ParseJSONValue(StrData.Strings[I]);

     if I < StrData.Count - 1 then
      JDocumment.WriteString(JsonObj.Format + ',')
     else
      JDocumment.WriteString(JsonObj.Format);
    end;
    end;

  JDocumment.WriteString(']}');
  Result := JDocumment.DataString;

  finally
//   if Assigned(JsonObj) then FreeAndNil(JsonObj);
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

