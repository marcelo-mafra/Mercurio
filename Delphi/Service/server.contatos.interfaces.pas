unit server.contatos.interfaces;

interface

 uses
  System.Classes, server.common.interfaces, server.contatos.intf;

 type
   IContatosData = interface(IServerInterface)
     ['{E547214B-9180-4D62-8578-56C3B0455894}']
     function NewContato(const value: TMyContato): TMyContato;
     function GetMyContatos: UnicodeString;
     function ExcluirContato(const value: TMyContato): boolean;
   end;

 type
   IContatosController = interface(IServerInterface)
     ['{A4885B69-3D44-4DBA-8C6A-7905D3A94606}']
     function NewContato(const value: TMyContato): TMyContato;
     function GetMyContatos: UnicodeString;
     function ExcluirContato(const value: TMyContato): boolean;
   end;

implementation

end.
