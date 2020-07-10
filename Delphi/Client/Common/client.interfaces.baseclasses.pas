unit client.interfaces.baseclasses;

interface

uses
 System.SysUtils, classes.logs, classes.logs.controller, classes.conflogs,
 client.resources.mercurio, client.resources.servicelabels,
 client.resources.logs;

type
 MsgIdentifier = int64;

 //Classe abstrata usada como classe-base para diversas listas de objetos.
 TListaObjetos = class
   private

   public
     procedure AddItem(value: TObject); virtual; abstract;
 end;

 //Classe usada como base que implementa a gera��o de logs do Merc�rio.
 TMercurioClass = class(TInterfacedObject)
   private
    FConfObj: TLogsConfigurations;
    function GetMercurioLogs: IMercurioLogs;
    procedure DoOnNewFileEvent(var NewFileName: string);

   public
    constructor Create;
    destructor Destroy; override;

    property ConfObj: TLogsConfigurations read FConfObj;
    property MercurioLogs: IMercurioLogs read GetMercurioLogs;
 end;

implementation

{ TMercurioClass }

constructor TMercurioClass.Create;
begin
 inherited;
 FConfObj := TLogsConfigurations.Create(GetCurrentDir + '\' + TMercurioIniFile.ConfigFile);
end;

destructor TMercurioClass.Destroy;
begin
  FConfObj.Free;
  inherited Destroy;
end;

function TMercurioClass.GetMercurioLogs: IMercurioLogs;
var
 LogsObj: TMercurioLogsController;
 Events: TLogEvents;
 FileExt: string;
begin
 Events := [leOnError, leOnAuthenticateSucess, leOnAuthenticateFail, leOnInformation,
            leOnWarning, leOnConnect, leOnConnectError, leOnMethodCall,
            leOnMethodCallError, leUnknown];
 FileExt := client.resources.logs.TMercurioLogs.FileExtension;
 LogsObj := TMercurioLogsController.Create(ConfObj.Folder, FileExt, TEncoding.UTF8, Events);

 LogsObj.MaxFileSize := ConfObj.MaxFileSize;
 LogsObj.AppName := TServiceLabels.ServiceName;
 LogsObj.CurrentFile := ConfObj.CurrentFile;
 LogsObj.OnNewFile := DoOnNewFileEvent;

 Result := LogsObj as IMercurioLogs;
end;

procedure TMercurioClass.DoOnNewFileEvent(var NewFileName: string);
begin
{M�todo que aponta para o evento TMercurioLogsController.OnNewFile, disparado sempre que
 o arquivo de logs atinge o tamanho m�ximo e se cria um novo para ser usado. Nesse
 caso, � necess�rio registrar isso no .ini para que na pr�xima execu��o do cliente
 o uso deste arquivo seja retomado (at� atingir o tamanho m�ximo definido).}
  ConfObj.CurrentFile := NewFileName;
end;

end.
