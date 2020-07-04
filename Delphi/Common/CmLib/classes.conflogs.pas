unit classes.conflogs;

interface

uses system.SysUtils, System.IniFiles, client.resources.mercurio;

type

  TLogsConfigurations = class
    strict private
     FConfigurationFile: string;
     FLogFolder: string;
     FLogCurrentFile: string;
     FLogMaxFileSize: integer;

     procedure LoadParameters;
     procedure SetCurrentFile(const NewFileName: string);

    public
     constructor Create(const ConfigurationFile: string);
     destructor Destroy; override;

     property CurrentFile: string read FLogCurrentFile write SetCurrentFile;
     property Folder: string read FLogFolder;
     property MaxFileSize: integer read FLogMaxFileSize;
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
      FLogFolder := ConfigFile.ReadString(TMercurioConst.ConfigSection, TMercurioConst.ConfigFolder, '');
      FLogCurrentFile := ConfigFile.ReadString(TMercurioConst.ConfigSection, TMercurioConst.ConfigCurrentFile, '');
      CurrentFile := FLogCurrentFile;
      FLogMaxFileSize := ConfigFile.ReadInteger(TMercurioConst.ConfigSection, TMercurioConst.ConfigMaxFileSize, TMercurioConst.DefaultMaxSize);

    finally
      ConfigFile.Free;
    end;
end;

procedure TLogsConfigurations.SetCurrentFile(const NewFileName: string);
var
 ConfigFile: TIniFile;
begin
 if NewFileName.TrimRight = FLogCurrentFile.TrimRight then
  Exit;

  ConfigFile := TIniFile.Create(FConfigurationFile);

    try
      FLogCurrentFile := NewFileName;
      ConfigFile.WriteString(TMercurioConst.ConfigSection, TMercurioConst.ConfigCurrentFile, NewFileName);

    finally
      ConfigFile.Free;
    end;
end;

end.
