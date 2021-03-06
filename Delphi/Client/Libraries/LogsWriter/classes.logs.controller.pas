unit classes.logs.controller;

interface

uses
 Winapi.Windows, System.Classes, System.UITypes, System.SysUtils, classes.logs.types,
 classes.logs.textfile, System.Threading;


 type
{ Evento disparado quando um novo arquivo delogs passa a ser usado.}
  TOnNewFileEvent = procedure(var NewFileName: string) of object;

  TMercurioLogs = class(TInterfacedObject, IMercurioLogs)

   private
    AWriter: TTextFileLog;
    FAppName, FCurrentFile: string;
    FDefaultFileExt: string;
    FEncoding: TEncoding;
    FEvents: TLogEvents;
    FFileExtension: string;
    FMaxFileSize: int64;
    FPrefix: string;
    FSourcePath: string;
    FOnNewFileEvent: TOnNewFileEvent;

    function CreateWriter: TTextFileLog;
    function GetCurrentFile: string;
    procedure SetCurrentFile(const CurrentFile: string);

   public
    {IMercurioLogs}
    procedure RegisterAuditFailure(const Message: string);
    procedure RegisterAuditSucess(const Message: string);
    procedure RegisterError(const Message: string); overload;
    procedure RegisterError(const Message, ContextInfo: string); overload;
    procedure RegisterInfo(const Message: string);
    procedure RegisterSucess(const Message: string);
    procedure RegisterWarning(const Message: string);
    procedure RegisterRemoteCallSucess(const Message, ContextInfo: string);
    procedure RegisterRemoteCallFailure(const Message, ContextInfo: string);
    procedure RegisterLog(const Info, ContextInfo: string; Event: TLogEvent);

    constructor Create(const SourcePath: string); overload;
    constructor Create(const SourcePath, FileExtension: string; Encoding: TEncoding); overload;
    constructor Create(const SourcePath, FileExtension: string; Encoding: TEncoding;
       Events: TLogEvents); overload;
    destructor Destroy; override;

    property AppName: string read FAppName write FAppName;
    property CurrentFile: string read GetCurrentFile write SetCurrentFile;
    property Encoding: TEncoding read FEncoding;
    property Events: TLogEvents read FEvents write FEvents;
    property FileExtension: string read FFileExtension;
    property MaxFileSize: int64 read FMaxFileSize write FMaxFileSize;
    property Prefix: string read FPrefix write FPrefix;
    property SourcePath: string read FSourcePath;

    property OnNewFile: TOnNewFileEvent read FOnNewFileEvent write FOnNewFileEvent;

 end;


implementation

{ TMercurioLogs }

constructor TMercurioLogs.Create(const SourcePath, FileExtension: string;
     Encoding: TEncoding; Events: TLogEvents);
begin
 inherited Create;
 FSourcePath := SourcePath;
 FFileExtension := FileExtension;
 FEncoding := Encoding;
 FEvents := Events;
end;

constructor TMercurioLogs.Create(const SourcePath,
  FileExtension: string; Encoding: TEncoding);
begin
 inherited Create;
 FSourcePath := SourcePath;
 FFileExtension := FileExtension;
 FEncoding := Encoding;

 //default events types.
 FEvents := [leOnError, leOnAuthenticateSucess, leOnAuthenticateFail, leOnInformation,
            leOnWarning, leOnConnect, leOnConnectError, leOnMethodCall,
            leOnMethodCallError, leUnknown];
end;

constructor TMercurioLogs.Create(const SourcePath: string);
begin
 inherited Create;
 FSourcePath := SourcePath;
 FDefaultFileExt := '.log'; //default file extension
 FFileExtension := FDefaultFileExt;
 FEncoding := TEncoding.UTF8; //default

 //default events types.
 FEvents := [leOnError, leOnAuthenticateSucess, leOnAuthenticateFail, leOnInformation,
            leOnWarning, leOnConnect, leOnConnectError, leOnMethodCall,
            leOnMethodCallError, leUnknown];
end;

function TMercurioLogs.CreateWriter: TTextFileLog;
begin
 Result := TTextFileLog.Create(SourcePath, FileExtension, Encoding, Events);
 Result.OnNewFile := OnNewFile;
end;

destructor TMercurioLogs.Destroy;
begin
  if Assigned(AWriter) then FreeAndNil(AWriter);
  inherited Destroy;
end;

function TMercurioLogs.GetCurrentFile: string;
begin
 Result := FCurrentFile;
end;

procedure TMercurioLogs.RegisterAuditFailure(const Message: string);
begin
  inherited;
  RegisterLog(Message, '', leOnAuthenticateFail);
end;

procedure TMercurioLogs.RegisterAuditSucess(const Message: string);
begin
  inherited;
  RegisterLog(Message, '', leOnAuthenticateSucess);
end;

procedure TMercurioLogs.RegisterError(const Message,
  ContextInfo: string);
begin
  inherited;
  RegisterLog(Message, ContextInfo, leOnError);
end;

procedure TMercurioLogs.RegisterError(const Message: string);
begin
  inherited;
  RegisterLog(Message, '', leOnError);
end;

procedure TMercurioLogs.RegisterInfo(const Message: string);
begin
  inherited;
  RegisterLog(Message, '', leOnInformation);
end;

procedure TMercurioLogs.RegisterLog(const Info, ContextInfo: string;
  Event: TLogEvent);
var
 AList: TStringList;
 AInfo, AContextInfo: string;
