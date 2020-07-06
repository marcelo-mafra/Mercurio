unit client.classes.dlgmessages;

interface

 uses
  FMX.DialogService, System.UITypes, client.interfaces.application;

 type
   TDialogsResult = class
     const
      mrNo  = 0;
      mrYes = 1;
   end;

   TDlgMessages = class(TInterfacedObject, IDlgMessage)

    private


    public
      constructor Create;
      destructor Destroy; override;

      function ConfirmationMessage(const MessageTitle, MessageText: string): integer;
      procedure ErrorMessage(const MessageTitle, MessageText: string);
      procedure InfoMessage(const MessageTitle, MessageText: string);
      procedure WarningMessage(const MessageTitle, MessageText: string);


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
var
 lResult: integer;
begin
  Result := TDialogsResult.mrNo; //No (default).

  TDialogService.PreferredMode := TDialogService.TPreferredMode.Platform;

  TDialogService.MessageDialog(MessageText, TMsgDlgType.mtConfirmation,
    [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0,
    procedure(const AResult: TModalResult)
    begin
      case AResult of
        mrYes: lResult := TDialogsResult.mrYes;
        mrNo:  lResult := TDialogsResult.mrNo;
      end;
    end);

 Result := lResult;
end;

procedure TDlgMessages.ErrorMessage(const MessageTitle,
  MessageText: string);
begin
 TDialogService.MessageDialog(MessageText, TMsgDlgType.mtError,
   [TMsgDlgBtn.mbOK], TMsgDlgBtn.mbOK, 0, nil);
end;

procedure TDlgMessages.InfoMessage(const MessageTitle,
  MessageText: string);
begin
 TDialogService.MessageDialog(MessageText, TMsgDlgType.mtInformation,
   [TMsgDlgBtn.mbOK], TMsgDlgBtn.mbOK, 0, nil);
end;

procedure TDlgMessages.WarningMessage(const MessageTitle,
  MessageText: string);
begin
 TDialogService.MessageDialog(MessageText, TMsgDlgType.mtWarning,
   [TMsgDlgBtn.mbOK], TMsgDlgBtn.mbOK, 0, nil);
end;

end.
