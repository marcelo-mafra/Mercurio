unit client.interfaces.contatos;

interface

uses
 System.Classes, client.interfaces.common, client.interfaces.baseclasses,
 client.serverintf.contatos, Data.DB;

type
 //Define que a listagem ser� feita por meio de datasets ou listas de objetos.
 TTransformModel = (tmDataset, tmListObject);

 //Tipo que define um evento de inser��o de um novo contato.
 TNewContatoNotifyEvent = procedure(value: TMyContato) of object;
 //Define um evento de exclus�o de um contato.
 TDeleteContatoNotifyEvent = procedure of object;

 //It abstracts the entity for a contact.
 IContactService = interface(IMercurioInterface)
  ['{AC376710-F60A-4440-B2CB-23A34CC5D684}']
  function NewContato(Value: TMyContato): TMyContato;
  function ExcluirContato(value: TMyContato): boolean;
 end;

 //It abstracts the entity for a set of contacts.
 IContactsService = interface(IMercurioInterface)
  ['{BBDD349D-4BF8-4E04-9B51-B404A11B136E}']
  function GetIContact: IContactService;
  procedure GetMyContatos(List: TListaObjetos); overload;
  procedure GetMyContatos(Dataset: TDataset); overload;

  property IContact: IContactService read GetIContact;
 end;

implementation

end.
