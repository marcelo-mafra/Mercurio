unit client.interfaces.contatos;

interface

uses
 System.Classes, client.interfaces.common;

type
 //Abstrai uma entidade de conjunto de informa��es sobre o servi�o de chat.
 IContatosService = interface(IChatInterface)
  ['{BBDD349D-4BF8-4E04-9B51-B404A11B136E}']
  function  NewContato: boolean;//(const Value: TMyContato): TMyContato;
 end;

implementation

end.
