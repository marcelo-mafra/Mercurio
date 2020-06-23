unit client.interfaces.security;

interface
{Contém interfaces que abstraem entidades relacionadas à segurança do serviço
 remoto.}

uses
 client.interfaces.common;

type
 //Abstrai os recursos de segurança do serviço remoto.
 ISecurityService = interface(IChatInterface)
   ['{8EA049BB-9398-4E7A-93B2-40791FF0B2D6}']

   function  Authenticate(const UserName, Password: string): boolean;
 end;


implementation

end.
