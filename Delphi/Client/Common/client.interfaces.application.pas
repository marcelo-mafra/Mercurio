unit client.interfaces.application;

interface

uses
 client.interfaces.common, classes.logs.types;

 type

  IDlgMessage = interface(IMercurioInterface)
  ['{BE5F2EAF-739E-46BB-A4BC-B153AC7773B0}']
    function ConfirmationMessage(const MessageTitle, MessageText: string): integer;
    procedure ErrorMessage(const MessageTitle, MessageText: string);
    procedure InfoMessage(const MessageTitle, MessageText: string);
    procedure WarningMessage(const MessageTitle, MessageText: string);
  end;


 //Abstrai o a aplicação cliente de chat.
 IChatApplication = interface(IMercurioInterface)
   ['{B427E7E4-808D-412D-83E5-579DC86510BD}']
    function GetConnected: boolean;
    function GetDialogs: IDlgMessage;
    function GetMercurioLogs: IMercurioLogs;
    function GetTitle: string;

    property Connected: boolean read GetConnected;
    property Dialogs: IDlgMessage read GetDialogs;
    property MercurioLogs: IMercurioLogs read GetMercurioLogs;
    property Title: string read GetTitle;

  end;

implementation

end.
