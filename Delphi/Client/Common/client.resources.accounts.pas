unit client.resources.accounts;

interface

uses
  System.SysUtils;

type
{  Constantes relacionadas à execução de métodos no serviços remoto.}
  TAccountsServerMethods = class
    const
      NewAccountSucess = 'A chamada do método remoto "NewPermission" ' +
        'foi executada com sucesso.';
      NewAccountError = 'A chamada do método remoto "NewPermission" falhou.';
      GetAccountsSucess = 'A chamada do método remoto "GetPermissions" ' +
        'foi executada com sucesso.';
      GetAccountsError = 'A chamada do método remoto "GetPermissions" falhou.';
      VariantCastError     = 'A conversão de um tipo de dados obtido do serviço remoto ' +
        'falhou e a leitura dos dados obtidos foi encerrada.';
  end;

implementation

end.
