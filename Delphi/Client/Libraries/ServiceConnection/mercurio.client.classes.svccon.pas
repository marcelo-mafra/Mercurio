unit mercurio.client.classes.svccon;

interface

uses
  System.SysUtils, REST.Client, mercurio.client.interfaces.service,
  mercurio.client.svcconsts, mercurio.client.classes.security;

 type
   {Classe que encapsula as funcionalidades de conexão com o serviço remoto.}
   TChatService = class(TInterfacedObject, IChatService)
     private
       FServiceObj: TRestClient;
       FSecurityObj: TSecurityService;
       FServiceHost, FServiceName: string;
       function GetSecurityService: ISecurityService;

     public
       constructor Create;
       destructor Destroy; override;

       //IChatService
       function  ConnectService: boolean;
       procedure DisconnectService;

       property ServiceHost: string read FServiceHost;
       property ServiceName: string read FServiceName;
       //IChatService
       property SecuritySvc: ISecurityService read GetSecurityService;
   end;

implementation

{ TChatMessagesService }

function TChatService.ConnectService: boolean;
begin
 Result := True;
end;

constructor TChatService.Create;
begin
  FServiceName := TChatServiceConst.ServiceName;
  FServiceHost := TChatServiceConst.ServiceHost;

  FSecurityObj := TSecurityService.Create;
  FServiceObj := TRESTClient.Create('');
  FServiceObj.BaseURL := ServiceHost;
end;

destructor TChatService.Destroy;
begin
  if Assigned(FServiceObj) then FreeAndNil(FServiceObj);
  if Assigned(FSecurityObj) then FreeAndNil(FSecurityObj);

  inherited;
end;

procedure TChatService.DisconnectService;
begin
 FServiceObj.Disconnect;
end;

function TChatService.GetSecurityService: ISecurityService;
begin
 Result :=  FSecurityObj as ISecurityService;
end;

end.
