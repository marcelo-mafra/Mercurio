unit client.classes.chatservice;

interface

uses
  System.SysUtils, System.Classes, System.Net.HttpClient, Winapi.Windows,
  System.NetEncoding, classes.exceptions,
  client.interfaces.security, client.interfaces.service, client.resources.svcconsts,
  client.resources.svccon, client.classes.security, client.resources.httpstatus,
  client.classes.chatserviceinfo, client.classes.nethttp;

 type
   {Classe que encapsula as funcionalidades de conexão com o serviço remoto de chat.}
   TChatService = class(TInterfacedObject, IChatService)
     private

       FServiceHost, FServiceName: string;

       function GetSecurityService: ISecurityService;
       function GetChatServiceInfo: IChatServiceInfo;

     public
       constructor Create;
       destructor Destroy; override;

       //IChatService
       function ConnectService: boolean;
       function DisconnectService: boolean;

       property Security: ISecurityService read GetSecurityService;
       property ServiceHost: string read FServiceHost;
       property ServiceName: string read FServiceName;

       property ServiceInfo: IChatServiceInfo read GetChatServiceInfo;
   end;

implementation


{ TChatService }

function TChatService.ConnectService: boolean;
var
 NetHTTPObj: TNetHTTPService;
 IResponse: IHTTPResponse;
// vUTF8Data: TStringStream;
begin
 {O método "ConnectService" apenas dá um GET no serviço remoto, sob http e
  verifica se o serviço responde e retorna dados como esperado. Não há conexão
  persistente com o serviço remoto.}
 //vUTF8Data := TStringStream.Create('', TEncoding.GetEncoding(TChatServiceConst.AcceptEncoding.ToInteger));
 NetHTTPObj := TNetHTTPService.Create;

 try
  IResponse := NetHTTPObj.Execute(TChatServiceConst.ServiceHost, nil);
  Result := (IResponse <> nil) and (IResponse.StatusCode = THTTPStatus.StatusOK)
            and not (IResponse.ContentAsString.IsEmpty);

  {IResponse := self.Execute(self.ServiceHost, vUTF8Data);
  outputdebugstring(PWideChar(TNetEncoding.UrlDecode(vUTF8Data.DataString)));}
 finally
  //if Assigned(vUTF8Data) then FreeAndNil(vUTF8Data);
  if Assigned(NetHTTPObj) then FreeAndNil(NetHTTPObj);
 end;
end;

constructor TChatService.Create;
begin
 //Service host and name
 FServiceName := TChatServiceLabels.ServiceName;
 FServiceHost := TChatServiceLabels.ServiceHost;
end;

destructor TChatService.Destroy;
begin

  inherited;
end;

function TChatService.DisconnectService: boolean;
begin
 Result := True;
end;

function TChatService.GetChatServiceInfo: IChatServiceInfo;
begin
 Result := TChatServiceInfo.Create as IChatServiceInfo;
end;

function TChatService.GetSecurityService: ISecurityService;
begin
 Result := TSecurityService.Create as ISecurityService;
end;



end.
