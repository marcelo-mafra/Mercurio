unit client.resources.security;

interface

uses
  System.SysUtils;

  type
    TSecurityConst = class
      const
        AuthenticateFailure = 'O servi�o remoto n�o reconheceu as suas credenciais.';
        AuthenticateSucess  = 'O servi�o remoto fez com sucesso a autentica��o do usu�rio.';
    end;


implementation

end.
