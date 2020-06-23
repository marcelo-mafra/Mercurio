unit mercurio.client.interfaces.service;

interface
{Cont�m interfaces que abstraem entidades relacionadas � seguran�a do servi�o
 remoto e ao servi�o remoto de chat em si.}

uses
 mercurio.client.interfaces.common;

type
 //Abstrai os recursos de seguran�a do servi�o remoto.
 ISecurityService = interface(IChatInterface)

   function  Authenticate(const UserName, Password: string): boolean;
 end;

 //Abstrai o servi�o remoto de chat.
 IChatService = interface(IChatInterface)
   function GetSecurityService: ISecurityService;

   function  ConnectService: boolean;
   procedure DisconnectService;

   property SecurityService: ISecurityService read GetSecurityService;
 end;

implementation

end.
