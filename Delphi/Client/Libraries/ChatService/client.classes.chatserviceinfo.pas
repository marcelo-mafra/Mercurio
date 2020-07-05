unit client.classes.chatserviceinfo;

interface

uses
  System.SysUtils, System.Classes, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent, Winapi.Windows, System.NetEncoding, classes.exceptions,
  client.interfaces.service, client.classes.json, client.resources.svcconsts,
  client.classes.nethttp, client.resources.httpstatus, client.serverintf.chatservice,
  client.resources.consts, client.interfaces.baseclasses;

type
   {Classe que representa o conjunto de informações sobre o serviço de chat.}
   TChatServiceInfo = class(TMercurioClass, IChatServiceInfo)
     private
       InfoListObj: TStringList;
       function GetServiceHost: string;
       function GetServiceName: string;

     public
       constructor Create;
       destructor Destroy; override;

       //IChatServiceInfo
       procedure GetServiceInfo(List: TStringList);

       property ServiceHost: string read GetServiceHost;
       property ServiceName: string read GetServiceName;
   end;

implementation

{ TChatServiceInfo }

constructor TChatServiceInfo.Create;
begin
 InfoListObj := TStringList.Create;
end;

destructor TChatServiceInfo.Destroy;
begin
  FreeAndNil(InfoListObj);
  inherited;
end;

function TChatServiceInfo.GetServiceHost: string;
begin
 if InfoListObj.Count = 0 then
  self.GetServiceInfo(nil);

 Result :=  InfoListObj.Values['ServiceHost'];
end;

function TChatServiceInfo.GetServiceName: string;
begin
 if InfoListObj.Count = 0 then
  self.GetServiceInfo(nil);

 Result :=  InfoListObj.Values['ServiceName'];
end;

procedure TChatServiceInfo.GetServiceInfo(List: TStringList);
var
 IChatService: IMercurioChatServer;
 JsonStr: UnicodeString;
 MessageObj: client.serverintf.chatservice.TChatMessage;
begin
 IChatService := GetIMercurioChatServer();

 try
   JsonStr := IChatService.ServiceInfo;
   MercurioLogs.RegisterRemoteCallSucess(TServiceInfoConst.CallServiceInfoSucess, JsonStr);

   MessageObj := client.serverintf.chatservice.TChatMessage.Create;
   MessageObj.ContentText := 'essa é a minha mensagem';
   MessageObj.SenderUser := 'Marcelo';
   MessageObj.MessageId := Random;
   MessageObj.StatusMsg := TMessageStatus.msNew;

    MessageObj := IChatService.NewChatMessage(MessageObj);

   if (IChatService <> nil) and not (JsonStr.IsEmpty) then
    begin
      InfoListObj.AddPair(TChatServiceLabels.ServiceHost, TNetJsonUtils.FindValue(JsonStr, 'ServerHost'));
      InfoListObj.AddPair(TChatServiceLabels.ServiceName, TNetJsonUtils.FindValue(JsonStr, 'ServerName'));
      InfoListObj.AddPair(TChatServiceLabels.ServiceTime, TNetJsonUtils.FindValue(JsonStr, 'ServerTime'));
    end;

  finally
   if List <> nil then
    begin
     List.Clear;
     List.CommaText := InfoListObj.CommaText;
     if Assigned(MessageObj) then FreeAndNil(MessageObj);

    end;
 end;

end;

end.
