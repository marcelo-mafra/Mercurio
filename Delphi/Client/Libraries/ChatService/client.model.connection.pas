unit client.model.connection;

interface

uses
  System.SysUtils, System.Classes, System.Net.HttpClient, Winapi.Windows,
  System.NetEncoding, classes.exceptions, client.classes.nethttp,
  client.interfaces.security, client.interfaces.connection, client.resources.svcconsts,
  client.resources.svccon, client.classes.security, client.resources.httpstatus,
  client.model.serviceinfo, client.resources.consts, client.interfaces.baseclasses ;

 type
   TOnConnectServiceEvent = procedure (Sender: TObject) of object;
   TOnConnectServiceErrorEvent = procedure (Sender: TObject) of object;
   TOnDisconnectServiceEvent = procedure (Sender: TObject) of object;

   {Classe que encapsula as funcionalidades de conexão com o serviço remoto de chat.}
   TServiceConnection = class(TMercurioClass, IServiceConnection)
     private
       FOnConnectService: TOnConnectServiceEvent;
       FOnConnectServiceError: TOnConnectServiceErrorEvent;
       FOnDisconnectService: TOnDisconnectServiceEvent;

       FServiceHost, FServiceName: string;
       FConnected: boolean;

       function GetConnected: boolean;
       procedure SetConnected(const Value: boolean);
       function GetSecurityService: ISecurityService;
       function GetServiceInfo: IServiceInfo;
       //Eventos
       procedure DoOnConnectService(Sender: TObject);
       procedure DoOnConnectServiceError(Sender: TObject);
       procedure DoOnDisconnectService(Sender: TObject);


     public
       constructor Create;
       destructor Destroy; override;

       property OnConnectService: TOnConnectServiceEvent read FOnConnectService write FOnConnectService;
       property OnConnectServiceError: TOnConnectServiceErrorEvent read FOnConnectServiceError write FOnConnectServiceError;
       property OnDisconnectService: TOnDisconnectServiceEvent read FOnDisconnectService write FOnDisconnectService;

       //IServiceConnection
       function ConnectService: boolean;
       function DisconnectService: boolean;

       property Connected: boolean read GetConnected write SetConnected ;
       property Security: ISecurityService read GetSecurityService;
       property ServiceHost: string read FServiceHost;
       property ServiceName: string read FServiceName;

       property ServiceInfo: IServiceInfo read GetServiceInfo;

   end;

implementation


{ TServiceConnection }

function TServiceConnection.ConnectService: boolean;
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

  if Result then  //Dispara o evento de OnConnect
    if Assigned(FOnConnectService) then FOnConnectService(self)
  else //Dispara o evento OnConnectError
    if Assigned(FOnConnectServiceError) then FOnConnectServiceError(self);

  {IResponse := self.Execute(self.ServiceHost, vUTF8Data);
  outputdebugstring(PWideChar(TNetEncoding.UrlDecode(vUTF8Data.DataString)));}
 finally
  //if Assigned(vUTF8Data) then FreeAndNil(vUTF8Data);
  if Assigned(NetHTTPObj) then FreeAndNil(NetHTTPObj);
 end;
end;

constructor TServiceConnection.Create;
begin
 inherited Create;
 //Service host and name
 FServiceName := TChatServiceLabels.ServiceName;
 FServiceHost := TChatServiceLabels.ServiceHost;

 //Eventos
 FOnConnectService := DoOnConnectService;
 FOnConnectServiceError := DoOnConnectServiceError;
 FOnDisconnectService := DoOnDisconnectService;
end;

destructor TServiceConnection.Destroy;
begin
  FOnConnectService := nil;
  FOnConnectServiceError := nil;
  FOnDisconnectService := nil;
  inherited;
end;

function TServiceConnection.DisconnectService: boolean;
begin
 Result := True;
 if Assigned(FOnDisconnectService) then FOnDisconnectService(Self);
end;

procedure TServiceConnection.DoOnConnectService(Sender: TObject);
begin
//Implementa o evento TChatService.OnConnectService
 MercurioLogs.RegisterInfo(TSecurityConst.ConnectionSucess);
end;

procedure TServiceConnection.DoOnConnectServiceError(Sender: TObject);
begin
 //Implementa o evento TChatService.OnConnectServiceError
 MercurioLogs.RegisterInfo(TSecurityConst.ConnectionFailure);
end;

procedure TServiceConnection.DoOnDisconnectService(Sender: TObject);
begin
//Implementa o evento TChatService.OnDisconnectService
 MercurioLogs.RegisterInfo(TSecurityConst.DisconnectionSucess);
end;

function TServiceConnection.GetServiceInfo: IServiceInfo;
begin
 Result := TChatServiceInfo.Create as IServiceInfo;
end;

procedure TServiceConnection.SetConnected(const Value: boolean);
begin
 FConnected := value;
end;

function TServiceConnection.GetConnected: boolean;
begin
 Result := FConnected;
end;

function TServiceConnection.GetSecurityService: ISecurityService;
begin
 Result := TSecurityService.Create as ISecurityService;
end;



end.
