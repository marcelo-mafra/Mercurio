unit client.interfaces.connection;

interface

uses
 System.Classes, System.SysUtils, client.interfaces.common, client.interfaces.security;

type
 //Abstrai uma entidade de conjunto de informações sobre o serviço de chat.
 IServiceInfo = interface(IMercurioInterface)
   ['{8D2057A5-1471-45D2-99CE-BD9A48FE39DB}']
   function GetServiceName: string;
   function GetServiceHost: string;
   procedure GetServiceInfo(List: TStringList);

   property ServiceName: string read GetServiceName;
   property ServiceHost: string read GetServiceHost;
 end;

 //Abstraem eventos de conexão e desconexão com o serviço remoto.
 TOnConnectEvent      = procedure (Sender: TObject) of object;
 TOnConnectErrorEvent = procedure (Sender: TObject; E: Exception) of object;
 TOnDisconnectEvent   = procedure (Sender: TObject) of object;

 //It abstracts the connection to the remote service.
 IServiceConnection = interface(IMercurioInterface)
   ['{D84CE4EA-7FD3-45A6-8A4E-05A48B4E137D}']
   function GetSecurityService: ISecurityService;
   function GetServiceInfo: IServiceInfo;
   function GetConnected: boolean;
   procedure SetConnected(const Value: boolean);

   function ConnectService: boolean;
   procedure DisconnectService;

   property Connected: boolean read GetConnected write SetConnected;
   property Security: ISecurityService read GetSecurityService;
   property ServiceInfo: IServiceInfo read GetServiceInfo;
 end;



implementation

end.
