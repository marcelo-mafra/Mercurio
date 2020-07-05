unit classes.conflogs;

interface

uses system.SysUtils, System.IniFiles, client.resources.mercurio;

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
      FFolder := ConfigFile.ReadString(TMercurioConst.ConfigSection, TMercurioConst.ConfigFolder, '');
      FCurrentFile := ConfigFile.ReadString(TMercurioConst.ConfigSection, TMercurioConst.ConfigCurrentFile, '');
      CurrentFile := FCurrentFile;
      FMaxFileSize := ConfigFile.ReadInteger(TMercurioConst.ConfigSection, TMercurioConst.ConfigMaxFileSize, TMercurioConst.DefaultMaxSize);

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
      ConfigFile.WriteString(TMercurioConst.ConfigSection, TMercurioConst.ConfigCurrentFile, NewFileName);

    finally
      ConfigFile.Free;
    end;
end;

end.
