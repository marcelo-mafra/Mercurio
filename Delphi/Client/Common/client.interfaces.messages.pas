unit client.interfaces.messages;

interface
{Cont�m interfaces que abstraem entidades relacionadas �s mensagens de chat e
 usu�rios que enviaram as mensagens.}
uses
 client.interfaces.common, client.interfaces.baseclasses;

type

 //Abstrai o usu�rio que enviou uma mensagem.
 ISenderUser = interface(IChatInterface)
   ['{8E4F6C9A-AA2A-4778-B4BD-AAD72BF60DF0}']
 end;

 //Abstrai uma mensagem espec�fica do chat.
 IChatMessage = interface(IChatInterface)
   ['{36B6B4C7-781A-4118-A2E4-76144DE8C426}']
   function GetContentText: string;
   function GetMessageId: MsgIdentifier;
   function GetSenderUser: ISenderUser;

   property ContentText: string read GetContentText;
   property MessageId: MsgIdentifier read GetMessageId;
   property SenderUser: ISenderUser read GetSenderUser;
 end;

 //Abstrai uma cole��o de mensagens enviadas no chat.
 IChatMessages = interface(IChatInterface)
   ['{B1352A65-AFE2-4C05-ABD2-644D144EF4C3}']

   function GetChatMessage: IChatMessage;
   function GetCount: integer;

   function Delete(MessageId: MsgIdentifier): boolean;

   property ChatMessage: IChatMessage read GetChatMessage;
   property Count: integer read GetCount;
 end;

implementation

end.
