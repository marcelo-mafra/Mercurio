unit classes.logs.controller;

interface

uses
 Winapi.Windows, System.Classes, System.UITypes, System.SysUtils, classes.logs,
 classes.logs.textfile, System.Threading;


 type
  TOnNewFileEvent = procedure(var NewFileName: string) of object;

  TMercurioLogsController = class(TInterfacedObject, IMercurioLogs)

   private
    AWriter: TTextFileLog;
    FAppName, FCurrentFile: string;
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
    procedure RegisterError(const Message: string);
    procedure RegisterInfo(const Message: string);
    procedure RegisterSucess(const Message: string);
    procedure RegisterWarning(const Message: string);
    procedure RegisterRemoteCallSucess(const Message, ContextInfo: string);
    procedure RegisterRemoteCallFailure(const Message, ContextInfo: string);
    procedure RegisterLog(const Info, ContextInfo: string; Event: TLogEvent);

    constructor Create(const SourcePath, FileExtension: string; Encoding: TEncoding;
     Events: TLogEvents);
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

{ TMercurioLogsController }

constructor TMercurioLogsController.Create(const SourcePath, FileExtension: string;
     Encoding: TEncoding; Events: TLogEvents);
begin
 inherited Create;
 FSourcePath := SourcePath;
 FFileExtension := FileExtension;
 FEncoding := Encoding;
 FEvents := Events;
end;

function TMercurioLogsController.CreateWriter: TTextFileLog;
begin
 Result := TTextFileLog.Create(SourcePath, FileExtension, Encoding, Events);
 Result.OnNewFile := OnNewFile;
end;

destructor TMercurioLogsController.Destroy;
begin
  if Assigned(AWriter) then FreeAndNil(AWriter);
  inherited Destroy;
end;

function TMercurioLogsController.GetCurrentFile: string;
begin
 Result := FCurrentFile;
end;

procedure TMercurioLogsController.RegisterAuditFailure(const Message: string);
begin
  inherited;
  RegisterLog(Message, '', leOnAuthenticateFail);
end;

procedure TMercurioLogsController.RegisterAuditSucess(const Message: string);
begin
  inherited;
  RegisterLog(Message, '', leOnAuthenticateSucess);
end;

procedure TMercurioLogsController.RegisterError(const Message: string);
begin
  inherited;
  RegisterLog(Message, '', leOnError);
end;

procedure TMercurioLogsController.RegisterInfo(const Message: string);
begin
  inherited;
  RegisterLog(Message, '', leOnInformation);
end;

procedure TMercurioLogsController.RegisterLog(const Info, ContextInfo: string;
  Event: TLogEvent);
var
 AList: TStringList;
 AInfo, AContextInfo: string;
begin
{Este método monta as amensagens de log e utiliza métodos de "atalho" para escrever
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
  {Retira todas as quebras de linha da mensagem. Isso é necessário para que a
  ferramenta de visualização de logs exiba corretamente o texto do log.}
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
         AList.Append(Format(TLogInfo.LOGTYPE, [TMercurioLogs.InfoLogType]));
         AWriter.RegisterInfo(AList.CommaText);
       end;
     leOnWarning:
       begin
         AList.Append(Format(TLogInfo.LOGTYPE, [TMercurioLogs.WarnLogType]));
         AWriter.RegisterWarning(AList.CommaText);
       end;
     leOnError:
       begin
         AList.Append(Format(TLogInfo.LOGTYPE, [TMercurioLogs.ErrorLogType]));
         AWriter.RegisterError(AList.CommaText);
         outputdebugstring(PWideChar(AContextInfo));
       end;
     leOnPrepare:
       begin
         AList.Append(Format(TLogInfo.LOGTYPE, [TMercurioLogs.PrepareLogType]));
         AWriter.RegisterPrepare(AList.CommaText);
       end;
     leOnTrace:
       begin
         AList.Append(Format(TLogInfo.LOGTYPE, [TMercurioLogs.TraceLogType]));
         AWriter.RegisterTrace(AList.CommaText);
       end;
     leOnAuthenticateSucess:
       begin
         AList.Append(Format(TLogInfo.LOGTYPE, [TMercurioLogs.AuthLogType]));
         AWriter.RegisterAuditSucess(AList.CommaText);
       end;
     leOnAuthenticateFail:
       begin
         AList.Append(Format(TLogInfo.LOGTYPE, [TMercurioLogs.AuthFailLogType]));
         AWriter.RegisterAuditFailure(AList.CommaText);
       end;
     leOnAuthorize:
       begin
         AList.Append(Format(TLogInfo.LOGTYPE, [TMercurioLogs.AutLogType]));
         AWriter.RegisterAuthorization(AList.CommaText);
       end;
     leOnConnect:
       begin
         AList.Append(Format(TLogInfo.LOGTYPE, [TMercurioLogs.ConLogType]));
         AWriter.RegisterConnection(AList.CommaText);
       end;
     leOnConnectError:
       begin
         AList.Append(Format(TLogInfo.LOGTYPE, [TMercurioLogs.ConErrorLogType]));
         AWriter.RegisterConnectionFailure(AList.CommaText);
       end;
     leOnConnectClose:
       begin
         AList.Append(Format(TLogInfo.LOGTYPE, [TMercurioLogs.ConCloseLogType]));
         AWriter.RegisterConnectionClose(AList.CommaText);
       end;
     leOnMethodCall:
       begin
         AList.Append(Format(TLogInfo.LOGTYPE, [TMercurioLogs.RemoteCallLogType]));
         AWriter.RegisterRemoteCallSucess(AList.CommaText);
       end;
     leOnMethodCallError:
       begin
         AList.Append(Format(TLogInfo.LOGTYPE, [TMercurioLogs.RemoteCallErrorLogType]));
         AWriter.RegisterRemoteCallFailure(AList.CommaText);
       end;
     leUnknown:
       begin
         AList.Append(Format(TLogInfo.LOGTYPE, [TMercurioLogs.UnknownLogType]));
         AWriter.RegisterUnknow(AList.CommaText);
       end;
   end;
  end;

  if Assigned(AList) then FreeAndNil(AList);

 except
   on E: Exception do
    begin
     if Assigned(AList) then FreeAndNil(AList);
     //MessageDlg(self.ClassName + ': ' + E.Message, mtError, [mbOK],0);
    end;
 end;
end;

procedure TMercurioLogsController.RegisterRemoteCallFailure(const Message,
  ContextInfo: string);
begin
   RegisterLog(Message, ContextInfo, leOnMethodCallError);
end;

procedure TMercurioLogsController.RegisterRemoteCallSucess(const Message,
  ContextInfo: string);
begin
   RegisterLog(Message, ContextInfo, leOnMethodCall);
end;

procedure TMercurioLogsController.RegisterSucess(const Message: string);
begin
  inherited;
  RegisterLog(Message, '', leOnInformation);
end;

procedure TMercurioLogsController.RegisterWarning(const Message: string);
begin
  inherited;
  RegisterLog(Message, '', leOnWarning);
end;

procedure TMercurioLogsController.SetCurrentFile(const CurrentFile: string);
begin
 FCurrentFile := CurrentFile;
 if Assigned(AWriter) then
  AWriter.CurrentFile := CurrentFile;
end;

end.
