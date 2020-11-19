{ Invokable implementation File for TMercurioChatServer which implements IMercurioChatServer }

unit server.contatos.impl;

interface

uses Soap.InvokeRegistry, System.Types, Soap.XSBuiltIns, server.contatos.intf,
 System.SysUtils, System.Json, System.Classes, server.contatos.interfaces,
 server.contatos.controller;

type
  TJsonConsts = class //do not localize!
    const
      ArrayContatos = '{"ArrayContatos":[';
      JsonTerminator  = ',';
      ArrayTerminator = ']}';
  end;

  { TMercurioContatosServer }
  TMercurioContatosServer = class(TInvokableClass, IMercurioContatosServer)
  strict private
    function GetController: IContatosController;

  public
    function NewContato(const value: TMyContato): TMyContato; stdcall;
    function GetMyContatos: UnicodeString; stdcall;
    function ExcluirContato(const value: TMyContato): boolean; stdcall;

    property Controller: IContatosController read GetController;
  end;

implementation


function TMercurioContatosServer.ExcluirContato(const value: TMyContato): boolean;
begin
 Result := Controller.ExcluirContato(Value);
end;

function TMercurioContatosServer.GetController: IContatosController;
begin
 REsult := TContatosController.New;
end;

function TMercurioContatosServer.GetMyContatos: UnicodeString;
var
 I: integer;
 JDocumment: TStringStream;
 StrData: TStringList;
begin
  JDocumment := TStringStream.Create(string.Empty, TEncoding.UTF8);
  JDocumment.WriteString(TJsonConsts.ArrayContatos);
  StrData := Controller.GetMyContatos;

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
 //Escreve o símbolo de fim do conjunto no padrão json.
  JDocumment.WriteString(TJsonConsts.ArrayTerminator);
  Result := JDocumment.DataString;

  finally
   if Assigned(JDocumment) then FreeAndNil(JDocumment);
  end;
end;

function TMercurioContatosServer.NewContato(
  const value: TMyContato): TMyContato;
begin
  Result := Controller.NewContato(Value);
end;



initialization
{ Invokable classes must be registered }
   InvRegistry.RegisterInvokableClass(TMercurioContatosServer);
end.

