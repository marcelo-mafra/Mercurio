{ Invokable implementation File for TMercurioChatServer which implements IMercurioChatServer }

unit server.contatos.impl;

interface

uses Soap.InvokeRegistry, System.Types, Soap.XSBuiltIns, System.SysUtils,
 System.Json, System.Classes,
 server.contatos.intf, server.contatos.interfaces, server.contatos.controller.factory;

type
  { TMercurioContatosServer }
  TMercurioContatosServer = class(TInvokableClass, IMercurioContatosServer)
  strict private
    function GetController: IContatosController;

  public
    function NewContato(const value: TMyContato): TMyContato; stdcall;
    function GetMyContatos: UnicodeString; stdcall;
    function ExcluirContato(const value: TMyContato): boolean; stdcall;
    function AsObjects: TMyContatos; stdcall;

    property Controller: IContatosController read GetController;
  end;

implementation


function TMercurioContatosServer.AsObjects: TMyContatos;
begin
 Result := self.Controller.AsObjects;
end;

function TMercurioContatosServer.ExcluirContato(const value: TMyContato): boolean;
begin
 Result := Controller.ExcluirContato(value);
end;

function TMercurioContatosServer.GetController: IContatosController;
begin
 Result := TContatosControllerFactory.New;
end;

function TMercurioContatosServer.GetMyContatos: UnicodeString;
begin
 Result := Controller.GetMyContatos;
end;

function TMercurioContatosServer.NewContato(
  const value: TMyContato): TMyContato;
begin
  Result := Controller.NewContato(value);
end;



initialization
{ Invokable classes must be registered }
   InvRegistry.RegisterInvokableClass(TMercurioContatosServer);
end.

