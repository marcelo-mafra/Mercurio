unit client.interfaces.accounts;

interface

{Contém interfaces que abstraem entidades relacionadas ao permissionamento.}

uses
 client.interfaces.common, client.interfaces.baseclasses, //classes.permissions.types,
 client.serverintf.accounts;

type
 //It abstracts the entity for a permission for feature.
 IAccountService = interface(IMercurioInterface)
  ['{319F5504-E6A3-48F5-8BCD-41E37A8A0AA5}']
  //function GetEnabled: boolean;
  //function GetFeatureName: string;
  function NewAccount(Value: TMyAccount): TMyAccount;

  //property Enabled: boolean read GetEnabled;
  //property FeatureName: string read GetFeatureName;

 end;

 //It abstracts the entity for a set of permissions.
 IAccountsService = interface(IMercurioInterface)
  ['{6F4581E4-C41F-4697-B196-1F85620AC146}']

  function GetIAccount: IAccountService;
  procedure GetMyAccounts(List: TListaObjetos);

  property IAccount: IAccountService read GetIAccount;
 end;

implementation

end.
