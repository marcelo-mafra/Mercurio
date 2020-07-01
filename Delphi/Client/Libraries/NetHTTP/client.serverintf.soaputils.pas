unit client.serverintf.soaputils;

interface
 uses
  System.Classes, WinAPI.Windows, classes.logs, classes.logs.controller,
  System.IniFiles, client.resources.mercurio, client.resources.svcconsts,
  System.SysUtils, client.resources.consts, System.Net.HttpClient;

 type
  //Classe utilitária que mapeia eventos de THTTPRIO e exibe métodos utilitários.
  TSOAPEvents = class
    class procedure DoAfterExecuteEvent(const MethodName: string; SOAPResponse: TStream);
    class function  CreateLogsObject: TMercurioLogsController;
    class function  StreamToString(aStream: TStream): string;
    class procedure DoOnRequestCompleted(const Sender: TObject; const AResponse: IHTTPResponse);
    class procedure DoOnRequestError(const Sender: TObject; const AError: string);
  end;

implementation

{ TSOAPEvents }

class function TSOAPEvents.CreateLogsObject: TMercurioLogsController;
var
 ConfigFile: TIniFile;
 FileName, Folder, CurrentFile: string;
 MaxFileSize: Integer;
 Events: TLogEvents;
begin
  Events := [leOnError, leOnAuthenticateSucess, leOnAuthenticateFail, leOnInformation,
             leOnWarning, leOnConnect, leOnConnectError, leOnMethodCall,
             leOnMethodCallError, leUnknown];

  FileName := GetCurrentDir + '\' + TMercurioConst.ConfigFile;
  ConfigFile := TIniFile.Create(FileName);

    try
      Folder := ConfigFile.ReadString(TMercurioConst.ConfigSection, TMercurioConst.ConfigFolder, '');
      CurrentFile := ConfigFile.ReadString(TMercurioConst.ConfigSection, TMercurioConst.ConfigCurrentFile, '');
      MaxFileSize := ConfigFile.ReadInteger(TMercurioConst.ConfigSection, TMercurioConst.ConfigMaxFileSize, TMercurioConst.DefaultMaxSize);

      Result := TMercurioLogsController.Create(Folder, '.log', TEncoding.UTF8, Events);
      Result.MaxFileSize := MaxFileSize;
      Result.AppName     := TChatServiceLabels.ServiceName;
      Result.CurrentFile := CurrentFile;

    finally
      ConfigFile.Free;
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
