unit client.application.mainform;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, classes.logs.controller,
  client.interfaces.service, client.classes.chatservice, System.Actions, FMX.ActnList,
  System.ImageList, FMX.ImgList, FMX.Controls.Presentation, FMX.StdCtrls,
  client.interfaces.application, client.classes.dlgmessages, FMX.Objects,
  FMX.StdActns, FMX.ListView.Types, FMX.ListView.Appearances, classes.logs,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.ListBox, FMX.Layouts,
  client.resources.svcconsts, client.interfaces.contatos, client.classes.contatos,
  client.serverintf.contatos, client.classes.listacontatos, client.resources.mercurio,
  client.resources.consts, FMX.MultiView, FMX.TabControl, FMX.Edit, classes.conflogs,
  FMX.SearchBox, client.classes.viewitems;

type
  TFrmMainForm = class(TForm, IChatApplication, IMercurioLogs)
    ActList: TActionList;
    ActConnectService: TAction;
    ActDisconnectService: TAction;
    ImgList: TImageList;
    Panel1: TPanel;
    ActServiceInfo: TAction;
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
    TabServiceInfo: TTabItem;
    BtnDelContact: TSpeedButton;
    BtnContacts: TSpeedButton;
    BtnServiceInfo: TSpeedButton;
    TabNewContact: TTabItem;
    ActTabNewContact: TAction;
    BtnNewContact: TSpeedButton;
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
    procedure ActServiceInfoExecute(Sender: TObject);
    procedure ActServiceInfoUpdate(Sender: TObject);
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
    procedure MultiView1StartShowing(Sender: TObject);
    procedure MultiView1StartHiding(Sender: TObject);

  strict private
   Events: TLogEvents;
   FConnected: boolean;
   FNavegateObj: TNavegateList;
   FLogsConfObj: TLogsConfigurations;

  private
    { Private declarations }
    procedure ConfigureElements(const ShowText: boolean);
    procedure ListarContatos;
    procedure NavegateTo(Item: TViewItem);
    function GetSelectedContact: TMyContato;
    procedure DoOnNewFileEvent(var NewFileName: string);

    //IChatApplication
    function GetConnected: boolean;
    procedure SetConnected(const Value: boolean);
    function GetDialogs: IDlgMessage;
    function GetLogWriter: IMercurioLogs;
    function GetContatosService: IContatosService;
    function GetRemoteService: IChatService;
    function GetTitle: string;

  public
    { Public declarations }
    property LogsConfObj: TLogsConfigurations read FLogsConfObj;
    property NavegateObj: TNavegateList read FNavegateObj;
    property SelectedContact: TMyContato read GetSelectedContact;

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
 NavegateTo(NavegateObj.PreviousItem);
end;

procedure TFrmMainForm.ActBackUpdate(Sender: TObject);
begin
 TAction(Sender).Enabled := not (NavegateObj.IsEmpty);
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
 if ContatosService.ExcluirContato(SelectedContact) then
  begin
   LstContatos.Items.Delete(LstContatos.Selected.Index);
   LogsWriter.RegisterInfo(TChatMessagesConst.CallRemoteMethodSucess);
  end;
end;

procedure TFrmMainForm.ActDeleteContatoUpdate(Sender: TObject);
begin
 TAction(Sender).Enabled := (Connected) and (TabMain.ActiveTab = TabContatos) and
   (LstContatos.Selected <> nil);
end;

procedure TFrmMainForm.ActDisconnectServiceExecute(Sender: TObject);
begin
 Connected := not RemoteService.DisconnectService;
end;

procedure TFrmMainForm.ActDisconnectServiceUpdate(Sender: TObject);
begin
 TAction(Sender).Enabled := (Connected = True);
end;

procedure TFrmMainForm.ActServiceInfoExecute(Sender: TObject);
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
             ItemObj.StyleLookup := TMercurioUI.ListBoxItemStyle;
             ItemObj.ItemData.Accessory := TlistBoxItemData.TAccessory(1);
             ItemObj.WordWrap := True;
             ItemObj.Hint := ItemObj.ItemData.Detail;
             LstServiceInfo.AddObject(ItemObj);
          end;

         LstServiceInfo.EndUpdate;

         NavegateTo(viServiceInfo);
         ActServiceInfoView.Execute;
       end;

      if Assigned(ListObj) then FreeAndNil(ListObj);
    end;
  end;
end;

procedure TFrmMainForm.ActServiceInfoUpdate(Sender: TObject);
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

procedure TFrmMainForm.ConfigureElements(const ShowText: boolean);
{var
 I: integer;
 ButtonObj: TSpeedButton;
 s: string;}
begin
 if ShowText = True then
  begin
    BtnContacts.Text :=  TAction(BtnContacts.Action).Text;
    BtnServiceInfo.Text :=  TAction(BtnServiceInfo.Action).Text;
    BtnNewContact.Text :=  TAction(BtnNewContact.Action).Text;
    BtnDelContact.Text :=  TAction(BtnDelContact.Action).Text;
  end
  else
  begin
    BtnContacts.Text :=  '';
    BtnServiceInfo.Text :=  '';
    BtnNewContact.Text :=  '';
    BtnDelContact.Text :=  '';
  end;
{
 for I := 0 to MultiView1.ChildrenCount - 1 do
   begin
     s := MultiView1.Children.Items[I].ClassName;
     if MultiView1.Children.Items[I] is TSpeedButton then
      begin
        ButtonObj := TSpeedButton(MultiView1.Children.Items[I]);
        if ShowText then
         ButtonObj.Text := TAction(ButtonObj.Action).Text
        else
         ButtonObj.Text := '';
      end;
   end;}
