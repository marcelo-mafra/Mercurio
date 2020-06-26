unit client.resources.svccon;

interface

uses
  System.SysUtils;

type
  TServiceConnectionConst = class
    const
      InvalidUrl        = 'O endereço remoto é inválido!';
      NoServiceResponse = 'O servidor remoto não respondeu.';
      StatusBadRequest  = 'Bad request';
  end;

implementation

end.
