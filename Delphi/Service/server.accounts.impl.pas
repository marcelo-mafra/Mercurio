unit server.accounts.impl;

interface

uses Soap.InvokeRegistry, System.Types, Soap.XSBuiltIns, System.SysUtils,
System.Json, System.Classes,
server.accounts.intf, server.accounts.interfaces, server.accounts.controller.factory;

type
  { TMercurioAccountsServer }
  TMercurioAccountsServer = class(TInvokableClass, IMercurioAccountsServer)
  strict private
    function GetController: IAccountsController;

  public
    function NewAccount(const value: TMyAccount): TMyAccount; stdcall;
    function GetMyAccounts: UnicodeString; stdcall;
    function DropAccount(const value: TMyAccount): boolean; stdcall;

    property Controller: IAccountsController read GetController;
  end;

implementation

{ TMercurioAccountsServer }

function TMercurioAccountsServer.DropAccount(const value: TMyAccount): boolean;
begin
 Result := self.Controller.DropAccount(value);
end;

function TMercurioAccountsServer.GetController: IAccountsController;
begin
 Result := TAccountsControllerFactory.New;
end;

function TMercurioAccountsServer.GetMyAccounts: UnicodeString;
begin
 Result := self.Controller.GetMyAccounts;
end;

function TMercurioAccountsServer.NewAccount(
  const value: TMyAccount): TMyAccount;
begin
 Result := self.Controller.NewAccount(value);
end;


initialization
{ Invokable classes must be registered }
   InvRegistry.RegisterInvokableClass(TMercurioAccountsServer);
end.
