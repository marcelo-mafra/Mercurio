unit client.classes.nethttp;

interface

uses
  System.SysUtils, System.Classes, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent, Winapi.Windows, System.NetEncoding, classes.exceptions,
  client.resources.httpstatus, client.resources.svccon, client.resources.svcconsts,
  System.Json, client.classes.json, client.serverintf.soaputils;

 type
   {Classe que encapsula as a comunica��o http com o servi�o remoto de chat.}
   TNetHTTPService = class(TInterfacedObject)
     private
       procedure LoadServiceParams(ClientObj: TNetHTTPClient);

     public
       constructor Create;
       destructor Destroy; override;

       function Execute(const ServiceUrl: string; Stream: TStream): IHTTPResponse; overload;
       function Execute(const ServiceUrl: string): TJsonObject; overload;
   end;

implementation

{ TNetHTTPService }

constructor TNetHTTPService.Create;
begin
 inherited Create;
end;

destructor TNetHTTPService.Destroy;
begin

  inherited;
end;

function TNetHTTPService.Execute(const ServiceUrl: string): TJsonObject;
var
 HTTPClientObj: TNetHTTPClient;
 IResponse: IHTTPResponse;
begin
 {O m�todo "Execute" aciona um webm�todo do servi�o remoto.}
 if ServiceUrl.IsEmpty then
  raise EInvalidURL.Create(TServiceConnectionConst.InvalidUrl);

 HTTPClientObj :=  TNetHTTPClient.Create(nil);
 self.LoadServiceParams(HTTPClientObj);

 try
  IResponse := HTTPClientObj.Get(ServiceUrl);

  if (IResponse <> nil) and (IResponse.StatusCode <> THTTPStatus.StatusOK) then
   begin //Servi�o n�o respondeu ou respondeu sinalizando alguma falha.

      case IResponse.StatusCode of //Respostas tratadas de forma espec�fica: HTTPStatus <> 200
        THTTPStatus.StatusBadRequest:
          begin
           raise EHTTPBadRequest.Create(TServiceConnectionConst.StatusBadRequest);
          end;
      end;
   end
   else
    begin
     if Result = nil then //sem resposta do servi�o remoto.
      raise ENoServiceResponse.Create(TServiceConnectionConst.NoServiceResponse);
    end;

   Result := TNetJsonUtils.AsJsonObject(IResponse.ContentAsString);

   if Assigned(HTTPClientObj) then
    FreeAndNil(HTTPClientObj);

 except
   on E: ENoServiceResponse do //N�o houve resposta do servi�o remoto.
    begin
      if Assigned(HTTPClientObj) then
       FreeAndNil(HTTPClientObj);
    end;
   on E: EHTTPBadRequest do //Servi�o remoto respondeu com falha: Bad Request.
    begin
      if Assigned(HTTPClientObj) then
       FreeAndNil(HTTPClientObj);
    end
   else
    begin //Servi�o remoto respondeu com falha: demais cen�rios.
      if Assigned(HTTPClientObj) then
       FreeAndNil(HTTPClientObj);
    end;
 end;

end;

function TNetHTTPService.Execute(const ServiceUrl: string;
  Stream: TStream): IHTTPResponse;
var
 HTTPClientObj: TNetHTTPClient;
begin
 {O m�todo "Execute" aciona um webm�todo do servi�o remoto.}
 if ServiceUrl.IsEmpty then
  raise EInvalidURL.Create(TServiceConnectionConst.InvalidUrl);

 HTTPClientObj :=  TNetHTTPClient.Create(nil);
 self.LoadServiceParams(HTTPClientObj);

 try
  Result := HTTPClientObj.Get(ServiceUrl, Stream);

  if (Result <> nil) and (Result.StatusCode <> THTTPStatus.StatusOK) then
   begin //Servi�o n�o respondeu ou respondeu sinalizando alguma falha.
      case Result.StatusCode of //Respostas tratadas de forma espec�fica: HTTPStatus <> 200
        THTTPStatus.StatusBadRequest:
          begin
           raise EHTTPBadRequest.Create(TServiceConnectionConst.StatusBadRequest);
          end;
      end;
   end
   else
    begin
     if Result = nil then //sem resposta do servi�o remoto.
      raise ENoServiceResponse.Create(TServiceConnectionConst.NoServiceResponse);
    end;

   if Assigned(HTTPClientObj) then
    FreeAndNil(HTTPClientObj);

 except
   on E: ENoServiceResponse do //N�o houve resposta do servi�o remoto.
    begin
      if Assigned(HTTPClientObj) then
       FreeAndNil(HTTPClientObj);
    end;
   on E: EHTTPBadRequest do //Servi�o remoto respondeu com falha: Bad Request.
    begin
      if Assigned(HTTPClientObj) then
       FreeAndNil(HTTPClientObj);
    end
   else
    begin //Servi�o remoto respondeu com falha: demais cen�rios.
      if Assigned(HTTPClientObj) then
       FreeAndNil(HTTPClientObj);
    end;
 end;
end;

procedure TNetHTTPService.LoadServiceParams(ClientObj: TNetHTTPClient);
begin
 with ClientObj do
  begin
    AcceptCharSet := TChatServiceConst.ServiceCharSet;
    AcceptEncoding := TChatServiceConst.AcceptEncoding;
    AcceptLanguage := TChatServiceConst.AcceptLanguage;
    ContentType := TChatServiceConst.ContentType;
    UserAgent := TChatServiceConst.UserAgent;

    //Timeouts
    ConnectionTimeout := TChatServiceConst.ConnectionTimeout;
    ResponseTimeout := TChatServiceConst.ResponseTimeout;

    //Mapeamento de eventos.
    ClientObj.OnRequestCompleted := TSOAPEvents.DoOnRequestCompleted;
    ClientObj.OnRequestError     := TSOAPEvents.DoOnRequestError;
  end;
end;

end.
