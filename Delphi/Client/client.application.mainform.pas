unit client.application.mainform;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  client.interfaces.service, client.classes.svccon, System.Actions, FMX.ActnList,
  System.ImageList, FMX.ImgList, FMX.Controls.Presentation, FMX.StdCtrls,
  client.interfaces.application, client.classes.dlgmessages;

type
  TFrmMainForm = class(TForm, IChatApplication)
    ActList: TActionList;
    ActConnectService: TAction;
    ActDisconnectService: TAction;
    ImgList: TImageList;
    Button1: TButton;
    Button2: TButton;
    procedure ActDisconnectServiceExecute(Sender: TObject);
    procedure ActDisconnectServiceUpdate(Sender: TObject);
    procedure ActConnectServiceUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ActConnectServiceExecute(Sender: TObject);

  strict private
    //FConnectionObj: TChatConnection; //conexão com o serviço remoto
   // FDialogsObj: TDlgMessages; //dialogs nas múltiplas plataformas suportadas.
   FConnected: boolean;

  private
    { Private declarations }
    //IChatApplication
    function GetConnected: boolean;
    procedure SetConnected(const Value: boolean);
    function GetDialogs: IDlgMessage;
    function GetRemoteService: IChatService;
    function GetTitle: string;

  public
    { Public declarations }



    //IChatApplication
    property Connected: boolean read GetConnected write SetConnected;
    property Dialogs: IDlgMessage read GetDialogs;
    property RemoteService: IChatService read GetRemoteService;
    property Title: string read GetTitle;
  end;

var
  FrmMainForm: TFrmMainForm;

implementation

{$R *.fmx}

procedure TFrmMainForm.ActConnectServiceExecute(Sender: TObject);
begin
 Connected := RemoteService.ConnectService;
 if Connected then
  Dialogs.InfoMessage('Marcelo', 'O teste de conexão foi feito com sucesso');
end;

procedure TFrmMainForm.ActConnectServiceUpdate(Sender: TObject);
begin
 TAction(Sender).Enabled := (Connected = False);
end;

procedure TFrmMainForm.ActDisconnectServiceExecute(Sender: TObject);
begin
 Connected := not RemoteService.DisconnectService;
end;

procedure TFrmMainForm.ActDisconnectServiceUpdate(Sender: TObject);
begin
 TAction(Sender).Enabled := (Connected = True);
end;

procedure TFrmMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if (RemoteService <> nil) then
  RemoteService.DisconnectService;
end;

procedure TFrmMainForm.FormCreate(Sender: TObject);
begin
 Connected := False; //default
 //FConnectionObj := TChatConnection.Create;
 //FDialogsObj := TDlgMessages.Create;
end;

function TFrmMainForm.GetConnected: boolean;
begin
 Result := FConnected;
end;

function TFrmMainForm.GetDialogs: IDlgMessage;
begin
//  Result := FDialogsObj as IDlgMessage;
 Result := TDlgMessages.Create as IDlgMessage;
end;

function TFrmMainForm.GetRemoteService: IChatService;
begin
  //Result := FConnectionObj as IChatService;
  Result := TChatConnection.Create as IChatService;
end;

function TFrmMainForm.GetTitle: string;
begin
 Result := Application.Title;
end;

procedure TFrmMainForm.SetConnected(const Value: boolean);
begin
 FConnected := Value;
end;

end.
