unit client.resources.security;

interface

uses
  System.SysUtils;

  type
    TSecurityConst = class
      const
        AuthenticateFailure = 'O serviço remoto não reconheceu as suas credenciais.';
        AuthenticateSucess  = 'O serviço remoto fez com sucesso a autenticação do usuário.';
    end;


implementation

end.
