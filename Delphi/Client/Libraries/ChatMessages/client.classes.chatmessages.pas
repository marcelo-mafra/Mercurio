unit client.classes.chatmessages;

interface

 uses
   System.SysUtils, client.interfaces.common, client.interfaces.baseclasses,
   client.interfaces.messages, classes.exceptions, client.resources.consts,
   System.Json;

 type
  TChatMessage = class(TInterfacedObject, IChatMessage)
   private
     FJsonObj: TJsonObject;

     //IChatMessage
     function GetContentText: string;
     function GetMessageId: MsgIdentifier;
     function GetSenderUser: ISenderUser;

   public
     constructor Create(const MessageData: string);
     destructor Destroy; override;

     //IChatMessage
     property ContentText: string read GetContentText;
     property MessageId: MsgIdentifier read GetMessageId;
     property SenderUser: ISenderUser read GetSenderUser;

  end;

implementation

{ TChatMessage }

constructor TChatMessage.Create(const MessageData: string);
begin
 if MessageData.Empty = '' then
  raise EMercurioException.Create(TChatMessagesConst.MessageDataInvalid);

 try
   FJsonObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(MessageData), 0) as TJSONObject;

 except
  on E: Exception do //to-do: logs e tratar os tipos de falhas possíveis.
   begin
     if Assigned(FJsonObj) then
       FreeAndNil(FJsonObj);
   end;
 end;
end;

destructor TChatMessage.Destroy;
begin
  if Assigned(FJsonObj) then
   FreeAndNil(FJsonObj);
  inherited;
end;

function TChatMessage.GetContentText: string;
begin
 Result := '';
 if Assigned(FJsonObj) then
   Result := FJsonObj.Values['logradouro'].Value;
end;

function TChatMessage.GetMessageId: MsgIdentifier;
begin
 Result := 0;
 if Assigned(FJsonObj) then
   Result := FJsonObj.Values['MessageId'].Value.ToInt64;
end;

function TChatMessage.GetSenderUser: ISenderUser;
begin
 Result := nil;
end;


end.
