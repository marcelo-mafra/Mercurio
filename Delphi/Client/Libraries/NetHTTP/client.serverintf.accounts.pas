// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : http://localhost:8080/wsdl/IMercurioAccountsServer
//  >Import : http://localhost:8080/wsdl/IMercurioAccountsServer>0
// Version  : 1.0
// (03/11/2020 22:21:35 - - $Rev: 96726 $)
// ************************************************************************ //

unit client.serverintf.accounts;

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
  // !:dateTime        - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:boolean         - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:string          - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:int             - "http://www.w3.org/2001/XMLSchema"[Gbl]

  TMyAccount           = class;                 { "urn:server.accounts.intf"[GblCplx] }



  // ************************************************************************ //
  // XML       : TMyAccount, global, <complexType>
  // Namespace : urn:server.accounts.intf
  // ************************************************************************ //
  TMyAccount = class(TRemotable)
  private
    FAccountId: Integer;
    FAccountName: string;
    FMyName: string;
    FEnabled: Boolean;
    FCreatedAt: TXSDateTime;
  public
    destructor Destroy; override;
  published
    property AccountId:   Integer      read FAccountId write FAccountId;
    property AccountName: string       read FAccountName write FAccountName;
    property MyName:      string       read FMyName write FMyName;
    property Enabled:     Boolean      read FEnabled write FEnabled;
    property CreatedAt:   TXSDateTime  read FCreatedAt write FCreatedAt;
  end;


  // ************************************************************************ //
  // Namespace : urn:server.accounts.intf-IMercurioAccountsServer
  // soapAction: urn:server.accounts.intf-IMercurioAccountsServer#%operationName%
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : rpc
  // use       : encoded
  // binding   : IMercurioAccountsServerbinding
  // service   : IMercurioAccountsServerservice
  // port      : IMercurioAccountsServerPort
  // URL       : http://localhost:8080/soap/IMercurioAccountsServer
  // ************************************************************************ //
  IMercurioAccountsServer = interface(IInvokable)
  ['{1A828D8D-4D75-2BFF-2305-4FB6E174434E}']
    function  NewAccount(const Value: TMyAccount): TMyAccount; stdcall;
    function  GetMyAccounts: string; stdcall;
    function  DropAccount(const value: TMyAccount): Boolean; stdcall;
  end;

function GetIMercurioAccountsServer(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): IMercurioAccountsServer;


implementation
  uses System.SysUtils;

function GetIMercurioAccountsServer(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): IMercurioAccountsServer;
const
  defWSDL = 'http://localhost:8080/wsdl/IMercurioAccountsServer';
  defURL  = 'http://localhost:8080/soap/IMercurioAccountsServer';
  defSvc  = 'IMercurioAccountsServerservice';
  defPrt  = 'IMercurioAccountsServerPort';
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
    Result := (RIO as IMercurioAccountsServer);
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


destructor TMyAccount.Destroy;
begin
  System.SysUtils.FreeAndNil(FCreatedAt);
  inherited Destroy;
end;

initialization
  { IMercurioAccountsServer }
  InvRegistry.RegisterInterface(TypeInfo(IMercurioAccountsServer), 'urn:server.accounts.intf-IMercurioAccountsServer', '');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(IMercurioAccountsServer), 'urn:server.accounts.intf-IMercurioAccountsServer#%operationName%');
  RemClassRegistry.RegisterXSClass(TMyAccount, 'urn:server.accounts.intf', 'TMyAccount');

end.