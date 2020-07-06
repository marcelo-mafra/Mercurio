unit client.interfaces.application;

interface

uses
 client.interfaces.common, client.interfaces.service, classes.logs;

 type
  IDlgMessage = interface(IChatInterface)
  ['{BE5F2EAF-739E-46BB-A4BC-B153AC7773B0}']
    function ConfirmationMessage(const MessageTitle, MessageText: string): integer;
    procedure ErrorMessage(const MessageTitle, MessageText: string);
    procedure InfoMessage(const MessageTitle, MessageText: string);
    procedure WarningMessage(const MessageTitle, MessageText: string);
  end;


 //Abstrai o a aplicação cliente de chat.
 IChatApplication = interface(IChatInterface)
   ['{B427E7E4-808D-412D-83E5-579DC86510BD}']
    function GetConnected: boolean;
    procedure SetConnected(const Value: boolean);
    function GetDialogs: IDlgMessage;
    function GetLogWriter: IMercurioLogs;
    function GetRemoteService: IChatService;
    function GetTitle: string;

    property Connected: boolean read GetConnected write SetConnected;
    property Dialogs: IDlgMessage read GetDialogs;
    property LogsWriter: IMercurioLogs read GetLogWriter;
    property RemoteService: IChatService read GetRemoteService;
    property Title: string read GetTitle;

  end;

implementation

end.
