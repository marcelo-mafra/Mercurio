unit client.interfaces.contatos;

interface

uses
 System.Classes, client.interfaces.common, client.serverintf.contatos;

type

 //Abstrai uma entidade de conjunto de contatos.
 IContatosService = interface(IChatInterface)
  ['{BBDD349D-4BF8-4E04-9B51-B404A11B136E}']

  function  NewContato(Value: TMyContato): TMyContato;
  procedure GetMyContatos(List: TListaObjetos);
  function ExcluirContato(value: TMyContato): boolean;
 end;

implementation

end.
