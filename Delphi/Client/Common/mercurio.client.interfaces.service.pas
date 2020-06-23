unit mercurio.client.interfaces.service;

interface
{Contém interfaces que abstraem entidades relacionadas à segurança do serviço
 remoto e ao serviço remoto de chat em si.}

uses
 mercurio.client.interfaces.common;

type
 //Abstrai os recursos de segurança do serviço remoto.
 ISecurityService = interface(IChatInterface)

   function  Authenticate(const UserName, Password: string): boolean;
 end;

 //Abstrai o serviço remoto de chat.
 IChatService = interface(IChatInterface)
   function GetSecurityService: ISecurityService;

   function  ConnectService: boolean;
   procedure DisconnectService;

   property SecurityService: ISecurityService read GetSecurityService;
 end;

implementation

end.
