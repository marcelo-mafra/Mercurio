unit classes.logs.factory;

interface

uses
 System.SysUtils, classes.logs, classes.logs.controller, client.resources.logs,
 client.resources.servicelabels, classes.conflogs;

type
  TFactoryLogs = class
    class function New(const IniFile: string): IMercurioLogs; overload;
    class function New(const IniFile, Folder, CurrentFile, AppName: string;
        MaxSize: integer): IMercurioLogs; overload;
  end;

implementation

type
{TFactoryLogsEvents é definido apenas na seção "implementation" de forma a ficar
inacessível mesmo para outras units que acessam essa.}
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
 ConfObj: TLogsConfigurations;
begin
{Retorna uma interface que abstrai recursos de geração de registros de logs para
 toda a aplicação.}
 ConfObj := TLogsConfigurations.Create(IniFile);
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
{Retorna uma interface que abstrai recursos de geração de registros de logs para
 toda a aplicação.}
 FileExt := client.resources.logs.TMercurioLogs.FileExtension;
 LogsEvents := TFactoryLogsEvents.Create(IniFile);
 LogsObj := TMercurioLogsController.Create(Folder, FileExt, TEncoding.UTF8);

 with LogsObj do
  begin
   MaxFileSize := MaxSize;
   LogsObj.AppName := AppName;
   LogsObj.CurrentFile := CurrentFile;
   OnNewFile := LogsEvents.DoOnNewFileEvent;
  end;

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
 ConfigLogsObj: TLogsConfigurations;
begin
 ConfigLogsObj := TLogsConfigurations.Create(self.FConfigurationFile, False);

 try
  ConfigLogsObj.CurrentFile := NewFileName;
 finally
   FreeAndNil(ConfigLogsObj);
 end;
end;

end.
