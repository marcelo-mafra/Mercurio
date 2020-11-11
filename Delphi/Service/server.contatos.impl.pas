{ Invokable implementation File for TMercurioChatServer which implements IMercurioChatServer }

unit server.contatos.impl;

interface

uses Soap.InvokeRegistry, System.Types, Soap.XSBuiltIns, server.contatos.intf,
 System.SysUtils, System.Json, System.Classes, server.contatos.data;

type
  TJsonConsts = class //do not localize!
    const
      ArrayContatos = '{"ArrayContatos":[';
      JsonTerminator  = ',';
      ArrayTerminator = ']}';
  end;

  { TMercurioContatosServer }
  TMercurioContatosServer = class(TInvokableClass, IMercurioContatosServer)
  public
    function NewContato(const value: TMyContato): TMyContato; stdcall;
    function GetMyContatos: UnicodeString; stdcall;
    function ExcluirContato(const value: TMyContato): boolean; stdcall;
  end;

implementation


function TMercurioContatosServer.ExcluirContato(const value: TMyContato): boolean;
begin
 Result := TContatosData.ExcluirContato(Value);
end;

function TMercurioContatosServer.GetMyContatos: UnicodeString;
var
 I: integer;
 JDocumment: TStringStream;
 StrData: TStringList;
begin
  JDocumment := TStringStream.Create(string.Empty, TEncoding.UTF8);
  JDocumment.WriteString(TJsonConsts.ArrayContatos);
  StrData := TContatosData.GetContatos;

  try
   if StrData.Count > 0 then
   begin
   for I := 0 to StrData.Count - 1 do
    begin
     if I < StrData.Count - 1 then
      JDocumment.WriteString(StrData.Strings[I] + TJsonConsts.JsonTerminator)
     else
      JDocumment.WriteString(StrData.Strings[I]);
    end;
    end;
 //Escreve o s�mbolo de fim do conjunto no padr�o json.
  JDocumment.WriteString(TJsonConsts.ArrayTerminator);
  Result := JDocumment.DataString;

  finally
   if Assigned(JDocumment) then FreeAndNil(JDocumment);
  end;
end;

function TMercurioContatosServer.NewContato(
  const value: TMyContato): TMyContato;
begin
  Result := TContatosData.NewContato(Value);
end;



initialization
{ Invokable classes must be registered }
   InvRegistry.RegisterInvokableClass(TMercurioContatosServer);
end.
