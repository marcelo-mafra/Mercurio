unit client.model.connection;

interface

uses
  System.SysUtils, System.Classes, System.Net.HttpClient, Winapi.Windows,
  System.NetEncoding, classes.exceptions, client.classes.nethttp,
  client.interfaces.security, client.interfaces.connection, client.resources.svcconsts,
  client.resources.svccon, client.classes.security, client.resources.httpstatus,
  client.model.serviceinfo, client.resources.consts, client.interfaces.baseclasses ;

 type
   {Classe que encapsula as funcionalidades de conexão com o serviço remoto de chat.}
   TServiceConnection = class(TMercurioClass, IServiceConnection)
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
       constructor Create(OnConnectEvent: TOnConnectEvent; OnConnectErrorEvent:
          TOnConnectErrorEvent; OnDisconnectEvent: TOnDisconnectEvent);
       destructor Destroy; override;

       property OnConnect: TOnConnectEvent read FOnConnect write FOnConnect;
       property OnConnectError: TOnConnectErrorEvent read FOnConnectError write FOnConnectError;
       property OnDisconnect: TOnDisconnectEvent read FOnDisconnect write FOnDisconnect;

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
begin
 {O método "ConnectService" apenas dá um GET no serviço remoto, sob http e
  verifica se o serviço responde e retorna dados como esperado. Não há conexão
  persistente com o serviço remoto.}
 NetHTTPObj := TNetHTTPService.Create;

 try
  IResponse := NetHTTPObj.Execute(TChatServiceConst.ServiceHost, nil);
  Result := (IResponse <> nil) and (IResponse.StatusCode = THTTPStatus.StatusOK);

  if Result then
   begin //Dispara o evento de OnConnect
    if Assigned(FOnConnect) then FOnConnect(self);
   end
  else //Dispara o evento OnConnectError
    raise Exception.Create('');

  //if Assigned(vUTF8Data) then FreeAndNil(vUTF8Data);
  if Assigned(NetHTTPObj) then FreeAndNil(NetHTTPObj);

 except
  on E: Exception do
    if Assigned(FOnConnectError) then FOnConnectError(self, E);
 end;
end;

constructor TServiceConnection.Create(OnConnectEvent: TOnConnectEvent;
    OnConnectErrorEvent: TOnConnectErrorEvent; OnDisconnectEvent: TOnDisconnectEvent);
begin
 inherited Create;
 //Service host and name
 FServiceName := TChatServiceLabels.ServiceName;
 FServiceHost := TChatServiceLabels.ServiceHost;

 //Eventos
 FOnConnect := OnConnectEvent;
 FOnConnectError := OnConnectErrorEvent;
 FOnDisconnect := OnDisconnectEvent;
end;

destructor TServiceConnection.Destroy;
begin
  FOnConnect := nil;
  FOnConnectError := nil;
  FOnDisconnect := nil;
  inherited;
end;

function TServiceConnection.DisconnectService: boolean;
begin
 Result := True;
 if Assigned(FOnDisconnect) then FOnDisconnect(Self);
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
