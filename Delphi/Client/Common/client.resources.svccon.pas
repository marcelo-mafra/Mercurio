unit client.resources.svccon;

interface

uses
  System.SysUtils;

type
  TServiceConnectionConst = class
    const
      InvalidUrl        = 'O endere�o remoto � inv�lido!';
      NoServiceResponse = 'O servidor remoto n�o respondeu.';
      StatusBadRequest  = 'Bad request';
  end;

implementation

end.
