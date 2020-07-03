unit client.application.mainform;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, classes.logs.controller,
  client.interfaces.service, client.classes.chatservice, System.Actions, FMX.ActnList,
  System.ImageList, FMX.ImgList, FMX.Controls.Presentation, FMX.StdCtrls,
  client.interfaces.application, client.classes.dlgmessages, FMX.Objects,
  FMX.StdActns, FMX.ListView.Types, FMX.ListView.Appearances, classes.logs,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.ListBox, FMX.Layouts, System.IniFiles,
  client.resources.svcconsts, client.interfaces.contatos, client.classes.contatos,
  client.serverintf.contatos, client.classes.listacontatos, client.resources.mercurio,
  client.resources.consts, FMX.MultiView, FMX.TabControl, FMX.Edit,
  FMX.SearchBox;

type
  TViewItem = (viContatos, viNovoContato);

  TFrmMainForm = class(TForm, IChatApplication, IMercurioLogs)
    ActList: TActionList;
    ActConnectService: TAction;
    ActDisconnectService: TAction;
    ImgList: TImageList;
    Panel1: TPanel;
    ActProfile: TAction;
    PnlServiceInfo: TCalloutPanel;
    ActServiceInfoView: TViewAction;
    LstServiceInfo: TListBox;
    ListBoxHeader1: TListBoxHeader;
    ListBoxItem1: TListBoxItem;
    LstContatos: TListBox;
    ActBack: TAction;
    MultiView1: TMultiView;
    BtnMaster: TSpeedButton;
    TabMain: TTabControl;
    TabContatos: TTabItem;
    TabItem2: TTabItem;
    SpeedButton2: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton3: TSpeedButton;
    TabNewContact: TTabItem;
    ActTabNewContact: TAction;
    SpeedButton4: TSpeedButton;
    ActTabContacts: TAction;
    BtnBack: TSpeedButton;
    EdtFirstName: TEdit;
    EdtLastName: TEdit;
    ActSaveContatoData: TAction;
    Button1: TButton;
    ActUpdateContatos: TAction;
    SearchBox1: TSearchBox;
    ListBoxHeader2: TListBoxHeader;
    SpeedButton5: TSpeedButton;
    Label2: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    ActDeleteContato: TAction;
    procedure ActDisconnectServiceExecute(Sender: TObject);
    procedure ActDisconnectServiceUpdate(Sender: TObject);
    procedure ActConnectServiceUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ActConnectServiceExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ActBackExecute(Sender: TObject);
    procedure ActBackUpdate(Sender: TObject);
    procedure ActProfileExecute(Sender: TObject);
    procedure ActProfileUpdate(Sender: TObject);
    procedure ActTabNewContactExecute(Sender: TObject);
    procedure ActTabContactsExecute(Sender: TObject);
    procedure ActSaveContatoDataExecute(Sender: TObject);
    procedure ActSaveContatoDataUpdate(Sender: TObject);
    procedure ActUpdateContatosExecute(Sender: TObject);
    procedure ActUpdateContatosUpdate(Sender: TObject);
    procedure ActTabContactsUpdate(Sender: TObject);
    procedure ActTabNewContactUpdate(Sender: TObject);
    procedure ActDeleteContatoExecute(Sender: TObject);
    procedure ActDeleteContatoUpdate(Sender: TObject);

  strict private
   Events: TLogEvents;
   FLogFolder, FLogCurrentFile: string;
   FLogMaxFileSize: Int64;
   FConnected: boolean;

  private
    { Private declarations }
    //FLogsFilesPath: string;
    //IChatApplication
    function GetConnected: boolean;
    procedure SetConnected(const Value: boolean);
    function GetDialogs: IDlgMessage;
    function GetLogWriter: IMercurioLogs;
    function GetContatosService: IContatosService;
    function GetRemoteService: IChatService;
    function GetTitle: string;
    procedure ListarContatos;
    procedure LoadLogsParams;
    procedure NavegateTo(Item: TViewItem);

  public
    { Public declarations }
    //property LogsFilesPath: string read FLogsFilesPath;

    //IChatApplication
    property Connected: boolean read GetConnected write SetConnected;
    property ContatosService: IContatosService read GetContatosService;
    property Dialogs: IDlgMessage read GetDialogs;
    property LogsWriter: IMercurioLogs read GetLogWriter implements IMercurioLogs;
    property RemoteService: IChatService read GetRemoteService;
    property Title: string read GetTitle;
  end;

var
  FrmMainForm: TFrmMainForm;

implementation

{$R *.fmx}
{$R *.iPad.fmx IOS}
{$R *.iPhone55in.fmx IOS}
{$R *.Moto360.fmx ANDROID}
{$R *.LgXhdpiPh.fmx ANDROID}

