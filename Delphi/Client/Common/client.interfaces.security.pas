unit client.interfaces.security;

interface
{Cont�m interfaces que abstraem entidades relacionadas � seguran�a do servi�o
 remoto.}

uses
 client.interfaces.common;

type
 //Abstrai os recursos de seguran�a do servi�o remoto.
 ISecurityService = interface(IChatInterface)
   ['{8EA049BB-9398-4E7A-93B2-40791FF0B2D6}']

   function  Authenticate(const UserName, Password: string): boolean;
 end;


implementation

end.
