{ Invokable implementation File for TMercurioChatServer which implements IMercurioChatServer }

unit server.chatserver.impl;

interface

uses Soap.InvokeRegistry, System.Types, Soap.XSBuiltIns, server.chatserver.intf,
 System.SysUtils, System.Json,
 server.chatserver.interfaces, server.chatserver.controller.factory;

type

  { TMercurioChatServer }
  TMercurioChatServer = class(TInvokableClass, IMercurioChatServer)
  strict private
    function GetController: IChatServerController;

  public
    function NewChatMessage(const value: TChatMessage): TChatMessage; stdcall;
    property Controller: IChatServerController read GetController;
  end;

implementation

function TMercurioChatServer.GetController: IChatServerController;
begin
 Result := TChatServerControllerFactory.New;
end;

function TMercurioChatServer.NewChatMessage(
  const value: TChatMessage): TChatMessage;
begin
  Result := self.Controller.NewChatMessage(value);
end;


initialization
{ Invokable classes must be registered }
   InvRegistry.RegisterInvokableClass(TMercurioChatServer);
end.