procedure TFrmMainForm.ActBackExecute(Sender: TObject);
begin
 PnlServiceInfo.Visible := False;
end;

procedure TFrmMainForm.ActBackUpdate(Sender: TObject);
begin
 TAction(Sender).Enabled := PnlServiceInfo.Visible;
end;

procedure TFrmMainForm.ActConnectServiceExecute(Sender: TObject);
begin
 Connected := RemoteService.ConnectService;
 if Connected then
   self.ListarContatos;
end;

procedure TFrmMainForm.ActConnectServiceUpdate(Sender: TObject);
begin
 TAction(Sender).Enabled := (Connected = False);
end;

procedure TFrmMainForm.ActDeleteContatoExecute(Sender: TObject);
begin
Tag := 0;
end;

procedure TFrmMainForm.ActDeleteContatoUpdate(Sender: TObject);
begin
 TAction(Sender).Enabled := (Connected) and (TabMain.ActiveTab = TabContatos) and
   (LstContatos.Selected<> nil);
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
 Counter: integer;
 ListObj: TStringList;
 ItemObj: TListBoxItem;
 HeaderObj: TListBoxGroupHeader;
begin
 if Connected then
  begin
   ListObj := TStringList.Create;

    try
      RemoteService.ServiceInfo.GetServiceInfo(ListObj);
      LogsWriter.RegisterInfo(TChatMessagesConst.CallRemoteMethodSucess);

    finally
      if ListObj.Count > 0 then
       begin
         LstServiceInfo.BeginUpdate;
         LstServiceInfo.Items.Clear;

         HeaderObj :=  TListBoxGroupHeader.Create(LstServiceInfo);
         HeaderObj.Text := 'Header service';
         //HeaderObj.TextSettings.Font.Style := [TFontStyle(fsBold)];
         LstServiceInfo.AddObject(HeaderObj);

         for Counter := 0 to ListObj.Count - 1 do
          begin
             //Item do listbox.
             ItemObj := TListBoxItem.Create(LstServiceInfo);
             ItemObj.Text :=  ListObj.Names[Counter];
             ItemObj.Height := 35;
             //ItemObj.ItemData.Bitmap := GetBitmap(3);

             ItemObj.ItemData.Detail:= ListObj.ValueFromIndex[Counter];
             ItemObj.StyleLookup := 'listboxitembottomdetail';
             ItemObj.ItemData.Accessory := TlistBoxItemData.TAccessory(1);
             ItemObj.WordWrap := True;
             ItemObj.Hint := ItemObj.ItemData.Detail;
             LstServiceInfo.AddObject(ItemObj);
          end;

         LstServiceInfo.EndUpdate;
         ActServiceInfoView.Execute;
       end;

      if Assigned(ListObj) then FreeAndNil(ListObj);
    end;
  end;
end;

procedure TFrmMainForm.ActProfileUpdate(Sender: TObject);
begin
 TAction(Sender).Enabled := Connected;
end;

procedure TFrmMainForm.ActSaveContatoDataExecute(Sender: TObject);
var
 MyContatoObj: TMyContato;
begin
 if Connected then
  begin
    MyContatoObj := TMyContato.Create;

    try
      MyContatoObj.FirstName := EdtFirstName.Text;
      MyContatoObj.LastName := EdtLastName.Text;
      MyContatoObj := ContatosService.NewContato(MyContatoObj);

    finally
     FreeAndNil(MyContatoObj);
     EdtFirstName.SetFocus;
    end;
  end;

end;

procedure TFrmMainForm.ActSaveContatoDataUpdate(Sender: TObject);
begin
 TAction(Sender).Enabled := not (EdtFirstName.Text.IsEmpty) and not (EdtLastName.Text.IsEmpty);
end;

procedure TFrmMainForm.ActTabContactsExecute(Sender: TObject);
begin
 NavegateTo(ViContatos);
end;

procedure TFrmMainForm.ActTabContactsUpdate(Sender: TObject);
begin
TAction(Sender).Enabled := (Connected) and (TabMain.ActiveTab <> TabContatos);
end;

procedure TFrmMainForm.ActTabNewContactExecute(Sender: TObject);
begin
 NavegateTo(ViNovoContato);
end;

procedure TFrmMainForm.ActTabNewContactUpdate(Sender: TObject);
begin
TAction(Sender).Enabled := (Connected) and (TabMain.ActiveTab <> TabNewContact);
end;

procedure TFrmMainForm.ActUpdateContatosExecute(Sender: TObject);
begin
 self.ListarContatos;
end;

procedure TFrmMainForm.ActUpdateContatosUpdate(Sender: TObject);
begin
 TAction(sender).Enabled := (Connected) and (TabMain.ActiveTab = TabContatos);
