unit client.resources.consts;

interface

uses
  System.SysUtils;

type
  TSecurityConst = class
    const
      AuthenticateFailure = 'O serviço remoto não reconheceu as suas credenciais.';
      AuthenticateSucess  = 'O serviço remoto fez com sucesso a autenticação do usuário.';
      ConnectionSucess    = 'A conexão com o serviço remoto foi iniciada com sucesso.';
      ConnectionFailure   = 'A conexão com o serviço remoto não pode ser iniciada.';
      DisconnectionSucess = 'A aplicação fechou a conexão com o serviço remoto.';

  end;

  TChatMessagesConst = class
    const
      MessageDataInvalid = 'Não é possível identificar uma mensagem de chat a partir ' +
        'dos dados recebidos!';
      CallRemoteMethodSucess = 'A chamada de um procedimento remoto foi feita com sucesso.';
  end;

implementation

end.
