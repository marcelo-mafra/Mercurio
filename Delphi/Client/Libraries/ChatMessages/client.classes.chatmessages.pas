unit client.classes.chatmessages;

interface

 uses
   System.SysUtils, client.interfaces.common, client.interfaces.messages,
   classes.exceptions, client.resources.consts, System.Json;

 type
  TChatMessage = class(TInterfacedObject, IChatMessage)

   private
     FJsonData: TJsonObject;

     //IChatMessage
     function GetMessageId: MsgIdentifier;
     function GetSenderUser: ISenderUser;

   public
     constructor Create(const MessageData: string);
     destructor Destroy; override;

     //IChatMessage
     function Delete: boolean;

     property MessageId: MsgIdentifier read GetMessageId;
     property SenderUser: ISenderUser read GetSenderUser;

  end;

implementation

{ TChatMessage }

constructor TChatMessage.Create(const MessageData: string);
begin
 if MessageData.Empty = '' then
  raise EMercurioException.Create(TChatMessagesConst.MessageDataInvalid);
end;

destructor TChatMessage.Destroy;
begin

  inherited;
end;

function TChatMessage.Delete: boolean;
begin

end;

function TChatMessage.GetMessageId: MsgIdentifier;
begin

end;

function TChatMessage.GetSenderUser: ISenderUser;
begin
 Result := nil;
end;

end.
