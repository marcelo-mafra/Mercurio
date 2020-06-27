// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : http://localhost:8080/wsdl/IMercurioChatServer
//  >Import : http://localhost:8080/wsdl/IMercurioChatServer>0
// Version  : 1.0
// (26/06/2020 16:07:39 - - $Rev: 96726 $)
// ************************************************************************ //

unit client.chatservice.serverintf;

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

  TMyEmployee          = class;                 { "urn:server.chatserver.intf"[GblCplx] }

  {$SCOPEDENUMS ON}
  { "urn:server.chatserver.intf"[GblSmpl] }
  TEnumTest = (etNone, etAFew, etSome, etAlot);

  {$SCOPEDENUMS OFF}



  // ************************************************************************ //
  // XML       : TMyEmployee, global, <complexType>
  // Namespace : urn:server.chatserver.intf
  // ************************************************************************ //
  TMyEmployee = class(TRemotable)
  private
    FLastName: string;
    FFirstName: string;
    FSalary: Double;
  published
    property LastName:  string  read FLastName write FLastName;
    property FirstName: string  read FFirstName write FFirstName;
    property Salary:    Double  read FSalary write FSalary;
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
  IMercurioChatServer = interface(IInvokable)
  ['{7E9EAD9B-368B-78B9-3C05-A051F80AAA56}']
    function  echoEnum(const Value: TEnumTest): TEnumTest; stdcall;
    function  echoDoubleArray(const Value: TDoubleArray): TDoubleArray; stdcall;
    function  echoMyEmployee(const Value: TMyEmployee): TMyEmployee; stdcall;
    function  echoDouble(const Value: Double): Double; stdcall;
    function  ServiceInfo: string; stdcall;
  end;

function GetIMercurioChatServer(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): IMercurioChatServer;


implementation
  uses System.SysUtils;

function GetIMercurioChatServer(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): IMercurioChatServer;
const
  defWSDL = 'http://localhost:8080/wsdl/IMercurioChatServer';
  defURL  = 'http://localhost:8080/soap/IMercurioChatServer';
  defSvc  = 'IMercurioChatServerservice';
  defPrt  = 'IMercurioChatServerPort';
var
  RIO: THTTPRIO;
begin
  Result := nil;
  if (Addr = '') then
  begin
    if UseWSDL then
      Addr := defWSDL
    else
      Addr := defURL;
  end;
  if HTTPRIO = nil then
    RIO := THTTPRIO.Create(nil)
  else
    RIO := HTTPRIO;
  try
    Result := (RIO as IMercurioChatServer);
    if UseWSDL then
    begin
      RIO.WSDLLocation := Addr;
      RIO.Service := defSvc;
      RIO.Port := defPrt;
    end else
      RIO.URL := Addr;
  finally
    if (Result = nil) and (HTTPRIO = nil) then
      RIO.Free;
  end;
end;


initialization
  { IMercurioChatServer }
  InvRegistry.RegisterInterface(TypeInfo(IMercurioChatServer), 'urn:server.chatserver.intf-IMercurioChatServer', '');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(IMercurioChatServer), 'urn:server.chatserver.intf-IMercurioChatServer#%operationName%');
  RemClassRegistry.RegisterXSInfo(TypeInfo(TEnumTest), 'urn:server.chatserver.intf', 'TEnumTest');
  RemClassRegistry.RegisterXSClass(TMyEmployee, 'urn:server.chatserver.intf', 'TMyEmployee');
  RemClassRegistry.RegisterXSInfo(TypeInfo(TDoubleArray), 'urn:server.chatserver.intf', 'TDoubleArray');

end.