begin
{Este m�todo monta as amensagens de log e utiliza m�todos de "atalho" para escrever
as mensagens de log.}
  inherited;
  if not (Event in self.Events) then
   Exit;

 AList := TStringList.Create;

 try
  if (AWriter = nil) and (DirectoryExists(SourcePath)) then
   begin
    AWriter := CreateWriter;
    AWriter.AutoSave := True;
    AWriter.MaxSize := MaxFileSize;
    AWriter.Prefix := Prefix;
    AWriter.CurrentFile := CurrentFile;
   end;

  AInfo := Info;
  {Retira todas as quebras de linha da mensagem. Isso � necess�rio para que a
  ferramenta de visualiza��o de logs exiba corretamente o texto do log.}
  while AInfo.IndexOf(#10) >= 0 do
    AInfo := AInfo.Replace(#10, ' ');

  AContextInfo := ContextInfo;

  while AContextInfo.IndexOf(#10) >= 0 do
   begin
    AContextInfo := AContextInfo.Replace(#10, ' ');
    AContextInfo := AContextInfo.Replace(#13, ' ');
   end;

 if Assigned(AWriter) then
  begin
   AList.Append(Format(TLogInfo.DATETIME, [DateTimeToStr(Now)]));
   AList.Append(Format(TLogInfo.APPLICATION, [self.AppName]));
   AList.Append(Format(TLogInfo.MESSAGEINFO, [AInfo]));
   AList.Append(Format(TLogInfo.CONTEXT, [AContextInfo]));

   case Event of
     leOnInformation:
       begin
         AList.Append(Format(TLogInfo.LOGTYPE, [TMercurioLogsConst.InfoLogType]));
         AWriter.RegisterInfo(AList.CommaText);
       end;
     leOnWarning:
       begin
         AList.Append(Format(TLogInfo.LOGTYPE, [TMercurioLogsConst.WarnLogType]));
         AWriter.RegisterWarning(AList.CommaText);
       end;
     leOnError:
       begin
         AList.Append(Format(TLogInfo.LOGTYPE, [TMercurioLogsConst.ErrorLogType]));
         AWriter.RegisterError(AList.CommaText);
       end;
     leOnPrepare:
       begin
         AList.Append(Format(TLogInfo.LOGTYPE, [TMercurioLogsConst.PrepareLogType]));
         AWriter.RegisterPrepare(AList.CommaText);
       end;
     leOnTrace:
       begin
         AList.Append(Format(TLogInfo.LOGTYPE, [TMercurioLogsConst.TraceLogType]));
         AWriter.RegisterTrace(AList.CommaText);
       end;
     leOnAuthenticateSucess:
       begin
         AList.Append(Format(TLogInfo.LOGTYPE, [TMercurioLogsConst.AuthLogType]));
         AWriter.RegisterAuditSucess(AList.CommaText);
       end;
     leOnAuthenticateFail:
       begin
         AList.Append(Format(TLogInfo.LOGTYPE, [TMercurioLogsConst.AuthFailLogType]));
         AWriter.RegisterAuditFailure(AList.CommaText);
       end;
     leOnAuthorize:
       begin
         AList.Append(Format(TLogInfo.LOGTYPE, [TMercurioLogsConst.AutLogType]));
         AWriter.RegisterAuthorization(AList.CommaText);
       end;
     leOnConnect:
       begin
         AList.Append(Format(TLogInfo.LOGTYPE, [TMercurioLogsConst.ConLogType]));
         AWriter.RegisterConnection(AList.CommaText);
       end;
     leOnConnectError:
       begin
         AList.Append(Format(TLogInfo.LOGTYPE, [TMercurioLogsConst.ConErrorLogType]));
         AWriter.RegisterConnectionFailure(AList.CommaText);
       end;
     leOnConnectClose:
       begin
         AList.Append(Format(TLogInfo.LOGTYPE, [TMercurioLogsConst.ConCloseLogType]));
         AWriter.RegisterConnectionClose(AList.CommaText);
       end;
     leOnMethodCall:
       begin
         AList.Append(Format(TLogInfo.LOGTYPE, [TMercurioLogsConst.RemoteCallLogType]));
         AWriter.RegisterRemoteCallSucess(AList.CommaText);
       end;
     leOnMethodCallError:
       begin
         AList.Append(Format(TLogInfo.LOGTYPE, [TMercurioLogsConst.RemoteCallErrorLogType]));
         AWriter.RegisterRemoteCallFailure(AList.CommaText);
       end;
     leUnknown:
       begin
         AList.Append(Format(TLogInfo.LOGTYPE, [TMercurioLogsConst.UnknownLogType]));
         AWriter.RegisterUnknow(AList.CommaText);
       end;
   end;
  end;

  if Assigned(AList) then FreeAndNil(AList);

 except
   on E: Exception do
    begin
     if Assigned(AList) then FreeAndNil(AList);
    end;
 end;
end;

procedure TMercurioLogs.RegisterRemoteCallFailure(const Message,
  ContextInfo: string);
begin
   RegisterLog(Message, ContextInfo, leOnMethodCallError);
end;

procedure TMercurioLogs.RegisterRemoteCallSucess(const Message,
  ContextInfo: string);
begin
   RegisterLog(Message, ContextInfo, leOnMethodCall);
end;

procedure TMercurioLogs.RegisterSucess(const Message: string);
begin
  inherited;
  RegisterLog(Message, '', leOnInformation);
end;

procedure TMercurioLogs.RegisterWarning(const Message: string);
begin
  inherited;
  RegisterLog(Message, '', leOnWarning);
end;

procedure TMercurioLogs.SetCurrentFile(const CurrentFile: string);
begin
 FCurrentFile := CurrentFile;
 if Assigned(AWriter) then AWriter.CurrentFile := CurrentFile;
end;


end.
