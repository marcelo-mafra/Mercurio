{ Invokable interface IMercurioContatosServer }

unit server.contatos.intf;

interface

uses Soap.InvokeRegistry, System.Types, Soap.XSBuiltIns;

type

 // TDoubleArray = array of Double;

  TMyContato = class(TRemotable)
  private
    FLastName: UnicodeString;
    FFirstName: UnicodeString;

  published
    property LastName: UnicodeString read FLastName write FLastName;
    property FirstName: UnicodeString read FFirstName write FFirstName;
  end;

  TMyContatos = class(TRemotable)
  private
    FContentText, FSenderUser: UnicodeString;
    FMessageId: double;
    FRegisteredTime: TDateTime;

  published
    property ContentText: UnicodeString read FContentText write FContentText;
    property MessageId: double read FMessageId write FMessageId;
    property RegisteredTime: TDateTime read FRegisteredTime write FRegisteredTime;
    property SenderUser: UnicodeString read FSenderUser write FSenderUser;

  end;

  { Invokable interfaces must derive from IInvokable }
  IMercurioContatosServer = interface(IInvokable)
  ['{65A59EA8-98BC-4CCB-A9F7-40F6AD116D26}']

    { Methods of Invokable interface must not use the default }
    { calling convention; stdcall is recommended }
    function NewContato(const Value: TMyContato): TMyContato; stdcall;
  end;

implementation

initialization
  { Invokable interfaces must be registered }
  InvRegistry.RegisterInterface(TypeInfo(IMercurioContatosServer));

end.
