unit client.classes.svccon;

interface

uses
  System.SysUtils, System.Classes, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent, Winapi.Windows, System.NetEncoding,
  client.interfaces.security, client.interfaces.service, client.resources.svcconsts,
  client.classes.security;

 type
   {Classe que encapsula as funcionalidades de conex�o com o servi�o remoto.}
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
       property SecuritySvc: ISecurityService read GetSecurityService;

       property ServiceHost: string read FServiceHost;
       property ServiceName: string read FServiceName;
   end;

implementation


{ TChatService }

function TChatService.ConnectService: boolean;
var
 IResponse: IHTTPResponse;
 vUTF8: TStringStream;
begin

 FSecurityObj := TSecurityService.Create;
 FServiceObj := TNetHTTPClient.Create(nil);
 self.LoadServiceParams;

 vUTF8 := TStringStream.Create('', TEncoding.GetEncoding(TChatServiceConst.AcceptEncoding.ToInteger));

 try
  IResponse := FServiceObj.Get(TChatServiceConst.ServiceHost, vUTF8);
  Result := (IResponse <> nil);

  outputdebugstring(PWideChar(IResponse.ContentAsString));
  outputdebugstring(PWideChar('utf8:' + TNetEncoding.URL.UrlDecode(vUTF8.DataString)));

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
 Result := SecuritySvc <> nil;
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
    UserAgent :=TChatServiceConst.UserAgent;

    //Timeouts
    ConnectionTimeout := TChatServiceConst.ConnectionTimeout;
    ResponseTimeout := TChatServiceConst.ResponseTimeout;
  end;
end;

end.
