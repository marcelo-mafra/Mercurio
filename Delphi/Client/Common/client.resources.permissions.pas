unit client.resources.permissions;

interface

uses
  System.SysUtils;

type
{  Constantes relacionadas à execução de métodos no serviços remoto.}
  TPermissionsServerMethods = class
    const
      NewPermissionSucess = 'A chamada do método remoto "NewPermission" ' +
        'foi executada com sucesso.';
      NewPermissionError = 'A chamada do método remoto "NewPermission" falhou.';
      GetPermissionsSucess = 'A chamada do método remoto "GetPermissions" ' +
        'foi executada com sucesso.';
      GetPermissionsError = 'A chamada do método remoto "GetPermissions" falhou.';
      VariantCastError     = 'A conversão de um tipo de dados obtido do serviço remoto ' +
        'falhou e a leitura dos dados obtidos foi encerrada.';
  end;



implementation

end.
