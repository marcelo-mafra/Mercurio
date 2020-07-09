unit client.data.contatos;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Stan.StorageBin;

type
  TContatosData = class(TDataModule)
    dsContatos: TFDMemTable;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ContatosData: TContatosData;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}



end.
