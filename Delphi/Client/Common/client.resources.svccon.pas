unit client.resources.svccon;

interface

uses
  System.SysUtils;

type
  TServiceConnectionConst = class
    const
      InvalidUrl        = 'O endereço remoto é inválido!';
      NoServiceResponse = 'O serviço remoto não respondeu a uma requisição feita.';
      StatusBadRequest  = 'Bad request';
      HttpStatus        = 'Ocorreu uma falha na comunicação com o serviço remoto. ' +
                          'Código de erro: %d. Mensagem: %s';
  end;

implementation

end.