end;

procedure TFrmMainForm.DoOnNewFileEvent(var NewFileName: string);
begin
{Método que aponta para o evento TMercurioLogsController.OnNewFile, disparado sempre que
 o arquivo de logs atinge o tamanho máximo e se cria um novo para ser usado. Nesse
 caso, é necessário registrar isso no .ini para que na próxima execução do cliente
 o uso deste arquivo seja retomado (até atingir o tamanho máximo definido).}
  LogsConfObj.CurrentFile := NewFileName;
end;

procedure TFrmMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if (RemoteService <> nil) then
  RemoteService.DisconnectService;
end;

procedure TFrmMainForm.FormCreate(Sender: TObject);
begin
 Events := [leOnError, leOnAuthenticateSucess, leOnAuthenticateFail, leOnInformation,
            leOnWarning, leOnConnect, leOnConnectError, leOnMethodCall,
            leOnMethodCallError, leUnknown];

 FNavegateObj := TNavegateList.Create;
 FLogsConfObj := TLogsConfigurations.Create(GetCurrentDir + '\' + TMercurioConst.ConfigFile);

 Connected := False; //default
 PnlServiceInfo.Visible := False;

 ConfigureElements(False);
 NavegateTo(ViContatos);
end;

procedure TFrmMainForm.FormDestroy(Sender: TObject);
begin
 if Assigned(FNavegateObj) then FreeAndNil(FNavegateObj);
 if Assigned(FLogsConfObj) then FreeAndNil(FLogsConfObj);
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
 LogsObj := TMercurioLogsController.Create(LogsConfObj.Folder, TMercurioLogs.FileExtension, TEncoding.UTF8, Events);
 LogsObj.MaxFileSize := LogsConfObj.MaxFileSize;
 LogsObj.AppName := TChatServiceLabels.ServiceName;
 LogsObj.CurrentFile := LogsConfObj.CurrentFile;
 LogsObj.OnNewFile := DoOnNewFileEvent;

 Result := LogsObj as IMercurioLogs;
end;

function TFrmMainForm.GetRemoteService: IChatService;
begin
  //Interface que abstrai o serviço remoto de chat.
  Result := TChatService.Create as IChatService;
end;

function TFrmMainForm.GetSelectedContact: TMyContato;
begin
 Result := nil;

 if LstContatos.Selected <> nil then
   Result := TMyContato(LstContatos.Selected.Data);
end;

function TFrmMainForm.GetTitle: string;
begin
 Result := Application.Title;
end;

procedure TFrmMainForm.ListarContatos;
var
 I: integer;
 ListObj: TListaContatos;
 MyContatoObj: TMyContato;
 ItemObj: TListBoxItem;
 FullName: string;
begin
 if Connected then
  begin
    ListObj := TListaContatos.Create;

    try
      ContatosService.GetMyContatos(ListObj);

      if ListObj.IsEmpty then
       Exit;

      LstContatos.BeginUpdate;
      LstContatos.Clear;

      for I := 0 to ListObj.Count - 1 do
       begin
        MyContatoObj := ListObj.FindObject(I);

        if MyContatoObj <> nil then
         begin
          ItemObj := TListBoxItem.Create(LstContatos);
          FullName := '';
          ItemObj.Text := FullName.Join(' ', [MyContatoObj.FirstName.TrimRight, MyContatoObj.LastName.TrimRight]);
          ItemObj.Height := 40;
          //ItemObj.ItemData.Bitmap := GetBitmap(3);

          ItemObj.ItemData.Detail := MyContatoObj.ContatoId.ToString;
          ItemObj.StyleLookup := TMercurioUI.ListBoxItemStyle;
          ItemObj.ItemData.Accessory := TlistBoxItemData.TAccessory(1);
          ItemObj.WordWrap := True;
          ItemObj.Hint := ItemObj.ItemData.Detail;
          ItemObj.Data := MyContatoObj;

          LstContatos.AddObject(ItemObj);
         end;
       end;

    finally
     LstContatos.EndUpdate;
    end;
  end;
end;

procedure TFrmMainForm.MultiView1StartHiding(Sender: TObject);
begin
 ConfigureElements(False);
end;

procedure TFrmMainForm.MultiView1StartShowing(Sender: TObject);
begin
 ConfigureElements(True);
end;

procedure TFrmMainForm.NavegateTo(Item: TViewItem);
begin
 case Item of
   viContatos:    TabMain.ActiveTab := TabContatos;
   viNovoContato: TabMain.ActiveTab := TabNewContact;
   viServiceInfo: TabMain.ActiveTab := TabServiceInfo;
   viNone: Exit;
 end;

 FNavegateObj.AddItem(Item);
end;

procedure TFrmMainForm.SetConnected(const Value: boolean);
begin
 FConnected := Value;
end;


end.
