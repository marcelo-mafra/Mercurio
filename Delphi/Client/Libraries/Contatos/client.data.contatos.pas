unit client.data.contatos;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Stan.StorageBin, Data.Bind.DBScope, FireDAC.Stan.StorageJSON;

type
  TContatosData = class(TDataModule)
    dsContatos: TFDMemTable;
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(BindObject: TCustomBindSourceDB); reintroduce; overload;
    destructor  Destroy; override;
  end;

var
  ContatosData: TContatosData;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}



{ TContatosData }

constructor TContatosData.Create(BindObject: TCustomBindSourceDB);
begin
 inherited Create(nil);
 if BindObject <> nil then BindObject.DataSet := dsContatos;
 dsContatos.LoadFromFile('data.json', sfJson);
end;

destructor TContatosData.Destroy;
begin
  dsContatos.Close;
  inherited;
end;

end.
