unit client.resources.permissions;

interface

uses
  System.SysUtils;

type
{  Constantes relacionadas � execu��o de m�todos no servi�os remoto.}
  TPermissionsServerMethods = class
    const
      NewPermissionSucess = 'A chamada do m�todo remoto "NewPermission" ' +
        'foi executada com sucesso.';
      NewPermissionError = 'A chamada do m�todo remoto "NewPermission" falhou.';
      GetPermissionsSucess = 'A chamada do m�todo remoto "GetPermissions" ' +
        'foi executada com sucesso.';
      GetPermissionsError = 'A chamada do m�todo remoto "GetPermissions" falhou.';
      VariantCastError     = 'A convers�o de um tipo de dados obtido do servi�o remoto ' +
        'falhou e a leitura dos dados obtidos foi encerrada.';
  end;



implementation

end.
