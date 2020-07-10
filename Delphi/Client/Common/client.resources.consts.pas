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
      CallRemoteMethodError = 'A chamada de um procedimento remoto falhou.';
  end;

  TServiceInfoConst = class
    const
      CallServiceInfoSucess = 'A chamada do m�todo remoto "ServiceInfo" ' +
        'foi executada com sucesso.';
      CallNServiceInfoError = 'A chamada do m�todo remoto "ServiceInfo" falhou.';
  end;

  TContatosConst = class
    const
      CallNewContatoSucess = 'A chamada do m�todo remoto "NewContato" ' +
        'foi executada com sucesso.';
      CallNewContatoError = 'A chamada do m�todo remoto "NewContato" falhou.';
      CallExcluirContatoSucess = 'A chamada do m�todo remoto "ExcluirContato" ' +
        'foi executada com sucesso.';
      CallExcluirContatoError = 'A chamada do m�todo remoto "ExcluirContato" falhou.';
      CallGetContatosSucess = 'A chamada do m�todo remoto "GetContatos" ' +
        'foi executada com sucesso.';
      CallGetContatosError = 'A chamada do m�todo remoto "GetContatos" falhou.';
      VariantCastError     = 'A convers�o de um tipo de dados obtido do servi�o remoto ' +
        'falhou e a leitura dos dados obtidos foi encerrada.';
  end;

  TDialogsConst = class
    const
      ConfDelContact = 'Confirma a exclus�o do contato selecionado?';

  end;



implementation

end.
