unit client.interfaces.service;

interface
{Cont�m interfaces que abstraem entidades relacionadas ao servi�o remoto de chat.}

uses
 client.interfaces.common, client.interfaces.security;

type
 //Abstrai o servi�o remoto de chat.
 IChatService = interface(IChatInterface)
   ['{D706F737-D7DD-409F-9A7D-58D5B2323FA1}']
   function GetConnected: boolean;
   function GetSecurityService: ISecurityService;

   function  ConnectService: boolean;
   procedure DisconnectService;

   property Connected: boolean read GetConnected;
   property SecurityService: ISecurityService read GetSecurityService;
 end;

implementation

end.
