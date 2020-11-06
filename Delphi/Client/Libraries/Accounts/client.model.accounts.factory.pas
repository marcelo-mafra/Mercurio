unit client.model.accounts.factory;

interface

uses
 System.Classes, System.SysUtils, client.interfaces.accounts, client.model.accounts,
 client.serverintf.accounts;

type
  TFactoryAccounts = class
    class function New: IAccountsService;
    class procedure RegisterAccount(Account: TMyAccount);
  end;

implementation

{ TFactoryAccounts }

class function TFactoryAccounts.New: IAccountsService;
begin
{Retorna uma interface que abstrai recursos de permissionamento do usuário.}
  Result := TAccountsModel.Create as IAccountsService;
end;

class procedure TFactoryAccounts.RegisterAccount(Account: TMyAccount);
var
 AccountObj: TMyAccount;
 AccountsSvc: IAccountsService;
begin
    AccountObj := TMyAccount.Create;
    AccountsSvc := self.New;

    try
     { AccountObj.FeatureId := Integer(Feature);
      AccountObj.FeatureName := FeatureName;
      AccountObj.Usuario := Usuario;
      AccountObj.Enabled := True; }
      AccountObj := AccountsSvc.IAccount.NewAccount(AccountObj);

    finally
     FreeAndNil(AccountObj);
    end;

end;

end.
