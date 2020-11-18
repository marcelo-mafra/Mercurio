{ Invokable interface IMercurioChatServer }

unit server.chatserver.intf;

interface

uses Soap.InvokeRegistry, System.Types, Soap.XSBuiltIns;

type

//  TEnumTest = (etNone, etAFew, etSome, etAlot);

  //Status de cada mensagem do chat.
  TMessageStatus = (msNew, msRegistered, msEContentInvalid, msESenderUserInvalid,
    msEUnknown);

  TChatMessage = class(TRemotable)
  private
    FContentText, FSenderUser: UnicodeString;
    FMessageId: double;
    FStatusMsg: TMessageStatus;
    FRegisteredTime: TDateTime;

  published
    property ContentText: UnicodeString read FContentText write FContentText;
    property MessageId: double read FMessageId write FMessageId;
    property RegisteredTime: TDateTime read FRegisteredTime write FRegisteredTime;
    property SenderUser: UnicodeString read FSenderUser write FSenderUser;
    property StatusMsg: TMessageStatus read FStatusMsg write FStatusMsg;
  end;

  { Invokable interfaces must derive from IInvokable }
  IMercurioChatServer = interface(IInvokable)
  ['{D7220A98-1AA5-4BFE-8146-1D29EC74E69A}']

    function NewChatMessage(const Value: TChatMessage): TChatMessage; stdcall;
  end;

implementation

initialization
  { Invokable interfaces must be registered }
  InvRegistry.RegisterInterface(TypeInfo(IMercurioChatServer));

end.
