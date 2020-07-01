unit client.classes.chatservice;

interface

uses
  System.SysUtils, System.Classes, System.Net.HttpClient, Winapi.Windows,
  System.NetEncoding, classes.exceptions, client.classes.nethttp, FMX.Forms,
  client.interfaces.security, client.interfaces.service, client.resources.svcconsts,
  client.resources.svccon, client.classes.security, client.resources.httpstatus,
  client.classes.chatserviceinfo, client.interfaces.application, client.resources.consts ;

 type
   TOnConnectServiceEvent = procedure (Sender: TObject) of object;
   TOnConnectServiceErrorEvent = procedure (Sender: TObject) of object;
   TOnDisconnectServiceEvent = procedure (Sender: TObject) of object;

   {Classe que encapsula as funcionalidades de conexão com o serviço remoto de chat.}
   TChatService = class(TInterfacedObject, IChatService)
     private
       FOnConnectService: TOnConnectServiceEvent;
       FOnConnectServiceError: TOnConnectServiceErrorEvent;
       FOnDisconnectService: TOnDisconnectServiceEvent;

       FServiceHost, FServiceName: string;

       function GetSecurityService: ISecurityService;
       function GetChatServiceInfo: IChatServiceInfo;
       procedure DoOnConnectService(Sender: TObject);
       procedure DoOnConnectServiceError(Sender: TObject);
       procedure DoOnDisconnectService(Sender: TObject);


     public
       constructor Create;
       destructor Destroy; override;

       property OnConnectService: TOnConnectServiceEvent read FOnConnectService write FOnConnectService;
       property OnConnectServiceError: TOnConnectServiceErrorEvent read FOnConnectServiceError write FOnConnectServiceError;
       property OnDisconnectService: TOnDisconnectServiceEvent read FOnDisconnectService write FOnDisconnectService;

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

  if Result then
   begin //Dispara o evento de OnConnect
    if Assigned(FOnConnectService) then
      FOnConnectService(self);
   end
  else
   begin //Dispara o evento OnConnectError
    if Assigned(FOnConnectServiceError) then
      FOnConnectServiceError(self);
   end;


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

 //Eventos
 FOnConnectService := DoOnConnectService;
 FOnConnectServiceError := DoOnConnectServiceError;
 FOnDisconnectService := DoOnDisconnectService;
end;

destructor TChatService.Destroy;
begin
  FOnConnectService := nil;
  FOnConnectServiceError := nil;
  FOnDisconnectService := nil;
  inherited;
end;

function TChatService.DisconnectService: boolean;
begin
 Result := True;
 if Assigned(FOnDisconnectService) then
  FOnDisconnectService(Self);
end;

procedure TChatService.DoOnConnectService(Sender: TObject);
var
 IApplication: IChatApplication;
begin
//Implementa o evento TChatService.OnConnectService
   IApplication := Application.MainForm as IChatApplication;
   IApplication.LogsWriter.RegisterInfo(TSecurityConst.ConnectionSucess);
end;

procedure TChatService.DoOnConnectServiceError(Sender: TObject);
var
 IApplication: IChatApplication;
begin
 IApplication := Application.MainForm as IChatApplication;
 IApplication.LogsWriter.RegisterInfo(TSecurityConst.ConnectionFailure);
end;

procedure TChatService.DoOnDisconnectService(Sender: TObject);
var
 IApplication: IChatApplication;
begin
 IApplication := Application.MainForm as IChatApplication;
 IApplication.LogsWriter.RegisterInfo(TSecurityConst.DisconnectionSucess);
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
