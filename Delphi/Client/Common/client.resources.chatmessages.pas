unit client.resources.chatmessages;

interface

uses
  System.SysUtils;

type

  TChatMessages = class
    const
      MessageDataInvalid = 'N�o � poss�vel identificar uma mensagem de chat a partir ' +
        'dos dados recebidos!';
      InvalidObjectList  = 'A lista de objetos passada para uma opera��o � ' +
        'inv�lida ou desconhecida!';
  end;



implementation

end.
