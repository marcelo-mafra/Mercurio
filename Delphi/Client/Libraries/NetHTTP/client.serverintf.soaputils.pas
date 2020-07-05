unit client.serverintf.soaputils;

interface
 uses
  System.Classes, WinAPI.Windows, classes.logs, classes.logs.controller,
  client.resources.mercurio, client.resources.svcconsts, classes.conflogs,
  System.SysUtils, client.resources.consts, System.Net.HttpClient;

 type
  //Classe utilitária que mapeia eventos de THTTPRIO e exibe métodos utilitários.
  TSOAPEvents = class
    class procedure DoAfterExecuteEvent(const MethodName: string; SOAPResponse: TStream);
    class function  CreateLogsObject: TMercurioLogsController;
    class procedure DoOnNewFileEvent(var NewFileName: string);
    class function  StreamToString(aStream: TStream): string;
    class procedure DoOnRequestCompleted(const Sender: TObject; const AResponse: IHTTPResponse);
    class procedure DoOnRequestError(const Sender: TObject; const AError: string);
    class procedure DoOnSOAPError(const ServiceUrl: string; Stream: TStream; E: Exception);
  end;

implementation

{ TSOAPEvents }

class function TSOAPEvents.CreateLogsObject: TMercurioLogsController;
var
 ConfObj: TLogsConfigurations;
 Events: TLogEvents;
begin
  Events := [leOnError, leOnAuthenticateSucess, leOnAuthenticateFail, leOnInformation,
             leOnWarning, leOnConnect, leOnConnectError, leOnMethodCall,
             leOnMethodCallError, leUnknown];

  ConfObj := TLogsConfigurations.Create(GetCurrentDir + '\' + TMercurioConst.ConfigFile);

    try
      Result := TMercurioLogsController.Create(ConfObj.Folder, TMercurioLogs.FileExtension, TEncoding.UTF8, Events);
      Result.OnNewFile := DoOnNewFileEvent;
      Result.MaxFileSize := ConfObj.MaxFileSize;
      Result.AppName     := TChatServiceLabels.ServiceName;
      Result.CurrentFile := ConfObj.CurrentFile;

    finally
     ConfObj.Free;
    end;
end;

class procedure TSOAPEvents.DoAfterExecuteEvent(const MethodName: string;
  SOAPResponse: TStream);
var
 LogsObj: TMercurioLogsController;
 ContextInfo: string;
begin
  LogsObj := TSOAPEvents.CreateLogsObject;

  try
   ContextInfo := MethodName + #13; //do not localize!
   ContextInfo := ContextInfo + self.StreamToString(SOAPResponse);

   LogsObj.RegisterRemoteCallSucess(TChatMessagesConst.CallRemoteMethodSucess, ContextInfo);

  finally
   if Assigned(LogsObj) then FreeAndNil(LogsObj);
  end;
end;

class procedure TSOAPEvents.DoOnNewFileEvent(var NewFileName: string);
var
 ConfObj: TLogsConfigurations;
begin
{Aponta para o evento OnNewFile de TMercurioLogsController, disparado sempre que
 o arquivo de logs atinge otamanho máximo e se cria um novo para ser usado. Nesse
 caso, é necessário registrar isso no .ini para que na próxima execução do cliente
 o uso deste arquivo seja retomado até atingir o tamanho máximo definido.}
  ConfObj := TLogsConfigurations.Create(GetCurrentDir + '\' + TMercurioConst.ConfigFile);

    try
      ConfObj.CurrentFile := NewFileName;

    finally
      ConfObj.Free;
    end;
end;

class procedure TSOAPEvents.DoOnRequestCompleted(const Sender: TObject;
  const AResponse: IHTTPResponse);
var
 LogsObj: TMercurioLogsController;
 ContextInfo: string;
begin
  LogsObj := TSOAPEvents.CreateLogsObject;

  try
   ContextInfo := AResponse.StatusText;// AResponse.ContentAsString(TEncoding.UTF8);
   ContextInfo := ContextInfo + self.StreamToString(AResponse.ContentStream);

   LogsObj.RegisterRemoteCallSucess(TChatMessagesConst.CallRemoteMethodSucess, ContextInfo);

  finally
   if Assigned(LogsObj) then FreeAndNil(LogsObj);
  end;

end;

class procedure TSOAPEvents.DoOnRequestError(const Sender: TObject;
  const AError: string);
var
 LogsObj: TMercurioLogsController;
 ContextInfo: string;
begin
  LogsObj := TSOAPEvents.CreateLogsObject;

  try
   ContextInfo := AError;
   //ContextInfo := ContextInfo + self.StreamToString(AResponse.ContentStream);

   LogsObj.RegisterRemoteCallSucess(TChatMessagesConst.CallRemoteMethodError, ContextInfo);

  finally
   if Assigned(LogsObj) then FreeAndNil(LogsObj);
  end;
end;

class procedure TSOAPEvents.DoOnSOAPError(const ServiceUrl: string;
  Stream: TStream; E: Exception);
var
 LogsObj: TMercurioLogsController;
 ContextInfo: string;
begin
  LogsObj := TSOAPEvents.CreateLogsObject;

  try
   ContextInfo := ServiceUrl + #13; //do not localize!
   ContextInfo := ContextInfo + self.StreamToString(Stream);

   if E <> nil then
    LogsObj.RegisterRemoteCallFailure(E.Message, ContextInfo)
   else
    LogsObj.RegisterRemoteCallFailure(TChatMessagesConst.CallRemoteMethodError, ContextInfo);

  finally
   if Assigned(LogsObj) then FreeAndNil(LogsObj);
  end;

end;

class function TSOAPEvents.StreamToString(aStream: TStream): string;
var
  StrStream: TStringStream;
begin
  if aStream <> nil then
  begin
    StrStream := TStringStream.Create('');

    try
      StrStream.CopyFrom(aStream, 0);  // No need to position at 0 nor provide size
      Result := StrStream.DataString;

    finally
      StrStream.Free;
    end;
  end
  else
    Result := '';
end;

end.
