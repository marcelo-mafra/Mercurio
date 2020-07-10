unit client.resources.mercurio;

interface

uses
  System.SysUtils;

type
  //General consts
  TMercurioApp = class
    const
      AppName           = 'Mercúrio';
  end;

  //Mercurio inifile consts
  TMercurioIniFile = class
    const
      ConfigFile        = 'mercurio.ini';
      ConfigSection     = 'LOGS';
      ConfigFolder      = 'LogsFolder';
      ConfigCurrentFile = 'CurrentFile';
      ConfigMaxFileSize = 'MaxSize';
      DefaultMaxSize    = 524288;
  end;

  //User interface consts
  TMercurioUI = class
    const
      ListBoxItemStyle  = 'listboxitembottomdetail';
  end;

implementation

end.
