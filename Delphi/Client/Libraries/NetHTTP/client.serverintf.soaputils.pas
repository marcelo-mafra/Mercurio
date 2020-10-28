unit client.serverintf.soaputils;

interface
 uses
  System.Classes, System.Net.HttpClient, System.SysUtils, classes.logs.types,
  client.resources.mercurio, client.resources.logs, client.resources.methods,
  classes.logs.factory;

 type
{Classe que mapeia eventos de THTTPRIO. Ela utiliza métodos utilitários
  definidos em TSOAPEventsUtils.}
  TSOAPEvents = class
    class procedure DoAfterExecuteEvent(const MethodName: string; SOAPResponse: TStream);
    class procedure DoOnRequestCompleted(const Sender: TObject; const AResponse: IHTTPResponse);
    class procedure DoOnRequestError(const Sender: TObject; const AError: string);
    class procedure DoOnSOAPError(const ServiceUrl: string; Stream: TStream; E: Exception);
  end;

implementation

{TSOAPEventsUtils é definido apenas na seção "implementation" de forma a ficar
inacessível mesmo a partir de outras units que acessam essa.}
type
  TSOAPEventsUtils = class
    strict private
     function GetMercurioLogs: IMercurioLogs;

    private
     FParamsFile: string;

    public
     constructor Create;
     destructor Destroy; override;
     function StreamToString(aStream: TStream): string;

     property ParamsFile: string read FParamsFile;
     property MercurioLogs: IMercurioLogs read GetMercurioLogs;
  end;


{ TSOAPEvents }

class procedure TSOAPEvents.DoAfterExecuteEvent(const MethodName: string;
  SOAPResponse: TStream);
var
 UtilsObj: TSOAPEventsUtils;
 ContextInfo: string;
begin
  UtilsObj := TSOAPEventsUtils.Create;

  try
   ContextInfo := MethodName + #13; //do not localize!
   ContextInfo := ContextInfo + UtilsObj.StreamToString(SOAPResponse);

   UtilsObj.MercurioLogs.RegisterRemoteCallSucess(Format(TSOAPEventsMsg.AfterExecute, [MethodName]), ContextInfo);

  finally
   if Assigned(UtilsObj) then FreeAndNil(UtilsObj);
  end;
end;

class procedure TSOAPEvents.DoOnRequestCompleted(const Sender: TObject;
  const AResponse: IHTTPResponse);
var
 UtilsObj: TSOAPEventsUtils;
 ContextInfo: string;
begin
  UtilsObj := TSOAPEventsUtils.Create;

  try
   ContextInfo := AResponse.StatusText;// AResponse.ContentAsString(TEncoding.UTF8);
   ContextInfo := ContextInfo + UtilsObj.StreamToString(AResponse.ContentStream);

   UtilsObj.MercurioLogs.RegisterRemoteCallSucess(TSOAPEventsMsg.RequestCompleted, ContextInfo);

  finally
   if Assigned(UtilsObj) then FreeAndNil(UtilsObj);
  end;

end;

class procedure TSOAPEvents.DoOnRequestError(const Sender: TObject;
  const AError: string);
var
 UtilsObj: TSOAPEventsUtils;
 ContextInfo: string;
begin
  UtilsObj := TSOAPEventsUtils.Create;

  try
   ContextInfo := AError;
   UtilsObj.MercurioLogs.RegisterRemoteCallSucess(TSOAPEventsMsg.RequestError, ContextInfo);

  finally
   if Assigned(UtilsObj) then FreeAndNil(UtilsObj);
  end;
end;

class procedure TSOAPEvents.DoOnSOAPError(const ServiceUrl: string;
  Stream: TStream; E: Exception);
var
 UtilsObj: TSOAPEventsUtils;
 ContextInfo: string;
begin
  UtilsObj := TSOAPEventsUtils.Create;

  try
   ContextInfo := ServiceUrl + #13; //do not localize!
   ContextInfo := ContextInfo + UtilsObj.StreamToString(Stream);

   if E <> nil then
    UtilsObj.MercurioLogs.RegisterRemoteCallFailure(E.Message, ContextInfo)
   else
    UtilsObj.MercurioLogs.RegisterRemoteCallFailure(TServerMethodsCall.RemoteMethodError, ContextInfo);

  finally
   if Assigned(UtilsObj) then FreeAndNil(UtilsObj);
  end;

end;

{******************************************************************************
******************************************************************************}

{ TSOAPEventsUtils }

constructor TSOAPEventsUtils.Create;
begin
 inherited;
 FParamsFile := GetCurrentDir + '\' + TMercurioIniFile.ConfigFile;
end;

destructor TSOAPEventsUtils.Destroy;
begin
  inherited;
end;

function TSOAPEventsUtils.GetMercurioLogs: IMercurioLogs;
begin
{Retorna uma interface que abstrai recursos de geração de registros de logs para
 toda a aplicação.}
  Result := TFactoryLogs.New(ParamsFile);
end;

function TSOAPEventsUtils.StreamToString(aStream: TStream): string;
var
  StrStream: TStringStream;
begin
  if aStream <> nil then
  begin
    StrStream := TStringStream.Create(string.Empty);

    try
      StrStream.CopyFrom(aStream, 0);  // No need to position at 0 nor provide size
      Result := StrStream.DataString;

    finally
      StrStream.Free;
    end;
  end
  else
    Result := string.Empty;
end;



end.
