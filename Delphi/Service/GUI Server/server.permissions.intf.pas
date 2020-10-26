unit server.permissions.intf;

interface

uses Soap.InvokeRegistry, System.Types, Soap.XSBuiltIns;

type

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

  TMyPermissions = class(TRemotable)
  private


  published


  end;

  { Invokable interfaces must derive from IInvokable }
  IMercurioPermissionsServer = interface(IInvokable)
  ['{4FB1EFB2-E130-4A7B-B870-C0F797012610}']

    { Methods of Invokable interface must not use the default }
    { calling convention; stdcall is recommended }
    function NewPermission(const Value: TMyPermission): TMyPermission; stdcall;
    function GetMyPermissions: UnicodeString; stdcall;
    //function ExcluirContato(const value: TMyContato): boolean; stdcall;
  end;

implementation

initialization
  { Invokable interfaces must be registered }
  InvRegistry.RegisterInterface(TypeInfo(IMercurioPermissionsServer));

end.
