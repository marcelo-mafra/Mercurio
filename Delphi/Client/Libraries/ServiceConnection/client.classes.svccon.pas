unit client.classes.svccon;

interface

uses
  System.SysUtils, System.Classes, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent, Winapi.Windows, System.NetEncoding,
  client.interfaces.security, client.interfaces.service, client.resources.svcconsts,
  client.classes.security, client.resources.httpstatus;

 type
   {Classe que encapsula as funcionalidades de conexão com o serviço remoto.}
   TChatService = class(TInterfacedObject, IChatService)
     strict private
       procedure DestroyInnerObjs; inline;

     private
       FServiceObj: TNetHTTPClient;
       FSecurityObj: TSecurityService;
       FServiceHost, FServiceName: string;

       function GetConnected: boolean;
       function GetSecurityService: ISecurityService;
       procedure LoadServiceParams;

     public
       constructor Create;
       destructor Destroy; override;

       //IChatService
       function  ConnectService: boolean;
       procedure DisconnectService;

       property Connected: boolean read GetConnected;
       property Security: ISecurityService read GetSecurityService;

       property ServiceHost: string read FServiceHost;
       property ServiceName: string read FServiceName;
   end;

implementation


{ TChatService }

function TChatService.ConnectService: boolean;
var
 IResponse: IHTTPResponse;
 vUTF8Data: TStringStream;
begin
 {O método "ConnectService" apenas dá um GET no serviço remoto, sob http e
  verifica se o serviço responde e retorna dados como esperado. Não há conexão
  persistente com o serviço remoto.}
 FSecurityObj := TSecurityService.Create;
 FServiceObj := TNetHTTPClient.Create(nil);
 self.LoadServiceParams;

 vUTF8Data := TStringStream.Create('', TEncoding.GetEncoding(TChatServiceConst.AcceptEncoding.ToInteger));

 try
  IResponse := FServiceObj.Get(TChatServiceConst.ServiceHost, vUTF8Data);
  Result := (IResponse <> nil) and (IResponse.StatusCode = THTTPStatus.StatusOK);
  if Result then
   begin
     outputdebugstring(PWideChar(THTTPStatus.ToText(THTTPStatus.StatusOK) + ' | ' +
        IResponse.ContentAsString));
     {outputdebugstring(PWideChar(THTTPStatus.ToText(THTTPStatus.StatusOK) + ' | ' +
         TNetEncoding.UrlDecode(vUTF8Data.DataString)));}
   end;

 except
   on E: Exception do
    begin
      Result := (IResponse <> nil);
      self.DestroyInnerObjs;
    end;
 end;
end;

constructor TChatService.Create;
begin
  FServiceName := TChatServiceConst.ServiceName;
  FServiceHost := TChatServiceConst.ServiceHost;
end;

destructor TChatService.Destroy;
begin
  self.DestroyInnerObjs;
  inherited;
end;

procedure TChatService.DestroyInnerObjs;
begin
 if (Assigned(FSecurityObj)) and (Assigned(FServiceObj)) then
  begin
    FreeAndNil(FSecurityObj);
    FreeAndNil(FServiceObj);
  end;
end;

procedure TChatService.DisconnectService;
begin
 self.DestroyInnerObjs;
end;

function TChatService.GetConnected: boolean;
begin
 Result := Security <> nil;
end;

function TChatService.GetSecurityService: ISecurityService;
begin
 Result :=  FSecurityObj as ISecurityService;
end;

procedure TChatService.LoadServiceParams;
begin
 with FServiceObj do
  begin
    AcceptCharSet := TChatServiceConst.ServiceCharSet;
    AcceptEncoding := TChatServiceConst.AcceptEncoding;
    AcceptLanguage := TChatServiceConst.AcceptLanguage;
    ContentType := TChatServiceConst.ContentType;
    UserAgent := TChatServiceConst.UserAgent;

    //Timeouts
    ConnectionTimeout := TChatServiceConst.ConnectionTimeout;
    ResponseTimeout := TChatServiceConst.ResponseTimeout;
  end;
end;

end.
