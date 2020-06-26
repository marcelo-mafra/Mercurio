unit client.classes.chatserviceinfo;

interface

uses
  System.SysUtils, System.Classes, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent, Winapi.Windows, System.NetEncoding, classes.exceptions,
  client.interfaces.service, client.classes.json, client.resources.svcconsts,
  client.classes.nethttp, client.resources.httpstatus;

type
   {Classe que representa o conjunto de informações sobre o serviço de chat.}
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
var
 NetHTTPObj: TNetHTTPService;
 IResponse: IHTTPResponse;
begin
 InfoListObj := TStringList.Create;

 NetHTTPObj := TNetHTTPService.Create;

 try
   IResponse := NetHTTPObj.Execute(TChatServiceConst.ServiceHost, nil);

   if (IResponse <> nil) and (IResponse.StatusCode = THTTPStatus.StatusOK) then
    begin
      InfoListObj.AddPair('ServiceHost', TNetJsonUtils.FindValue(IResponse.ContentAsString, 'logradouro'));
      InfoListObj.AddPair('ServiceName', TNetJsonUtils.FindValue(IResponse.ContentAsString, 'bairro'));
    end;

 finally
  if Assigned(NetHTTPObj) then FreeAndNil(NetHTTPObj);
 end;
end;

destructor TChatServiceInfo.Destroy;
begin
  FreeAndNil(InfoListObj);
  inherited;
end;

function TChatServiceInfo.GetServiceHost: string;
begin
 Result :=  InfoListObj.Values['ServiceHost'];
end;

function TChatServiceInfo.GetServiceName: string;
begin
 Result :=  InfoListObj.Values['ServiceName'];
end;

procedure TChatServiceInfo.GetServiceInfo(List: TStringList);
var
 NetHTTPObj: TNetHTTPService;
 IResponse: IHTTPResponse;
begin
 NetHTTPObj := TNetHTTPService.Create;

 try
   IResponse := NetHTTPObj.Execute(TChatServiceConst.ServiceHost, nil);

   if (IResponse <> nil) and (IResponse.StatusCode = THTTPStatus.StatusOK) then
    begin
      InfoListObj.AddPair('ServiceHost', TNetJsonUtils.FindValue(IResponse.ContentAsString, 'logradouro'));
      InfoListObj.AddPair('ServiceName', TNetJsonUtils.FindValue(IResponse.ContentAsString, 'bairro'));
    end;

   List.Clear;
   List.CommaText := InfoListObj.CommaText;

 finally
  if Assigned(NetHTTPObj) then FreeAndNil(NetHTTPObj);
 end;

end;

end.
