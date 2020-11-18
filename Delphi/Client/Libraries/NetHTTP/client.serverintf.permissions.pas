// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : http://localhost:8080/wsdl/IMercurioPermissionsServer
// Version  : 1.0
// (24/10/2020 14:22:37 - - $Rev: 96726 $)
// ************************************************************************ //

unit client.serverintf.permissions;

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
  // !:boolean         - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:string          - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:int             - "http://www.w3.org/2001/XMLSchema"[Gbl]

  TMyPermissions       = class;                 { "urn:server.permissions.intf"[GblCplx] }
  TMyPermission        = class;                 { "urn:server.permissions.intf"[GblCplx] }

  TPermissionsArray = array of TMyPermission;   { "urn:server.permissions.intf"[GblCplx] }

  // ************************************************************************ //
  // XML       : TMyPermissions, global, <complexType>
  // Namespace : urn:server.permissions.intf
  // ************************************************************************ //
  TMyPermissions = class(TRemotable)
  private
    FPermissions: TPermissionsArray;
  public
    destructor Destroy; override;
  published
    property Permissions: TPermissionsArray  read FPermissions write FPermissions;
  end;

  // ************************************************************************ //
  // Namespace : urn:server.permissions.intf-IMercurioPermissionsServer
  // soapAction: urn:server.permissions.intf-IMercurioPermissionsServer#GetMyPermissions
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : rpc
  // use       : encoded
  // binding   : IMercurioPermissionsServerbinding
  // service   : IMercurioPermissionsServerservice
  // port      : IMercurioPermissionsServerPort
  // URL       : http://localhost:8080/soap/IMercurioPermissionsServer
  // ************************************************************************ //

  // ************************************************************************ //
  // XML       : TMyPermission, global, <complexType>
  // Namespace : urn:server.permissions.intf
  // ************************************************************************ //

 TMyPermission = class(TRemotable)
  private
    FFeatureId: integer;
    FFeatureName: UnicodeString;
    FUsuario: UnicodeString;
    FEnabled: boolean;

  published
    property FeatureId: integer read FFeatureId write FFeatureId;
    property FeatureName: UnicodeString read FFeatureName write FFeatureName;
    property Usuario: UnicodeString read FUsuario write FUsuario;
    property Enabled: boolean read FEnabled write FEnabled;
  end;

  // ************************************************************************ //
  // Namespace : urn:server.permissions.intf-IMercurioPermissionsServer
  // soapAction: urn:server.permissions.intf-IMercurioPermissionsServer#%operationName%
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : rpc
  // use       : encoded
  // binding   : IMercurioPermissionsServerbinding
  // service   : IMercurioPermissionsServerservice
  // port      : IMercurioPermissionsServerPort
  // URL       : http://localhost:8080/soap/IMercurioPermissionsServer
  // ************************************************************************ //

  IMercurioPermissionsServer = interface(IInvokable)
  ['{559A5105-920B-B09D-79E4-F6CADA52647B}']

    function  NewPermission(const value: TMyPermission): TMyPermission; stdcall;
    function  GetMyPermissions: string; stdcall;
    function  AsObjects: TMyPermissions; stdcall;
  end;

function GetIMercurioPermissionsServer(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): IMercurioPermissionsServer;


implementation
  uses System.SysUtils;

function GetIMercurioPermissionsServer(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): IMercurioPermissionsServer;
const
  defWSDL = 'http://localhost:8080/wsdl/IMercurioPermissionsServer';
  defURL  = 'http://localhost:8080/soap/IMercurioPermissionsServer';
  defSvc  = 'IMercurioPermissionsServerservice';
  defPrt  = 'IMercurioPermissionsServerPort';
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
  if HTTPRIO = nil then RIO := THTTPRIO.Create(nil)
  else
    RIO := HTTPRIO;
  try
    Result := (RIO as IMercurioPermissionsServer);
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

destructor TMyPermissions.Destroy;
var
  I: Integer;
begin
  for I := 0 to Pred(System.Length(FPermissions)) do
   begin
    System.SysUtils.FreeAndNil(FPermissions[I]);
   end;

  System.SetLength(FPermissions, 0);
  inherited Destroy;
end;


initialization
  { IMercurioPermissionsServer }
  InvRegistry.RegisterInterface(TypeInfo(IMercurioPermissionsServer), 'urn:server.permissions.intf-IMercurioPermissionsServer', '');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(IMercurioPermissionsServer), 'urn:server.permissions.intf-IMercurioPermissionsServer#%operationName%');
  RemClassRegistry.RegisterXSInfo(TypeInfo(TPermissionsArray), 'urn:server.permissions.intf', 'TPermissionsArray');
  RemClassRegistry.RegisterXSClass(TMyPermissions, 'urn:server.permissions.intf', 'TMyPermissions');
  RemClassRegistry.RegisterXSClass(TMyPermission, 'urn:server.permissions.intf', 'TMyPermission');
end.