unit client.resources.methods;

interface

uses
  System.SysUtils;

  type
{    Constantes relacionadas à execução de métodos remotos de "domínios" gerais.}
    TServerMethodsCall = class
      const
        RemoteMethodsSucess = 'A execução de um método remoto foi feita com sucesso!';
        RemoteMethodSucess = 'A execução do método remoto "%s" foi feita com sucesso!';
        RemoteMethodError  = 'Ocorreu um erro na execução do método remoto "%s"!';
    end;

implementation

end.
