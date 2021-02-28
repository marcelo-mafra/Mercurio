unit client.model.connection;

interface

uses
  System.SysUtils, System.Classes, System.Net.HttpClient, Winapi.Windows,
  System.NetEncoding, classes.exceptions, client.classes.nethttp,
  client.interfaces.security, client.interfaces.connection, client.resources.serviceparams,
  client.resources.servicelabels, client.classes.security, client.resources.httpstatus,
  client.model.serviceinfo, client.interfaces.baseclasses, classes.exceptions.connection,
  client.resources.connection, client.classes.session ;

 type
   {Classe que encapsula as funcionalidades de conexão com o serviço remoto de chat.}
   TServiceConnection = class(TMercurioClass, IServiceConnection)
     strict private
       //events implementation
        FSessionObj: TConnectionSession;
        procedure DoOnConnect(Sender: TObject);
        procedure DoOnConnectError(Sender: TObject; E: Exception);
        procedure DoOnDisconnect(Sender: TObject);

     private
       FOnConnect: TOnConnectEvent;
       FOnConnectError: TOnConnectErrorEvent;
       FOnDisconnect: TOnDisconnectEvent;
       FServiceHost, FServiceName: string;

       function GetConnected: boolean;
       function GetSecurityService: ISecurityService;
       function GetServiceInfo: IServiceInfo;

     protected
       //IServiceConnection
       function ConnectService(var SessionId: string): boolean;
       procedure DisconnectService;

     public
       constructor Create(const SessionObj: TConnectionSession); overload;
       constructor Create(const SessionObj: TConnectionSession; OnConnectEvent: TOnConnectEvent;
          OnConnectErrorEvent: TOnConnectErrorEvent;
          OnDisconnectEvent: TOnDisconnectEvent); overload;
       destructor Destroy; override;

       //IServiceConnection
       property Connected: boolean read GetConnected ;
       property Security: ISecurityService read GetSecurityService;
       property ServiceHost: string read FServiceHost;
       property ServiceName: string read FServiceName;
       property ServiceInfo: IServiceInfo read GetServiceInfo;

   end;

implementation


{ TServiceConnection }

function TServiceConnection.ConnectService(var SessionId: string): boolean;
const
 sUsuario = 'fake_user';
 sSenha   = 'fake_pass';
var
 NetHTTPObj: TNetHTTPService;
 IResponse: IHTTPResponse;
begin
 {O método "ConnectService" apenas dá um GET no serviço remoto, sob http e
  verifica se o serviço responde e retorna dados como esperado. Não há conexão
  persistente com o serviço remoto.}
 Result := False;
 NetHTTPObj := TNetHTTPService.Create;

 try
  IResponse := NetHTTPObj.Execute(TServiceParams.ServiceHost, nil);
  Result := (IResponse <> nil) and (IResponse.StatusCode = THTTPStatus.StatusOK);

  if Result then
   begin //Dispara o evento de OnConnect
    Result := self.Security.Authenticate(sUsuario, sSenha);
    if Result then
     begin
      self.Security.NewSessionId(string.Empty, SessionId);
      FSessionObj := TConnectionSession.Create(SessionId);
      if Assigned(FOnConnect) then FOnConnect(self);
     end
    else
      raise EAuthenticationError.Create;
   end
  else
    raise Exception.Create(string.Empty);

  if Assigned(NetHTTPObj) then FreeAndNil(NetHTTPObj);

 except
  on E: EAuthenticationError do
   begin //Dispara o evento OnConnectError
    if Assigned(FOnConnectError) then FOnConnectError(self, E);
   end;
  on E: Exception do
   begin //Dispara o evento OnConnectError
    if Assigned(FOnConnectError) then FOnConnectError(self, E);
   end;
 end;
end;

constructor TServiceConnection.Create(const SessionObj: TConnectionSession;
    OnConnectEvent: TOnConnectEvent; OnConnectErrorEvent: TOnConnectErrorEvent;
    OnDisconnectEvent: TOnDisconnectEvent);
begin
 self.Create(SessionObj);
 //Eventos
 FOnConnect := OnConnectEvent;
 FOnConnectError := OnConnectErrorEvent;
 FOnDisconnect := OnDisconnectEvent;
end;

constructor TServiceConnection.Create(const SessionObj: TConnectionSession);
begin
 inherited Create;
 FSessionObj := SessionObj;
 //Service host and name
 FServiceName := TServiceLabels.ServiceName;
 FServiceHost := TServiceLabels.ServiceHost;
 //Eventos
 if not Assigned(FOnConnect) then FOnConnect := DoOnConnect;
 if not Assigned(FOnConnectError) then FOnConnectError := DoOnConnectError;
 if not Assigned(FOnDisconnect) then FOnDisconnect := DoOnDisconnect;
end;

destructor TServiceConnection.Destroy;
begin
  FOnConnect := nil;
  FOnConnectError := nil;
  FOnDisconnect := nil;
  inherited;
end;

procedure TServiceConnection.DisconnectService;
begin
 if Assigned(FOnDisconnect) then FOnDisconnect(Self);
end;

procedure TServiceConnection.DoOnConnect(Sender: TObject);
begin
//Implementa o evento TServiceConnection.OnConnect
 MercurioLogs.RegisterInfo(TConnectionSucess.ConnectionSucess);
end;

procedure TServiceConnection.DoOnConnectError(Sender: TObject; E: Exception);
begin
 //Implementa o evento TServiceConnection.OnConnectError
 MercurioLogs.RegisterError(TConnectionError.ConnectionFailure, E.Message);
end;

procedure TServiceConnection.DoOnDisconnect(Sender: TObject);
begin
//Implementa o evento TServiceConnection.OnDisconnect
 MercurioLogs.RegisterInfo(TConnectionSucess.DisconnectionSucess);
end;

function TServiceConnection.GetServiceInfo: IServiceInfo;
begin
 Result := TChatServiceInfo.Create as IServiceInfo;
end;

function TServiceConnection.GetConnected: boolean;
begin
 Result := TMercurioClass(self).Connected;
end;

function TServiceConnection.GetSecurityService: ISecurityService;
begin
 Result := TSecurityService.Create as ISecurityService;
end;



end.
