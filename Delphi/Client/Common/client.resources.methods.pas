unit client.resources.methods;

interface

uses
  System.SysUtils;

  type
{    Constantes relacionadas � execu��o de m�todos remotos de "dom�nios" gerais.}
    TServerMethodsCall = class
      const
        RemoteMethodsSucess = 'A execu��o de um m�todo remoto foi feita com sucesso!';
        RemoteMethodSucess = 'A execu��o do m�todo remoto "%s" foi feita com sucesso!';
        RemoteMethodError  = 'Ocorreu um erro na execu��o do m�todo remoto "%s"!';
    end;

implementation

end.
