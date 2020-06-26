unit client.interfaces.service;

interface

uses
 System.Classes, client.interfaces.common, client.interfaces.security;

type
 //Abstrai uma entidade de conjunto de informações sobre o serviço de chat.
 IChatServiceInfo = interface(IChatInterface)
   ['{8D2057A5-1471-45D2-99CE-BD9A48FE39DB}']
   function GetServiceName: string;
   function GetServiceHost: string;
   procedure GetServiceInfo(List: TStringList);

   property ServiceName: string read GetServiceName;
   property ServiceHost: string read GetServiceHost;
 end;

 //Abstrai o serviço remoto de chat.
 IChatService = interface(IChatInterface)
   ['{D706F737-D7DD-409F-9A7D-58D5B2323FA1}']
   function GetSecurityService: ISecurityService;
   function GetChatServiceInfo: IChatServiceInfo;

   function ConnectService: boolean;
   function DisconnectService: boolean;

   property Security: ISecurityService read GetSecurityService;
   property ServiceInfo: IChatServiceInfo read GetChatServiceInfo;
 end;

implementation

end.
