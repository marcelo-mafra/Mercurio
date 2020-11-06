unit client.resources.accounts;

interface

uses
  System.SysUtils;

type
{  Constantes relacionadas � execu��o de m�todos no servi�os remoto.}
  TAccountsServerMethods = class
    const
      NewAccountSucess = 'A chamada do m�todo remoto "NewPermission" ' +
        'foi executada com sucesso.';
      NewAccountError = 'A chamada do m�todo remoto "NewPermission" falhou.';
      GetAccountsSucess = 'A chamada do m�todo remoto "GetPermissions" ' +
        'foi executada com sucesso.';
      GetAccountsError = 'A chamada do m�todo remoto "GetPermissions" falhou.';
      VariantCastError     = 'A convers�o de um tipo de dados obtido do servi�o remoto ' +
        'falhou e a leitura dos dados obtidos foi encerrada.';
  end;

implementation

end.
