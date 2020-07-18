unit client.interfaces.security;

interface
{Cont�m interfaces que abstraem entidades relacionadas � seguran�a do servi�o
 remoto.}

uses
 client.interfaces.common;

type
 //Abstrai os recursos de seguran�a do servi�o remoto.
 ISecurityService = interface(IMercurioInterface)
   ['{8EA049BB-9398-4E7A-93B2-40791FF0B2D6}']

   function  Authenticate(const UserName, Password: string): boolean;
   procedure NewSessionId(const UserObj: string; var Session: string);
 end;


implementation

end.
