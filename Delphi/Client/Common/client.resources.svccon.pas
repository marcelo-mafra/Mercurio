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
  end;

implementation

end.
