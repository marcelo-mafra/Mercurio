unit client.resources.consts;

interface

uses
  System.SysUtils;

type
  TSecurityConst = class
    const
      AuthenticateFailure = 'O serviço remoto não reconheceu as suas credenciais.';

  end;

  TChatMessagesConst = class
    const
      MessageDataInvalid = 'Não é possível identificar uma mensagem de chat a partir ' +
        'dos dados recebidos!';
  end;

implementation

end.
