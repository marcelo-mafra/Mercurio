unit client.classes.svccon;

interface

uses
  System.SysUtils, System.Classes, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent, Winapi.Windows, System.NetEncoding, classes.exceptions,
  client.interfaces.security, client.interfaces.service, client.resources.svcconsts,
  client.resources.svccon, client.classes.security, client.resources.httpstatus;

 type
   {Classe que encapsula as funcionalidades de conexão com o serviço remoto de chat.}
   TChatConnection = class(TInterfacedObject, IChatService)
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
       function ConnectService: boolean;
       function DisconnectService: boolean;

       property Connected: boolean read GetConnected;
       property Security: ISecurityService read GetSecurityService;

       property ServiceHost: string read FServiceHost;
       property ServiceName: string read FServiceName;
   end;

implementation


{ TChatConnection }

function TChatConnection.ConnectService: boolean;
var
 IResponse: IHTTPResponse;
// vUTF8Data: TStringStream;
begin
 {O método "ConnectService" apenas dá um GET no serviço remoto, sob http e
  verifica se o serviço responde e retorna dados como esperado. Não há conexão
  persistente com o serviço remoto.}
 Result := False;
 FSecurityObj := TSecurityService.Create;
 FServiceObj := TNetHTTPClient.Create(nil);
 self.LoadServiceParams;

// vUTF8Data := TStringStream.Create('', TEncoding.GetEncoding(TChatServiceConst.AcceptEncoding.ToInteger));

 try
  IResponse := FServiceObj.Get(self.ServiceHost, nil {vUTF8Data});
  Result := (IResponse <> nil) and (IResponse.StatusCode = THTTPStatus.StatusOK);

  if Result then //Serviço respondeu corretamente.
   begin
     outputdebugstring(PWideChar(IResponse.ContentAsString));
     outputdebugstring(PWideChar(IResponse.StatusText));
     {outputdebugstring(PWideChar(TNetEncoding.UrlDecode(vUTF8Data.DataString)));}
   end
  else //Serviço não respondeu ou respondeu sinalizando alguma falha.
   begin
    //Alguma falha impediu que houvesse um response do serviço remoto.
    if IResponse <> nil then
     raise ENoServiceResponse.Create(TServiceConnectionConst.NoServiceResponse)
    else //HTTPStatus <> 200
     begin
      case IResponse.StatusCode of //Respostas tratadas de forma específica.
        THTTPStatus.StatusBadRequest:
          begin
           raise EHTTPBadRequest.Create(TServiceConnectionConst.StatusBadRequest);
          end;
      end;
     end;
   end;

 except
   on E: ENoServiceResponse do //Não houve resposta do serviço remoto.
    begin
      self.DestroyInnerObjs;
    end;
   on E: EHTTPBadRequest do //Serviço remoto respondeu com falha: Bad Request.
    begin
      self.DestroyInnerObjs;
    end
   else
    begin //Serviço remoto respondeu com falha: demais cenários.
      Result := (IResponse <> nil);
      self.DestroyInnerObjs;
    end;
 end;
end;

constructor TChatConnection.Create;
begin
 //Service host and name
 FServiceName := TChatServiceConst.ServiceName;
 FServiceHost := TChatServiceConst.ServiceHost;
end;

destructor TChatConnection.Destroy;
begin
  self.DestroyInnerObjs;
  inherited;
end;

procedure TChatConnection.DestroyInnerObjs;
begin
 if (Assigned(FSecurityObj)) and (Assigned(FServiceObj)) then
  begin
    FreeAndNil(FSecurityObj);
    FreeAndNil(FServiceObj);
  end;
end;

function TChatConnection.DisconnectService: boolean;
begin
 self.DestroyInnerObjs;
 Result := True;
end;

function TChatConnection.GetConnected: boolean;
begin
 Result := Security <> nil;
end;

function TChatConnection.GetSecurityService: ISecurityService;
begin
 Result :=  FSecurityObj as ISecurityService;
end;

procedure TChatConnection.LoadServiceParams;
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
