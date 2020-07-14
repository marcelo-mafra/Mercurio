unit classes.logs.factory;

interface

uses
 System.SysUtils, classes.logs.types, classes.logs.controller, client.resources.logs,
 client.resources.servicelabels, classes.logs.params;

type
  TFactoryLogs = class
    class function New(const IniFile: string): IMercurioLogs; overload;
    class function New(const IniFile, Folder, CurrentFile, AppName: string;
        MaxSize: integer): IMercurioLogs; overload;
  end;

implementation

type
{TFactoryLogsEvents � definido apenas na se��o "implementation" de forma a ficar
inacess�vel mesmo a partir de outras units que acessam essa.}
  TFactoryLogsEvents = class
    private
      FConfigurationFile: string;
    public
      constructor Create(const ConfigurationFile: string);
      destructor Destroy; override;
      procedure DoOnNewFileEvent(var NewFileName: string);
  end;

{ TClassFactory }

class function TFactoryLogs.New(const IniFile: string): IMercurioLogs;
var
 ConfObj: TLogsParams;
begin
{Retorna uma interface que abstrai recursos de gera��o de registros de logs para
 toda a aplica��o. Ser� necess�rio ler os par�metros no arquivo
 ini recebido em IniFile.}
 ConfObj := TLogsParams.Create(IniFile);
 Result := self.New(IniFile, ConfObj.Folder, ConfObj.CurrentFile, TServiceLabels.ServiceName,
   ConfObj.MaxFileSize);

end;

class function TFactoryLogs.New(const IniFile, Folder, CurrentFile, AppName: string;
  MaxSize: integer): IMercurioLogs;
var
 LogsObj: TMercurioLogsController;
 LogsEvents: TFactoryLogsEvents;
 FileExt: string;
begin
{Retorna uma interface que abstrai recursos de gera��o de registros de logs para
 toda a aplica��o. Nessa vers�o do m�todo n�o � necess�rio ler os par�metros
 pois todas as infos s�o recebidas pelo m�todo.}
 FileExt := client.resources.logs.TMercurioLogs.FileExtension;
 LogsEvents := TFactoryLogsEvents.Create(IniFile);
 LogsObj := TMercurioLogsController.Create(Folder, FileExt, TEncoding.UTF8);

 LogsObj.MaxFileSize := MaxSize;
 LogsObj.AppName := AppName;
 LogsObj.CurrentFile := CurrentFile;
 LogsObj.OnNewFile := LogsEvents.DoOnNewFileEvent;

 Result := LogsObj as IMercurioLogs;
end;

{ TFactoryLogsEvents }

constructor TFactoryLogsEvents.Create(const ConfigurationFile: string);
begin
 FConfigurationFile := ConfigurationFile
end;

destructor TFactoryLogsEvents.Destroy;
begin

  inherited;
end;

procedure TFactoryLogsEvents.DoOnNewFileEvent(var NewFileName: string);
var
 ConfigLogsObj: TLogsParams;
begin
 ConfigLogsObj := TLogsParams.Create(self.FConfigurationFile, False);

 try
  ConfigLogsObj.CurrentFile := NewFileName;
 finally
   FreeAndNil(ConfigLogsObj);
 end;
end;

end.
