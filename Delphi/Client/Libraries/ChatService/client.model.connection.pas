unit client.model.connection;

interface

uses
  System.SysUtils, System.Classes, System.Net.HttpClient, Winapi.Windows,
  System.NetEncoding, classes.exceptions, client.classes.nethttp,
  client.interfaces.security, client.interfaces.connection, client.resources.serviceparams,
  client.resources.servicelabels, client.classes.security, client.resources.httpstatus,
  client.model.serviceinfo, client.interfaces.baseclasses, classes.exceptions.connection,
  client.resources.connection ;

 type
   {Classe que encapsula as funcionalidades de conex�o com o servi�o remoto de chat.}
   TServiceConnection = class(TMercurioClass, IServiceConnection)
     strict private
       //events implementation
        procedure DoOnConnect(Sender: TObject);
        procedure DoOnConnectError(Sender: TObject; E: Exception);
        procedure DoOnDisconnect(Sender: TObject);

     private
       FOnConnect: TOnConnectEvent;
       FOnConnectError: TOnConnectErrorEvent;
       FOnDisconnect: TOnDisconnectEvent;
       FServiceHost, FServiceName: string;
       FConnected: boolean;

       function GetConnected: boolean;
       procedure SetConnected(const Value: boolean);
       function GetSecurityService: ISecurityService;
       function GetServiceInfo: IServiceInfo;

     public
       constructor Create; overload;
       constructor Create(OnConnectEvent: TOnConnectEvent; OnConnectErrorEvent:
          TOnConnectErrorEvent; OnDisconnectEvent: TOnDisconnectEvent); overload;
       destructor Destroy; override;

       //IServiceConnection
       function ConnectService: boolean;
       procedure DisconnectService;

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
begin
 {O m�todo "ConnectService" apenas d� um GET no servi�o remoto, sob http e
  verifica se o servi�o responde e retorna dados como esperado. N�o h� conex�o
  persistente com o servi�o remoto.}
 Result := False;
 NetHTTPObj := TNetHTTPService.Create;

 try
  IResponse := NetHTTPObj.Execute(TServiceParams.ServiceHost, nil);
  Result := (IResponse <> nil) and (IResponse.StatusCode = THTTPStatus.StatusOK);

  if Result then
   begin //Dispara o evento de OnConnect
    Result := self.Security.Authenticate('fake_user','fake_pass');
    if Result then
     begin
      if Assigned(FOnConnect) then FOnConnect(self);
     end
    else
      raise EAuthenticationError.Create;
   end
  else
    raise Exception.Create('');

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

constructor TServiceConnection.Create(OnConnectEvent: TOnConnectEvent;
    OnConnectErrorEvent: TOnConnectErrorEvent; OnDisconnectEvent: TOnDisconnectEvent);
begin
 self.Create();
 //Eventos
 FOnConnect := OnConnectEvent;
 FOnConnectError := OnConnectErrorEvent;
 FOnDisconnect := OnDisconnectEvent;
end;

constructor TServiceConnection.Create;
begin
 inherited Create;
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
 FConnected := False;
 if Assigned(FOnDisconnect) then FOnDisconnect(Self);
end;

procedure TServiceConnection.DoOnConnect(Sender: TObject);
begin
//Implementa o evento TServiceConnection.OnConnect
 FConnected := True;
 MercurioLogs.RegisterInfo(TConnectionSucess.ConnectionSucess);
end;

procedure TServiceConnection.DoOnConnectError(Sender: TObject; E: Exception);
begin
 //Implementa o evento TServiceConnection.OnConnectError
 FConnected := False;
 MercurioLogs.RegisterError(TConnectionError.ConnectionFailure, E.Message);
end;

procedure TServiceConnection.DoOnDisconnect(Sender: TObject);
begin
//Implementa o evento TServiceConnection.OnDisconnect
 FConnected := False;
 MercurioLogs.RegisterInfo(TConnectionSucess.DisconnectionSucess);
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
