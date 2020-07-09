unit client.interfaces.contatos;

interface

uses
 System.Classes, client.interfaces.common, client.interfaces.baseclasses,
 client.serverintf.contatos, Data.DB;

type

 //Abstrai uma entidade de conjunto de contatos.
 IContatosService = interface(IChatInterface)
  ['{BBDD349D-4BF8-4E04-9B51-B404A11B136E}']
  function  NewContato(Value: TMyContato): TMyContato;
  procedure GetMyContatos(List: TListaObjetos); overload;
  procedure GetMyContatos(Dataset: TDataset); overload;
  function ExcluirContato(value: TMyContato): boolean;
 end;

implementation

end.
