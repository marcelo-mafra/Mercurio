unit client.resources.mercurio;

interface

uses
  System.SysUtils;

type
  TMercurioConst = class
    const
      ConfigFile        = 'mercurio.ini';
      ConfigSection     = 'LOGS';
      ConfigFolder      = 'LogsFolder';
      ConfigCurrentFile = 'CurrentFile';
      ConfigMaxFileSize = 'MaxSize';
      DefaultMaxSize    = 524288;
  end;

implementation

end.
