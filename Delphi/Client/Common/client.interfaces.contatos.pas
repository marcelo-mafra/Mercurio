unit client.interfaces.contatos;

interface

uses
 System.Classes, client.interfaces.common, client.interfaces.baseclasses,
 client.serverintf.contatos, Data.DB;

type
 //Define que a listagem será feita por meio de datasets ou listas de objetos.
 TTransformModel = (tmDataset, tmListObject);

 //Tipo que define um evento de inserção de um novo contato.
 TNewContatoNotifyEvent = procedure(value: TMyContato) of object;
 //Define um evento de exclusão de um contato.
 TDeleteContatoNotifyEvent = procedure of object;

 //Abstrai uma entidade de conjunto de contatos.
 IContatoService = interface(IChatInterface)
  ['{AC376710-F60A-4440-B2CB-23A34CC5D684}']
  function NewContato(Value: TMyContato): TMyContato;
  function ExcluirContato(value: TMyContato): boolean;
 end;

 //Abstrai uma entidade de conjunto de contatos.
 IContatosService = interface(IChatInterface)
  ['{BBDD349D-4BF8-4E04-9B51-B404A11B136E}']
  //function  NewContato(Value: TMyContato): TMyContato;
  function GetIContato: IContatoService;
  procedure GetMyContatos(List: TListaObjetos); overload;
  procedure GetMyContatos(Dataset: TDataset); overload;
  //function ExcluirContato(value: TMyContato): boolean;
  property IContato: IContatoService read GetIContato;
 end;

implementation

end.
