unit client.resources.consts;

interface

uses
  System.SysUtils;

type
  TSecurityConst = class
    const
      AuthenticateFailure = 'O servi�o remoto n�o reconheceu as suas credenciais.';

  end;

  TChatMessagesConst = class
    const
      MessageDataInvalid = 'N�o � poss�vel identificar uma mensagem de chat a partir ' +
        'dos dados recebidos!';
  end;

implementation

end.
