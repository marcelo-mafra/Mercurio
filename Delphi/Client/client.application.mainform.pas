unit client.application.mainform;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  client.interfaces.service, client.classes.chatservice, System.Actions, FMX.ActnList,
  System.ImageList, FMX.ImgList, FMX.Controls.Presentation, FMX.StdCtrls,
  client.interfaces.application, client.classes.dlgmessages, FMX.Objects;

type
  TFrmMainForm = class(TForm, IChatApplication)
    ActList: TActionList;
    ActConnectService: TAction;
    ActDisconnectService: TAction;
    ImgList: TImageList;
    Panel1: TPanel;
    ImgProfile: TImage;
    ActProfile: TAction;
    PnlProfile: TExpander;
    procedure ActDisconnectServiceExecute(Sender: TObject);
    procedure ActDisconnectServiceUpdate(Sender: TObject);
    procedure ActConnectServiceUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ActConnectServiceExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ActProfileExecute(Sender: TObject);
    procedure ImgProfileClick(Sender: TObject);

  strict private
   FConnected: boolean;
   function GetBitmap(const ImageIndex: integer): TBitmap; inline;

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

procedure TFrmMainForm.ActProfileExecute(Sender: TObject);
var
 ListObj: TStringList;
begin
 if Connected then
  begin
   ListObj := TStringList.Create;
    try
      RemoteService.ServiceInfo.GetServiceInfo(ListObj);

    finally
      Dialogs.InfoMessage('', ListObj.Values['ServiceName'] + ' | ' +
                              ListObj.Values['ServiceHost']);

      PnlProfile.IsExpanded := True;
      if Assigned(ListObj) then FreeAndNil(ListObj);

    end;

  end;
end;

procedure TFrmMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if (RemoteService <> nil) then
  RemoteService.DisconnectService;
end;

procedure TFrmMainForm.FormCreate(Sender: TObject);
begin
 Connected := False; //default
 ImgProfile.Bitmap.Assign(GetBitmap(0));
end;

procedure TFrmMainForm.FormShow(Sender: TObject);
begin
 ActConnectService.Execute;
end;

function TFrmMainForm.GetConnected: boolean;
begin
 Result := FConnected;
end;

function TFrmMainForm.GetDialogs: IDlgMessage;
begin
 //Interface que abstrai dialogs nas múltiplas plataformas suportadas.
 Result := TDlgMessages.Create as IDlgMessage;
end;

function TFrmMainForm.GetRemoteService: IChatService;
begin
  //Interface que abstrai o serviço remoto de chat.
  Result := TChatService.Create as IChatService;
end;

function TFrmMainForm.GetTitle: string;
begin
 Result := Application.Title;
end;

procedure TFrmMainForm.ImgProfileClick(Sender: TObject);
begin
 ActProfile.Execute;
end;

function TFrmMainForm.GetBitmap(const ImageIndex: integer): TBitmap;
var
 sz: TSize;
begin
 //Retorna uma das imagens da lista de imagens da aplicação.
 sz := TSize.Create(18, 18);
 Result :=  ImgList.Bitmap(sz, ImageIndex);
end;

procedure TFrmMainForm.SetConnected(const Value: boolean);
begin
 FConnected := Value;
end;

end.
