unit client.resources.connection;

interface

uses
  System.SysUtils;

type
{ Constantes relacionadas a conex�o com o servi�o remoto.}
  TConnectionSucess = class
    const
      ConnectionSucess    = 'A conex�o com o servi�o remoto foi iniciada com sucesso.';
      DisconnectionSucess = 'A aplica��o fechou a conex�o com o servi�o remoto.';
  end;

{ Constantes relacionadas � ocorr�ncia de erros de conex�o com o servi�o remoto.}
  TConnectionError = class
    const
      ConnectionFailure   = 'A conex�o com o servi�o remoto n�o pode ser iniciada.'; //General message
      InvalidUrl        = 'O endere�o remoto � inv�lido!';
      NoServiceResponse = 'O servi�o remoto n�o respondeu a uma requisi��o feita.';
      StatusBadRequest  = 'Bad request';
      HttpStatus        = 'Ocorreu uma falha na comunica��o com o servi�o remoto. ' +
                          'C�digo de erro: %d. Mensagem: %s';
  end;

implementation

end.
