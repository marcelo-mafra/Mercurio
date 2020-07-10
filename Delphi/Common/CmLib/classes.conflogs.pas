unit classes.conflogs;

interface

uses system.SysUtils, System.IniFiles, client.resources.mercurio,
 client.resources.logs;

type

  TLogsConfigurations = class
    strict private
     FConfigurationFile: string;
     FFolder: string;
     FCurrentFile: string;
     FMaxFileSize: integer;

     procedure LoadParameters;
     procedure SetCurrentFile(const NewFileName: string);

    public
     constructor Create(const ConfigurationFile: string);
     destructor Destroy; override;

     property CurrentFile: string read FCurrentFile write SetCurrentFile;
     property Folder: string read FFolder;
     property MaxFileSize: integer read FMaxFileSize;
  end;

implementation

{ TLogsConfigurations }

constructor TLogsConfigurations.Create(const ConfigurationFile: string);
begin
 FConfigurationFile := ConfigurationFile;
 LoadParameters;
end;

destructor TLogsConfigurations.Destroy;
begin
  inherited Destroy;
end;

procedure TLogsConfigurations.LoadParameters;
var
 ConfigFile: TIniFile;
begin
  ConfigFile := TIniFile.Create(FConfigurationFile);

    try
      FFolder := ConfigFile.ReadString(TMercurioIniFile.ConfigSection, TMercurioIniFile.ConfigFolder, '');
      FCurrentFile := ConfigFile.ReadString(TMercurioIniFile.ConfigSection, TMercurioIniFile.ConfigCurrentFile, '');
      CurrentFile := FCurrentFile;
      FMaxFileSize := ConfigFile.ReadInteger(TMercurioIniFile.ConfigSection, TMercurioIniFile.ConfigMaxFileSize, TMercurioIniFile.DefaultMaxSize);

    finally
      ConfigFile.Free;
    end;
end;

procedure TLogsConfigurations.SetCurrentFile(const NewFileName: string);
var
 ConfigFile: TIniFile;
begin
 if NewFileName.TrimRight = FCurrentFile.TrimRight then
  Exit;

  ConfigFile := TIniFile.Create(FConfigurationFile);

    try
      FCurrentFile := NewFileName;
      ConfigFile.WriteString(TMercurioIniFile.ConfigSection, TMercurioIniFile.ConfigCurrentFile, NewFileName);

    finally
      ConfigFile.Free;
    end;
end;

end.
