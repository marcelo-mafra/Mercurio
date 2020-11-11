unit client.model.accounts.factory;

interface

uses
 System.Classes, System.SysUtils, client.interfaces.accounts, client.model.accounts,
 client.serverintf.accounts;

type
  TFactoryAccounts = class
   private
    class function GetIAccountService: IAccountService;

   public
    class function New: IAccountsService;
    class procedure RegisterAccount(Account: TMyAccount);

    property IAccount: IAccountService read GetIAccountService;
  end;

implementation

{ TFactoryAccounts }

class function TFactoryAccounts.GetIAccountService: IAccountService;
begin
 Result := TFactoryAccounts.New.IAccount;
end;

class function TFactoryAccounts.New: IAccountsService;
begin
{Retorna uma interface que abstrai recursos de contas de usuários.}
  Result := TAccountsModel.Create as IAccountsService;
end;

class procedure TFactoryAccounts.RegisterAccount(Account: TMyAccount);
var
 AccountObj: TMyAccount;
 AccountsSvc: IAccountsService;
begin
    AccountObj := TMyAccount.Create;
    AccountsSvc := TFactoryAccounts.New;

    try
      AccountObj.CreatedAt.AsDateTime := Now;
      AccountObj.Enabled := True;
      AccountObj := AccountsSvc.IAccount.NewAccount(AccountObj);

    finally
     FreeAndNil(AccountObj);
    end;

end;

end.
