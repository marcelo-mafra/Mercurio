unit client.resources.connection;

interface

uses
  System.SysUtils;

type
{ Constantes relacionadas a conexão com o serviço remoto.}
  TConnectionSucess = class
    const
      ConnectionSucess    = 'A conexão com o serviço remoto foi iniciada com sucesso.';
      DisconnectionSucess = 'A aplicação fechou a conexão com o serviço remoto.';
  end;

{ Constantes relacionadas à ocorrência de erros de conexão com o serviço remoto.}
  TConnectionError = class
    const
      ConnectionFailure   = 'A conexão com o serviço remoto não pode ser iniciada.'; //General message
      InvalidUrl        = 'O endereço remoto é inválido!';
      NoServiceResponse = 'O serviço remoto não respondeu a uma requisição feita.';
      StatusBadRequest  = 'Bad request';
      HttpStatus        = 'Ocorreu uma falha na comunicação com o serviço remoto. ' +
                          'Código de erro: %d. Mensagem: %s';
  end;

implementation

end.
