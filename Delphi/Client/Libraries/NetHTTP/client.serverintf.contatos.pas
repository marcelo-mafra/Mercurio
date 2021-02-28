// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : http://localhost:8080/wsdl/IMercurioContatosServer
//  >Import : http://localhost:8080/wsdl/IMercurioContatosServer>0
// Version  : 1.0
// (27/02/2021 15:55:01 - - $Rev: 96726 $)
// ************************************************************************ //

unit client.serverintf.contatos;

interface

uses Soap.InvokeRegistry, Soap.SOAPHTTPClient, System.Types, Soap.XSBuiltIns,
     client.serverintf.soaputils;

type

  // ************************************************************************ //
  // The following types, referred to in the WSDL document are not being represented
  // in this file. They are either aliases[@] of other types represented or were referred
  // to but never[!] declared in the document. The types from the latter category
  // typically map to predefined/known XML or Embarcadero types; however, they could also
  // indicate incorrect WSDL documents that failed to declare or import a schema type.
  // ************************************************************************ //
  // !:double          - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:dateTime        - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:boolean         - "http://www.w3.org/2001/XMLSchema"[]
  // !:string          - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:int             - "http://www.w3.org/2001/XMLSchema"[Gbl]

  TMyContato          = class;                 { "urn:server.contatos.intf"[GblCplx] }
  TMyContatos         = class;                 { "urn:server.contatos.intf"[GblCplx] }

  TContatosArray = array of TMyContato;         { "urn:server.contatos.intf"[GblCplx] }

  // ************************************************************************ //
  // XML       : TMyContato, global, <complexType>
  // Namespace : urn:server.contatos.intf
  // ************************************************************************ //
  TMyContato = class(TRemotable)
  private
    FContatoId: string;
    FLastName: string;
    FFirstName: string;
    FStatus: Integer;
  published
    property ContatoId: string   read FContatoId write FContatoId;
    property LastName:  string   read FLastName write FLastName;
    property FirstName: string   read FFirstName write FFirstName;
    property Status:    Integer  read FStatus write FStatus;
  end;

  // ************************************************************************ //
  // XML       : TMyContatos, global, <complexType>
  // Namespace : urn:server.contatos.intf
  // ************************************************************************ //
  TMyContatos = class(TRemotable)
  private
    FContentText: string;
    FMessageId: Double;
    FRegisteredTime: TXSDateTime;
    FSenderUser: string;
    FContatos: TContatosArray;
  public
    destructor Destroy; override;
  published
    property ContentText:    string          read FContentText write FContentText;
    property MessageId:      Double          read FMessageId write FMessageId;
    property RegisteredTime: TXSDateTime     read FRegisteredTime write FRegisteredTime;
    property SenderUser:     string          read FSenderUser write FSenderUser;
    property Contatos:       TContatosArray  read FContatos write FContatos;
  end;

 // TDoubleArray = array of Double;               { "urn:server.contatos.intf"[GblCplx] }

  // ************************************************************************ //
  // Namespace : urn:server.contatos.intf-IMercurioContatosServer
  // soapAction: urn:server.contatos.intf-IMercurioContatosServer#%operationName%
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : rpc
  // use       : encoded
  // binding   : IMercurioContatosServerbinding
  // service   : IMercurioContatosServerservice
  // port      : IMercurioContatosServerPort
  // URL       : http://localhost:8080/soap/IMercurioContatosServer
  // ************************************************************************ //
  IMercurioContatosServer = interface(IInvokable)
  ['{1F1A5787-1252-DA26-30CB-517FCD59E6B9}']
    function  NewContato(const Value: TMyContato): TMyContato; stdcall;
    function  GetMyContatos: string; stdcall;
    function  ExcluirContato(const value: TMyContato): Boolean; stdcall;
    function  AsObjects: TMyContatos; stdcall;
  end;

function GetIMercurioContatosServer(UseWSDL: Boolean=System.False;
   Addr: string = ''; HTTPRIO: THTTPRIO = nil): IMercurioContatosServer;


implementation

  uses System.SysUtils;

function GetIMercurioContatosServer(UseWSDL: Boolean; Addr: string;
    HTTPRIO: THTTPRIO): IMercurioContatosServer;
const
  defWSDL = 'http://localhost:8080/wsdl/IMercurioContatosServer';
  defURL  = 'http://localhost:8080/soap/IMercurioContatosServer';
  defSvc  = 'IMercurioContatosServerservice';
  defPrt  = 'IMercurioContatosServerPort';
var
  RIO: THTTPRIO;
begin
  Result := nil;

  if (Addr = '') then
  begin
    if UseWSDL then Addr := defWSDL
    else
      Addr := defURL;
  end;
  if HTTPRIO = nil then
    RIO := THTTPRIO.Create(nil)
  else
    RIO := HTTPRIO;
  try
    RIO.OnAfterExecute := TSOAPEvents.DoAfterExecuteEvent;
    RIO.HTTPWebNode.UserName :=  '';
    RIO.HTTPWebNode.Password := '';

    Result := (RIO as IMercurioContatosServer);

    if UseWSDL then
    begin
      RIO.WSDLLocation := Addr;
      RIO.Service := defSvc;
      RIO.Port := defPrt;
    end
    else
      RIO.URL := Addr;

  finally
    if (Result = nil) and (HTTPRIO = nil) then
      RIO.Free;
  end;
end;

destructor TMyContatos.Destroy;
var
  I: Integer;
begin
  for I := 0 to System.Length(FContatos)-1 do
    System.SysUtils.FreeAndNil(FContatos[I]);
  System.SetLength(FContatos, 0);
  System.SysUtils.FreeAndNil(FRegisteredTime);
  inherited Destroy;
end;


initialization
  { IMercurioContatosServer }
  InvRegistry.RegisterInterface(TypeInfo(IMercurioContatosServer), 'urn:server.contatos.intf-IMercurioContatosServer', '');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(IMercurioContatosServer), 'urn:server.contatos.intf-IMercurioContatosServer#%operationName%');
  RemClassRegistry.RegisterXSInfo(TypeInfo(TContatosArray), 'urn:server.contatos.intf', 'TContatosArray');
  RemClassRegistry.RegisterXSClass(TMyContato, 'urn:server.contatos.intf', 'TMyContato');
  RemClassRegistry.RegisterXSClass(TMyContatos, 'urn:server.contatos.intf', 'TMyContatos');

end.