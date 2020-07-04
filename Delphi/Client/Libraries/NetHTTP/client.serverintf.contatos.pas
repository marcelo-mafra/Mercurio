// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : http://localhost:8080/wsdl/IMercurioChatServer
//  >Import : http://localhost:8080/wsdl/IMercurioChatServer>0
// Version  : 1.0
// (26/06/2020 16:07:39 - - $Rev: 96726 $)
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
  // !:string          - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:double          - "http://www.w3.org/2001/XMLSchema"[Gbl]

  TMyContato          = class;                 { "urn:server.contatos.intf"[GblCplx] }
  TMyContatos         = class;                 { "urn:server.contatos.intf"[GblCplx] }

  // ************************************************************************ //
  // XML       : TMyContato, global, <complexType>
  // Namespace : urn:server.contatos.intf
  // ************************************************************************ //
  TMyContato = class(TRemotable)
  private
    FContatoId: integer;
    FLastName: UnicodeString;
    FFirstName: UnicodeString;

  published
    property ContatoId: integer read FContatoId write FContatoId;
    property LastName:  UnicodeString  read FLastName write FLastName;
    property FirstName: UnicodeString  read FFirstName write FFirstName;

  end;

  // ************************************************************************ //
  // XML       : TMyContatos, global, <complexType>
  // Namespace : urn:server.contatos.intf
  // ************************************************************************ //
  TMyContatos = class(TRemotable)
  private
    FContentText, FSenderUser: UnicodeString;
    FMessageId: double;
    FRegisteredTime: TDateTime;

  published
    property ContentText: UnicodeString read FContentText write FContentText;
    property MessageId: double read FMessageId write FMessageId;
    property SenderUser: UnicodeString read FSenderUser write FSenderUser;
    property RegisteredTime: TDateTime read FRegisteredTime write FRegisteredTime;
  end;

  TDoubleArray = array of Double;               { "urn:server.contatos.intf"[GblCplx] }

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
  ['{AE65F833-C137-487E-96F9-037DA184BD4F}']

    function  NewContato(const Value: TMyContato): TMyContato; stdcall;
    function  GetMyContatos: UnicodeString; stdcall;
    function ExcluirContato(value: TMyContato): boolean; stdcall;

  end;

  function GetIMercurioContatosServer(UseWSDL: Boolean = System.False; Addr: string = '';
             HTTPRIO: THTTPRIO = nil): IMercurioContatosServer;


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


initialization
  { IMercurioChatServer }
  InvRegistry.RegisterInterface(TypeInfo(IMercurioContatosServer), 'urn:server.contatos.intf-IMercurioContatosServer', '');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(IMercurioContatosServer), 'urn:server.contatos.intf-IMercurioContatosServer#%operationName%');
  RemClassRegistry.RegisterXSInfo(TypeInfo(TDoubleArray), 'urn:server.contatos.intf', 'TDoubleArray');
  //-----------
  RemClassRegistry.RegisterXSClass(TMyContato, 'urn:server.contatos.intf', 'TMyContato');
  RemClassRegistry.RegisterXSClass(TMyContatos, 'urn:server.contatos.intf', 'TMyContatos');

end.