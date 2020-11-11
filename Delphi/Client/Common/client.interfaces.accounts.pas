unit client.interfaces.accounts;

interface

{Contém interfaces que abstraem entidades relacionadas a contas de acesso.}

uses
 client.interfaces.common, client.interfaces.baseclasses,
 client.serverintf.accounts;

type
 //It abstracts the entity for an account.
 IAccountService = interface(IMercurioInterface)
  ['{319F5504-E6A3-48F5-8BCD-41E37A8A0AA5}']

  function NewAccount(Value: TMyAccount): TMyAccount;
 end;

 //It abstracts the entity for a set of accounts.
 IAccountsService = interface(IMercurioInterface)
  ['{6F4581E4-C41F-4697-B196-1F85620AC146}']

  function GetIAccount: IAccountService;
  procedure GetMyAccounts(List: TListaObjetos);

  property IAccount: IAccountService read GetIAccount;
 end;

implementation

end.
