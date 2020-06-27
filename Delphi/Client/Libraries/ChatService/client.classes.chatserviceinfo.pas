unit client.classes.chatserviceinfo;

interface

uses
  System.SysUtils, System.Classes, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent, Winapi.Windows, System.NetEncoding, classes.exceptions,
  client.interfaces.service, client.classes.json, client.resources.svcconsts,
  client.classes.nethttp, client.resources.httpstatus,
  client.chatservice.serverintf;

type
   {Classe que representa o conjunto de informa��es sobre o servi�o de chat.}
   TChatServiceInfo = class(TInterfacedObject, IChatServiceInfo)
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
begin
 IChatService := GetIMercurioChatServer();

 try
   JsonStr := IChatService.ServiceInfo;

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
    end;
 end;

end;

end.
