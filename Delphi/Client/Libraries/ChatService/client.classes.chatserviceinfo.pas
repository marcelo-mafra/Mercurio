unit client.classes.chatserviceinfo;

interface

uses
  System.SysUtils, System.Classes, classes.exceptions, client.interfaces.service,
  client.resources.svcconsts, client.serverintf.serviceinfo, client.resources.consts,
  client.interfaces.baseclasses;

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
 inherited;
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
 IService: IMercurioServiceInfo;
 ServiceInfoObj: TServiceInfo;
begin
 IService := GetIMercurioServiceInfo();

 try
   ServiceInfoObj := IService.ServiceInfo;

   if (IService <> nil) and (ServiceInfoObj <> nil) then
    begin
      MercurioLogs.RegisterRemoteCallSucess(TServiceInfoConst.CallServiceInfoSucess, ServiceInfoObj.Host);

      InfoListObj.AddPair(TChatServiceLabels.ServiceHost, ServiceInfoObj.Host);
      InfoListObj.AddPair(TChatServiceLabels.ServiceName, ServiceInfoObj.ServiceName);
      InfoListObj.AddPair(TChatServiceLabels.ServiceTime, DateTimeToStr(ServiceInfoObj.ServerTime));
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
