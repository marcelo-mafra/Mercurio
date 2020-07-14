unit classes.logs.params;

interface

uses system.SysUtils, System.IniFiles, client.resources.mercurio,
 client.resources.logs;

type

  TLogsParams = class
    strict private
     FConfigurationFile: string;
     FFolder: string;
     FCurrentFile: string;
     FMaxFileSize: integer;

     procedure LoadParameters;
     procedure SetCurrentFile(const NewFileName: string);

    public
     constructor Create(const ConfigurationFile: string; LoadParams: boolean = True);
     destructor Destroy; override;

     property CurrentFile: string read FCurrentFile write SetCurrentFile;
     property Folder: string read FFolder;
     property MaxFileSize: integer read FMaxFileSize;
  end;

implementation

{ TLogsParams }

constructor TLogsParams.Create(const ConfigurationFile: string;
   LoadParams: boolean = True);
begin
 FConfigurationFile := ConfigurationFile;
 if LoadParams then LoadParameters;
end;

destructor TLogsParams.Destroy;
begin
  inherited Destroy;
end;

procedure TLogsParams.LoadParameters;
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

procedure TLogsParams.SetCurrentFile(const NewFileName: string);
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
