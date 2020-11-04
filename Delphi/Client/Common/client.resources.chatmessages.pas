unit client.resources.chatmessages;

interface

uses
  System.SysUtils;

type

  TChatMessages = class
    const
      MessageDataInvalid = 'Não é possível identificar uma mensagem de chat a partir ' +
        'dos dados recebidos!';
      InvalidObjectList  = 'A lista de objetos passada para uma operação é ' +
        'inválida ou desconhecida!';
  end;



implementation

end.