end;

procedure TFrmMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if (RemoteService <> nil) then
  RemoteService.DisconnectService;
end;

procedure TFrmMainForm.FormCreate(Sender: TObject);
var
 I: integer;
begin
 LoadLogsParams;

 Connected := False; //default
 PnlServiceInfo.Visible := False;

 for I := 0 to TabMain.TabCount - 1 do
    TabMain.Tabs[I].Visible := True;

 NavegateTo(ViContatos);
end;

procedure TFrmMainForm.FormDestroy(Sender: TObject);
begin
// if Assigned(FLogWriter) then
  // FreeAndNil(FlogWriter);
end;

procedure TFrmMainForm.FormShow(Sender: TObject);
begin
 ActConnectService.Execute;
end;

function TFrmMainForm.GetConnected: boolean;
begin
 Result := FConnected;
end;

function TFrmMainForm.GetContatosService: IContatosService;
begin
  //Interface que abstrai o serviço remoto de contatos do usuário.
  Result := TContatosService.Create as IContatosService;
end;

function TFrmMainForm.GetDialogs: IDlgMessage;
begin
 //Interface que abstrai dialogs nas múltiplas plataformas suportadas.
 Result := TDlgMessages.Create as IDlgMessage;
end;

function TFrmMainForm.GetLogWriter: IMercurioLogs;
var
 LogsObj: TMercurioLogsController;
begin
 LogsObj := TMercurioLogsController.Create(FLogFolder, '.log', TEncoding.UTF8, Events);
 LogsObj.MaxFileSize := FLogMaxFileSize;
 LogsObj.AppName := TChatServiceLabels.ServiceName;
 LogsObj.CurrentFile := FLogCurrentFile;

 Result := LogsObj  as IMercurioLogs;
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

procedure TFrmMainForm.ListarContatos;
var
 I: integer;
 ContatosList: TListaContatos;
 MyContatoObj: TMyContato;
 ItemObj: TListBoxItem;
 FullName: string;
begin
 if Connected then
  begin
    ContatosList := TListaContatos.Create;

    try
      ContatosService.GetMyContatos(ContatosList);

      if ContatosList.IsEmpty then
       Exit;

      LstContatos.BeginUpdate;
      LstContatos.Clear;

      for I := 0 to ContatosList.Count - 1 do
       begin
        MyContatoObj := ContatosList.FindObject(I);

        if MyContatoObj <> nil then
         begin
          ItemObj := TListBoxItem.Create(LstContatos);
          FullName := '';
          ItemObj.Text := FullName.Join(' ', [MyContatoObj.FirstName.TrimRight, MyContatoObj.LastName.TrimRight]);
          ItemObj.Height := 40;
          //ItemObj.ItemData.Bitmap := GetBitmap(3);

          ItemObj.ItemData.Detail := MyContatoObj.ContatoId.ToString;
          ItemObj.StyleLookup := 'listboxitembottomdetail';
          ItemObj.ItemData.Accessory := TlistBoxItemData.TAccessory(1);
          ItemObj.WordWrap := True;
          ItemObj.Hint := ItemObj.ItemData.Detail;

          LstContatos.AddObject(ItemObj);
         end;
       end;

    finally
     LstContatos.EndUpdate;
    end;

  end;

end;

procedure TFrmMainForm.LoadLogsParams;
var
 ConfigFile: TIniFile;
 FileName: string;
begin
  Events := [leOnError, leOnAuthenticateSucess, leOnAuthenticateFail, leOnInformation,
             leOnWarning, leOnConnect, leOnConnectError, leOnMethodCall,
             leOnMethodCallError, leUnknown];

  FileName := GetCurrentDir + '\' + TMercurioConst.ConfigFile;
  ConfigFile := TIniFile.Create(FileName);

    try
      FLogFolder := ConfigFile.ReadString(TMercurioConst.ConfigSection, TMercurioConst.ConfigFolder, '');
      FLogCurrentFile := ConfigFile.ReadString(TMercurioConst.ConfigSection, TMercurioConst.ConfigCurrentFile, '');
      FLogMaxFileSize := ConfigFile.ReadInteger(TMercurioConst.ConfigSection, TMercurioConst.ConfigMaxFileSize, TMercurioConst.DefaultMaxSize);

    finally
      ConfigFile.Free;
    end;
end;

procedure TFrmMainForm.NavegateTo(Item: TViewItem);
begin
 case Item of
   viContatos:   TabMain.ActiveTab := TabContatos;
   viNovoContato: TabMain.ActiveTab := TabNewContact;

 end;
end;

procedure TFrmMainForm.SetConnected(const Value: boolean);
begin
 FConnected := Value;
end;


end.
