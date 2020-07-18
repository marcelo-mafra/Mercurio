unit client.interfaces.security;

interface
{Contém interfaces que abstraem entidades relacionadas à segurança do serviço
 remoto.}

uses
 client.interfaces.common;

type
 //Abstrai os recursos de segurança do serviço remoto.
 ISecurityService = interface(IMercurioInterface)
   ['{8EA049BB-9398-4E7A-93B2-40791FF0B2D6}']

   function  Authenticate(const UserName, Password: string): boolean;
   procedure NewSessionId(const UserObj: string; var Session: string);
 end;


implementation

end.
