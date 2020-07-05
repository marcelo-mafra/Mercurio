unit client.resources.mercurio;

interface

uses
  System.SysUtils;

type
  //General consts
  TMercurioConst = class
    const
      ConfigFile        = 'mercurio.ini';
      ConfigSection     = 'LOGS';
      ConfigFolder      = 'LogsFolder';
      ConfigCurrentFile = 'CurrentFile';
      ConfigMaxFileSize = 'MaxSize';
      DefaultMaxSize    = 524288;
  end;

  //Logs consts
  TMercurioLogs = class
    const
      FileExtension = '.log';
  end;

  //User interface consts
  TMercurioUI = class
    const
      ListBoxItemStyle  = 'listboxitembottomdetail';
  end;

implementation

end.
