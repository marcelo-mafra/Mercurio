unit client.interfaces.baseclasses;

interface

uses
 System.SysUtils, classes.logs, classes.logs.factory, client.resources.mercurio;

type
 MsgIdentifier = int64;

 //Classe abstrata usada como classe-base para diversas listas de objetos.
 TListaObjetos = class

   public
     procedure AddItem(value: TObject); virtual; abstract;
 end;

 //Classe usada como base que implementa a geração de logs do Mercúrio.
 TMercurioClass = class(TInterfacedObject)
   private
    FParamsFile: string;
    function GetMercurioLogs: IMercurioLogs;

   public
    constructor Create;
    destructor Destroy; override;

    property MercurioLogs: IMercurioLogs read GetMercurioLogs;
    property ParamsFile: string read FParamsFile;
 end;

implementation

{ TMercurioClass }

constructor TMercurioClass.Create;
begin
 inherited;
 FParamsFile := GetCurrentDir + '\' + TMercurioIniFile.ConfigFile;
end;

destructor TMercurioClass.Destroy;
begin
  inherited Destroy;
end;

function TMercurioClass.GetMercurioLogs: IMercurioLogs;
begin
 Result := TFactoryLogs.New(ParamsFile);
end;

end.
