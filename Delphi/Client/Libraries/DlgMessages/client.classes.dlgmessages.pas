unit client.classes.dlgmessages;

interface

 uses
  FMX.Dialogs, client.interfaces.application;

 type
   TDlgMessages = class(TInterfacedObject, IDlgMessage)

    private


    public
      constructor Create;
      destructor Destroy; override;

      function ConfirmationMessage(const MessageTitle, MessageText: string): integer;
      function ErrorMessage(const MessageTitle, MessageText: string): integer;
      function InfoMessage(const MessageTitle, MessageText: string): integer;
      function WarningMessage(const MessageTitle, MessageText: string): integer;


   end;


implementation

{ TDlgMessages }

constructor TDlgMessages.Create;
begin
 inherited;
end;

destructor TDlgMessages.Destroy;
begin

  inherited;
end;

function TDlgMessages.ConfirmationMessage(const MessageTitle,
  MessageText: string): integer;
begin
  ShowMessage(MessageText);
end;

function TDlgMessages.ErrorMessage(const MessageTitle,
  MessageText: string): integer;
begin
  ShowMessage(MessageText);
end;

function TDlgMessages.InfoMessage(const MessageTitle,
  MessageText: string): integer;
begin
  ShowMessage(MessageText);
end;

function TDlgMessages.WarningMessage(const MessageTitle,
  MessageText: string): integer;
begin
  ShowMessage(MessageText);
end;

end.
