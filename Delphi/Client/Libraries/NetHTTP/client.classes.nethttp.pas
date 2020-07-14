unit client.classes.nethttp;

interface

uses
  System.SysUtils, System.Classes, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent, Winapi.Windows, System.NetEncoding, classes.exceptions,
  classes.exceptions.connection, client.resources.httpstatus, client.resources.serviceparams,
  System.Json, client.classes.json, client.serverintf.soaputils;

 type
   //Methods of http protocol.
   TNetMethods = (nmGET, nmPOST, nmPUT, nmDELETE, nmPATCH);

   {Classe que encapsula as a comunicação http com o serviço remoto de chat.}
   TNetHTTPService = class(TInterfacedObject)
     private
       procedure LoadServiceParams(ClientObj: TNetHTTPClient); inline;
       procedure SetEvents(ClientObj: TNetHTTPClient); inline;

     public
       constructor Create;
       destructor Destroy; override;

       function Execute(const ServiceUrl: string; Stream: TStream; RequestMethod: TNetMethods = nmGET): IHTTPResponse; overload;
       function Execute(const ServiceUrl: string; RequestMethod: TNetMethods = nmGET): TJsonObject; overload;
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

function TNetHTTPService.Execute(const ServiceUrl: string;
  RequestMethod: TNetMethods = nmGET): TJsonObject;
var
 HTTPClientObj: TNetHTTPClient;
 IResponse: IHTTPResponse;
begin
 {O método "Execute" aciona um webmétodo do serviço remoto.}
 if ServiceUrl.IsEmpty then
  begin
   Result := nil;
   raise EInvalidURL.Create;
  end;

 HTTPClientObj :=  TNetHTTPClient.Create(nil);
 self.LoadServiceParams(HTTPClientObj);
 self.SetEvents(HTTPClientObj);

 try
  case RequestMethod of
    nmGET: IResponse := HTTPClientObj.Get(ServiceUrl);
    //nmPOST: IResponse := HTTPClientObj.Post(ServiceUrl);
    nmPUT: IResponse := HTTPClientObj.Put(ServiceUrl);
    nmDELETE: IResponse := HTTPClientObj.Delete(ServiceUrl);
    nmPATCH: IResponse := HTTPClientObj.Patch(ServiceUrl);
  end;

  if (IResponse <> nil) then
   begin //Serviço não respondeu ou respondeu sinalizando alguma falha.
      case IResponse.StatusCode of //Respostas tratadas de forma específica: HTTPStatus <> 200
        THTTPStatus.StatusOK: if Assigned(HTTPClientObj) then FreeAndNil(HTTPClientObj);
        THTTPStatus.StatusBadRequest: raise EHTTPBadRequest.Create;
        THTTPStatus.StatusServiceUnavailable: raise ENoServiceResponse.Create;
        THTTPStatus.StatusRequestTimeout: raise ENoServiceResponse.Create;
      end;
   end
   else //sem resposta do serviço remoto.
     raise ENoServiceResponse.Create;

   //Isso está errado. O ContentAsString nunca retorna um JSON, mas um HTML.
   Result := TNetJsonUtils.AsJsonObject(IResponse.ContentAsString);

 except
   on E: ENoServiceResponse do //Não houve resposta do serviço remoto.
    begin
      Result := nil;
      if Assigned(HTTPClientObj) then FreeAndNil(HTTPClientObj);
      TSOAPEvents.DoOnSOAPError(ServiceUrl, nil, E);
    end;
   on E: EHTTPBadRequest do //Serviço remoto respondeu com falha: Bad Request.
    begin
      Result := nil;
      if Assigned(HTTPClientObj) then FreeAndNil(HTTPClientObj);
      TSOAPEvents.DoOnSOAPError(ServiceUrl, nil, E);
    end
   else
    begin //Serviço remoto respondeu com falha: demais cenários.
      Result := nil;
      if Assigned(HTTPClientObj) then FreeAndNil(HTTPClientObj);
      TSOAPEvents.DoOnSOAPError(ServiceUrl, nil, nil);
    end;
 end;
end;

function TNetHTTPService.Execute(const ServiceUrl: string;
  Stream: TStream; RequestMethod: TNetMethods = nmGET): IHTTPResponse;
var
 HTTPClientObj: TNetHTTPClient;
begin
 {O método "Execute" aciona um webmétodo do serviço remoto.}
 if ServiceUrl.IsEmpty then
  raise EInvalidURL.Create;

 HTTPClientObj :=  TNetHTTPClient.Create(nil);

 try
  self.LoadServiceParams(HTTPClientObj);
  self.SetEvents(HTTPClientObj);

  case RequestMethod of
    nmGET: Result := HTTPClientObj.Get(ServiceUrl, Stream);
    //nmPOST: Result := HTTPClientObj.Post(ServiceUrl, Stream);
    nmPUT: Result := HTTPClientObj.Put(ServiceUrl, Stream);
    nmDELETE: Result := HTTPClientObj.Delete(ServiceUrl, Stream);
    nmPATCH: Result := HTTPClientObj.Patch(ServiceUrl, Stream);
  end;

  if (Result <> nil) then
   begin //Trata cenários onde houve resposta, mas sinalizando alguma falha.
      case Result.StatusCode of //Respostas tratadas de forma específica: HTTPStatus <> 200
        THTTPStatus.StatusOK: if Assigned(HTTPClientObj) then FreeAndNil(HTTPClientObj);
        THTTPStatus.StatusBadRequest: raise EHTTPBadRequest.Create;
        THTTPStatus.StatusServiceUnavailable: raise ENoServiceResponse.Create;
        THTTPStatus.StatusRequestTimeout: raise ENoServiceResponse.Create;
      end;
   end
   else //Cenário sem resposta do serviço remoto.
      raise ENoServiceResponse.Create;

 except
   on E: ENoServiceResponse do //Não houve resposta do serviço remoto.
    begin
      if Assigned(HTTPClientObj) then FreeAndNil(HTTPClientObj);
      TSOAPEvents.DoOnSOAPError(ServiceUrl, Stream, E);
    end;
   on E: EHTTPBadRequest do //Serviço remoto respondeu com falha: Bad Request.
    begin
      if Assigned(HTTPClientObj) then FreeAndNil(HTTPClientObj);
      TSOAPEvents.DoOnSOAPError(ServiceUrl, Stream, E);
    end
   else
    begin //Serviço remoto respondeu com falha: demais cenários.
      if Assigned(HTTPClientObj) then FreeAndNil(HTTPClientObj);
      TSOAPEvents.DoOnSOAPError(ServiceUrl, Stream, nil);
    end;
 end;
end;

procedure TNetHTTPService.LoadServiceParams(ClientObj: TNetHTTPClient);
begin
 with ClientObj do
  begin
    AcceptCharSet := TServiceParams.ServiceCharSet;
    AcceptEncoding := TServiceParams.AcceptEncoding;
    AcceptLanguage := TServiceParams.AcceptLanguage;
    ContentType := TServiceParams.ContentType;
    UserAgent := TServiceParams.UserAgent;

    //Timeouts
    ConnectionTimeout := TServiceParams.ConnectionTimeout;
    ResponseTimeout := TServiceParams.ResponseTimeout;
  end;
end;

procedure TNetHTTPService.SetEvents(ClientObj: TNetHTTPClient);
begin
 //"Apontamento" de eventos do objeto TNetHTTPClient.
 ClientObj.OnRequestCompleted := TSOAPEvents.DoOnRequestCompleted;
 ClientObj.OnRequestError     := TSOAPEvents.DoOnRequestError;
end;

end.
