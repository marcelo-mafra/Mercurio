unit client.resources.svccon;

interface

uses
  System.SysUtils;

type
  TServiceConnectionConst = class
    const
      InvalidUrl        = 'O endere�o remoto � inv�lido!';
      NoServiceResponse = 'O servi�o remoto n�o respondeu a uma requisi��o feita.';
      StatusBadRequest  = 'Bad request';
      HttpStatus        = 'Ocorreu uma falha na comunica��o com o servi�o remoto. ' +
                          'C�digo de erro: %d. Mensagem: %s';
  end;

implementation

end.
