{ Invokable implementation File for TMercurioChatServer which implements IMercurioChatServer }

unit server.contatos.impl;

interface

uses Soap.InvokeRegistry, System.Types, Soap.XSBuiltIns, server.contatos.intf,
 System.SysUtils;

type

  { TMercurioContatosServer }
  TMercurioContatosServer = class(TInvokableClass, IMercurioContatosServer)
  public
    function NewContato(const Value: TMyContato): TMyContato; stdcall;
  end;

implementation

function TMercurioContatosServer.NewContato(
  const Value: TMyContato): TMyContato;
begin
  Result := Value;
end;



initialization
{ Invokable classes must be registered }
   InvRegistry.RegisterInvokableClass(TMercurioContatosServer);
end.

