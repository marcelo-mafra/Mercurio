unit client.resources.serviceinfo;

interface

uses
  System.SysUtils;

type

  TServiceInfoServerMethods = class
    const
      ServiceInfoSucess = 'A chamada do m�todo remoto "ServiceInfo" ' +
        'foi executada com sucesso.';
      ServiceInfoError = 'A chamada do m�todo remoto "ServiceInfo" falhou.';
  end;

implementation

end.
