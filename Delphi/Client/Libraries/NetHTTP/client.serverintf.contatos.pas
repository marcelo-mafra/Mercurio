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

uses Soap.InvokeRegistry, Soap.SOAPHTTPClient, System.Types, Soap.XSBuiltIns;

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

  TMyContato          = class;                 { "urn:server.chatserver.intf"[GblCplx] }
  TMyContatos         = class;                 { "urn:server.chatserver.intf"[GblCplx] }


  // ************************************************************************ //
  // XML       : TMyContato, global, <complexType>
  // Namespace : urn:server.chatserver.intf
  // ************************************************************************ //
  TMyContato = class(TRemotable)
  private
    FLastName: string;
    FFirstName: string;

  published
    property LastName:  string  read FLastName write FLastName;
    property FirstName: string  read FFirstName write FFirstName;

  end;

  // ************************************************************************ //
  // XML       : TChatMessage, global, <complexType>
  // Namespace : urn:server.chatserver.intf
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

  TDoubleArray = array of Double;               { "urn:server.chatserver.intf"[GblCplx] }

  // ************************************************************************ //
  // Namespace : urn:server.chatserver.intf-IMercurioChatServer
  // soapAction: urn:server.chatserver.intf-IMercurioChatServer#%operationName%
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : rpc
  // use       : encoded
  // binding   : IMercurioChatServerbinding
  // service   : IMercurioChatServerservice
  // port      : IMercurioChatServerPort
  // URL       : http://localhost:8080/soap/IMercurioChatServer
  // ************************************************************************ //
  IMercurioContatosServer = interface(IInvokable)
  ['{59533F8F-83C8-4145-8CE6-B3AF1A28FB61}']

    function  NewContato(const Value: TMyContato): TMyContato; stdcall;
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
  InvRegistry.RegisterInterface(TypeInfo(IMercurioContatosServer), 'urn:server.chatserver.intf-IMercurioContatosServer', '');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(IMercurioContatosServer), 'urn:server.chatserver.intf-IMercurioContatosServer#%operationName%');
  RemClassRegistry.RegisterXSInfo(TypeInfo(TDoubleArray), 'urn:server.chatserver.intf', 'TDoubleArray');
  //-----------
  RemClassRegistry.RegisterXSClass(TMyContato, 'urn:server.chatserver.intf', 'TMyContato');
  RemClassRegistry.RegisterXSClass(TMyContatos, 'urn:server.chatserver.intf', 'TMyContatos');

end.