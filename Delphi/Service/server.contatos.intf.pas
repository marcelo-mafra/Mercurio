{ Invokable interface IMercurioContatosServer }

unit server.contatos.intf;

interface

uses Soap.InvokeRegistry, System.Types, Soap.XSBuiltIns;

type
  TMyContato = class; //forward declaration

  TContatosArray = array of TMyContato;

  TMyContato = class(TRemotable)
  private
    FContatoId: UnicodeString;
    FLastName: UnicodeString;
    FFirstName: UnicodeString;
    FStatus: integer;

  published
    property ContatoId: UnicodeString read FContatoId write FContatoId;
    property LastName: UnicodeString read FLastName write FLastName;
    property FirstName: UnicodeString read FFirstName write FFirstName;
    property Status: integer read FStatus write FStatus;
  end;

  TMyContatos = class(TRemotable)
  private
    FContentText, FSenderUser: UnicodeString;
    FMessageId: double;
    FRegisteredTime: TDateTime;
    FContatos: TContatosArray;

  published
    property ContentText: UnicodeString read FContentText write FContentText;
    property MessageId: double read FMessageId write FMessageId;
    property RegisteredTime: TDateTime read FRegisteredTime write FRegisteredTime;
    property SenderUser: UnicodeString read FSenderUser write FSenderUser;

    property Contatos: TContatosArray read FContatos write FContatos;

  end;

  { Invokable interfaces must derive from IInvokable }
  IMercurioContatosServer = interface(IInvokable)
  ['{65A59EA8-98BC-4CCB-A9F7-40F6AD116D26}']

    { Methods of Invokable interface must not use the default }
    { calling convention; stdcall is recommended }
    function NewContato(const Value: TMyContato): TMyContato; stdcall;
    function GetMyContatos: UnicodeString; stdcall;
    function ExcluirContato(const value: TMyContato): boolean; stdcall;
    function AsObjects: TMyContatos; stdcall;
  end;

implementation

initialization
  { Invokable interfaces must be registered }
  InvRegistry.RegisterInterface(TypeInfo(IMercurioContatosServer));
  RemClassRegistry.RegisterXSInfo(TypeInfo(TContatosArray));

end.
