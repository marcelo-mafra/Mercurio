unit client.resources.consts;

interface

uses
  System.SysUtils;

type
  TSecurityConst = class
    const
      AuthenticateFailure = 'O servi�o remoto n�o reconheceu as suas credenciais.';
      AuthenticateSucess  = 'O servi�o remoto fez com sucesso a autentica��o do usu�rio.';
      ConnectionSucess    = 'A conex�o com o servi�o remoto foi iniciada com sucesso.';
      ConnectionFailure   = 'A conex�o com o servi�o remoto n�o pode ser iniciada.';
      DisconnectionSucess = 'A aplica��o fechou a conex�o com o servi�o remoto.';

  end;

  TChatMessagesConst = class
    const
      MessageDataInvalid = 'N�o � poss�vel identificar uma mensagem de chat a partir ' +
        'dos dados recebidos!';
      CallRemoteMethodSucess = 'A chamada de um procedimento remoto foi feita com sucesso.';
  end;

implementation

end.
