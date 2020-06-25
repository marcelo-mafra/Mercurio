unit client.classes.svccon;

interface

uses
  System.SysUtils, System.Classes, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent, Winapi.Windows, System.NetEncoding, classes.exceptions,
  client.interfaces.security, client.interfaces.service, client.resources.svcconsts,
  client.resources.svccon, client.classes.security, client.resources.httpstatus;

 type
   {Classe que encapsula as funcionalidades de conex�o com o servi�o remoto de chat.}
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
 {O m�todo "ConnectService" apenas d� um GET no servi�o remoto, sob http e
  verifica se o servi�o responde e retorna dados como esperado. N�o h� conex�o
  persistente com o servi�o remoto.}
 Result := False;
 FSecurityObj := TSecurityService.Create;
 FServiceObj := TNetHTTPClient.Create(nil);
 self.LoadServiceParams;

// vUTF8Data := TStringStream.Create('', TEncoding.GetEncoding(TChatServiceConst.AcceptEncoding.ToInteger));

 try
  IResponse := FServiceObj.Get(self.ServiceHost, nil {vUTF8Data});
  Result := (IResponse <> nil) and (IResponse.StatusCode = THTTPStatus.StatusOK);

  if Result then //Servi�o respondeu corretamente.
   begin
     outputdebugstring(PWideChar(IResponse.ContentAsString));
     outputdebugstring(PWideChar(IResponse.StatusText));
     {outputdebugstring(PWideChar(TNetEncoding.UrlDecode(vUTF8Data.DataString)));}
   end
  else //Servi�o n�o respondeu ou respondeu sinalizando alguma falha.
   begin
    //Alguma falha impediu que houvesse um response do servi�o remoto.
    if IResponse <> nil then
     raise ENoServiceResponse.Create(TServiceConnectionConst.NoServiceResponse)
    else //HTTPStatus <> 200
     begin
      case IResponse.StatusCode of //Respostas tratadas de forma espec�fica.
        THTTPStatus.StatusBadRequest:
          begin
           raise EHTTPBadRequest.Create(TServiceConnectionConst.StatusBadRequest);
          end;
      end;
     end;
   end;

 except
   on E: ENoServiceResponse do //N�o houve resposta do servi�o remoto.
    begin
      self.DestroyInnerObjs;
    end;
   on E: EHTTPBadRequest do //Servi�o remoto respondeu com falha: Bad Request.
    begin
      self.DestroyInnerObjs;
    end
   else
    begin //Servi�o remoto respondeu com falha: demais cen�rios.
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
