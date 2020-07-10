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
      CallRemoteMethodError = 'A chamada de um procedimento remoto falhou.';
  end;

  TServiceInfoConst = class
    const
      CallServiceInfoSucess = 'A chamada do método remoto "ServiceInfo" ' +
        'foi executada com sucesso.';
      CallNServiceInfoError = 'A chamada do método remoto "ServiceInfo" falhou.';
  end;

  TContatosConst = class
    const
      CallNewContatoSucess = 'A chamada do método remoto "NewContato" ' +
        'foi executada com sucesso.';
      CallNewContatoError = 'A chamada do método remoto "NewContato" falhou.';
      CallExcluirContatoSucess = 'A chamada do método remoto "ExcluirContato" ' +
        'foi executada com sucesso.';
      CallExcluirContatoError = 'A chamada do método remoto "ExcluirContato" falhou.';
      CallGetContatosSucess = 'A chamada do método remoto "GetContatos" ' +
        'foi executada com sucesso.';
      CallGetContatosError = 'A chamada do método remoto "GetContatos" falhou.';
      VariantCastError     = 'A conversão de um tipo de dados obtido do serviço remoto ' +
        'falhou e a leitura dos dados obtidos foi encerrada.';
  end;

  TDialogsConst = class
    const
      ConfDelContact = 'Confirma a exclusão do contato selecionado?';

  end;



implementation

end.
