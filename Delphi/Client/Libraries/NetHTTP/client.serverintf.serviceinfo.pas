// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : http://localhost:8080/wsdl/IMercurioServiceInfo
//  >Import : http://localhost:8080/wsdl/IMercurioServiceInfo>0
// Version  : 1.0
// (26/06/2020 16:07:39 - - $Rev: 96726 $)
// ************************************************************************ //

unit client.serverintf.serviceinfo;

interface

uses Soap.InvokeRegistry, Soap.SOAPHTTPClient, System.Types, Soap.XSBuiltIns,
client.serverintf.soaputils, System.SysUtils;

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

  TServiceInfo          = class;                 { "urn:server.serviceinfo.intf"[GblCplx] }

  // ************************************************************************ //
  // XML       : TServiceInfo, global, <complexType>
  // Namespace : urn:server.serviceinfo.intf
  // ************************************************************************ //
  TServiceInfo = class(TRemotable)
  private
    FServiceName: string;
    FHost: string;
    FServerTime: TDateTime;
  published
    property ServiceName: string read FServiceName write FServiceName;
    property Host: string read FHost write FHost;
    property ServerTime: TDateTime read FServerTime write FServerTime;
  end;

  // ************************************************************************ //
  // Namespace : urn:server.serviceinfo.intf-IMercurioServiceInfo
  // soapAction: urn:server.serviceinfo.intf-IMercurioServiceInfo#%operationName%
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : rpc
  // use       : encoded
  // binding   : IMercurioServiceInfoServerbinding
  // service   : IMercurioServiceInfoServerservice
  // port      : IMercurioServiceInfoServerPort
  // URL       : http://localhost:8080/soap/IMercurioServiceInfo
  // ************************************************************************ //
  IMercurioServiceInfo = interface(IInvokable)
  ['{66CA08AE-AF08-4B3C-8C53-43B0A5E4B932}']
    function  ServiceInfo: TServiceInfo; stdcall;
  end;

function GetIMercurioServiceInfo(UseWSDL: Boolean = System.False; Addr: string = '';
             HTTPRIO: THTTPRIO = nil): IMercurioServiceInfo;


implementation


function GetIMercurioServiceInfo(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): IMercurioServiceInfo;
const
  defWSDL = 'http://localhost:8080/wsdl/IMercurioServiceInfo';
  defURL  = 'http://localhost:8080/soap/IMercurioServiceInfo';
  defSvc  = 'IMercurioServiceInfoservice';
  defPrt  = 'IMercurioServiceInfoPort';
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

    Result := (RIO as IMercurioServiceInfo);

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
  { IMercurioServiceInfo }
  InvRegistry.RegisterInterface(TypeInfo(IMercurioServiceInfo), 'urn:server.serviceinfo.intf-IMercurioServiceInfo', '');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(IMercurioServiceInfo), 'urn:server.serviceinfo.intf-IMercurioServiceInfo#%operationName%');
  RemClassRegistry.RegisterXSClass(TServiceInfo, 'urn:server.serviceinfo.intf', 'TServiceInfo');

end.
