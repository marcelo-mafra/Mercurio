unit server.accounts.intf;

interface

uses Soap.InvokeRegistry, System.Types, Soap.XSBuiltIns;

type

  TMyAccount = class(TRemotable)
  private
    FAccountId: integer;
    FAccountName: UnicodeString;
    FMyName: UnicodeString;
    FEnabled: boolean;
    FCreatedAt: TDateTime;

  published
    property AccountId: integer read FAccountId write FAccountId;
    property AccountName: UnicodeString read FAccountName write FAccountName;
    property MyName: UnicodeString read FMyName write FMyName;
    property Enabled: boolean read FEnabled write FEnabled;
    property CreatedAt: TDateTime read FCreatedAt;
  end;

  TMyAccounts = class(TRemotable)
  private


  published


  end;

  { Invokable interfaces must derive from IInvokable }
  IMercurioAccountsServer = interface(IInvokable)
  ['{8C5F2A3B-09AE-4278-A180-0C31361D8593}']

    { Methods of Invokable interface must not use the default }
    { calling convention; stdcall is recommended }
    function NewAccount(const Value: TMyAccount): TMyAccount; stdcall;
    function GetMyAccounts: UnicodeString; stdcall;
    function DropAccount(const value: TMyAccount): boolean; stdcall;
  end;

implementation

initialization
  { Invokable interfaces must be registered }
  InvRegistry.RegisterInterface(TypeInfo(IMercurioAccountsServer));
end.
