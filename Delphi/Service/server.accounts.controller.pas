unit server.accounts.controller;

interface

 uses
  System.Classes, System.SysUtils, System.Json,
  server.accounts.intf, server.accounts.interfaces, server.accounts.data.factory;

 type

   TAccountsController = class(TInterfacedObject, IAccountsController)
    private
     function GetDAOInterface: IAccountsData;

    public
     class function New: IAccountsController;

     function NewAccount(const value: TMyAccount): TMyAccount;
     function GetMyAccounts: UnicodeString;
     function DropAccount(const value: TMyAccount): boolean;

     property DAOInterface: IAccountsData read GetDAOInterface;
   end;


implementation

{ TAccountsController }

function TAccountsController.DropAccount(const value: TMyAccount): boolean;
begin
 Result := self.DAOInterface.DropAccount(value);
end;

function TAccountsController.GetDAOInterface: IAccountsData;
begin
 Result := TAccountsDAOFactory.New;
end;

function TAccountsController.GetMyAccounts: UnicodeString;
begin
 Result := self.DAOInterface.GetMyAccounts;
end;

class function TAccountsController.New: IAccountsController;
begin
 Result := TAccountsController.Create as IAccountsController;
end;

function TAccountsController.NewAccount(const value: TMyAccount): TMyAccount;
begin
 Result := self.DAOInterface.NewAccount(value);
end;

end.
