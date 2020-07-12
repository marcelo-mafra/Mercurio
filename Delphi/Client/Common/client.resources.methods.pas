unit client.resources.methods;

interface

uses
  System.SysUtils;

  type
{    Constantes relacionadas � execu��o de m�todos remotos de "dom�nios" gerais.}
    TSOAPEventsMsg = class
      const
        AfterExecute = 'SOAP protocol: AfterExecute event. Method name: %s';
        RequestCompleted = 'SOAP protocol: RequestCompleted event';
        RequestError  = 'SOAP protocol: RequestError event';
    end;

{    Constantes relacionadas � execu��o de m�todos remotos de "dom�nios" gerais.}
    TServerMethodsCall = class
      const
        RemoteMethodsSucess = 'A execu��o de um m�todo remoto foi feita com sucesso!';
        RemoteMethodSucess = 'A execu��o do m�todo remoto "%s" foi feita com sucesso!';
        RemoteMethodError  = 'Ocorreu um erro na execu��o do m�todo remoto "%s"!';
    end;

implementation

end.
