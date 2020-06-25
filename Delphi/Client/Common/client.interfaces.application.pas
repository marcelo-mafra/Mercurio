unit client.interfaces.application;

interface

uses
 client.interfaces.common, client.interfaces.service;

 type
  IDlgMessage = interface(IChatInterface)
  ['{BE5F2EAF-739E-46BB-A4BC-B153AC7773B0}']
    function ConfirmationMessage(const MessageTitle, MessageText: string): integer;
    function ErrorMessage(const MessageTitle, MessageText: string): integer;
    function InfoMessage(const MessageTitle, MessageText: string): integer;
    function WarningMessage(const MessageTitle, MessageText: string): integer;
  end;


 //Abstrai o a aplica��o cliente de chat.
 IChatApplication = interface(IChatInterface)
   ['{B427E7E4-808D-412D-83E5-579DC86510BD}']
    function GetConnected: boolean;
    procedure SetConnected(const Value: boolean);
    function GetDialogs: IDlgMessage;
    function GetRemoteService: IChatService;
    function GetTitle: string;

    //function GetMainLog: ICosmosLogs;
    // property MainLog: ICosmosLogs read GetMainLog;

    property Connected: boolean read GetConnected write SetConnected;
    property Dialogs: IDlgMessage read GetDialogs;
    property RemoteService: IChatService read GetRemoteService;
    property Title: string read GetTitle;

  end;

implementation

end.
