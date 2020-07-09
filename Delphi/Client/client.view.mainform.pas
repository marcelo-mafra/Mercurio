unit client.view.mainform;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, classes.logs.controller,
  client.interfaces.connection, client.model.connection, System.Actions, FMX.ActnList,
  System.ImageList, FMX.ImgList, FMX.Controls.Presentation, FMX.StdCtrls,
  client.interfaces.application, client.classes.dlgmessages, FMX.Objects,
  FMX.StdActns, FMX.ListView.Types, FMX.ListView.Appearances, classes.logs,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.ListBox, FMX.Layouts,
  client.resources.svcconsts, client.interfaces.contatos, client.model.contatos,
  client.serverintf.contatos, client.model.listacontatos, client.resources.mercurio,
  client.resources.consts, FMX.MultiView, FMX.TabControl, FMX.Edit, classes.conflogs,
  FMX.SearchBox, client.view.navegatelist, client.data.contatos,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.Components, Data.Bind.DBScope;

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
    Label1: TLabel;
    Label3: TLabel;
    ActDeleteContato: TAction;
    SterlingStyleBook: TStyleBook;
    BindContatos: TBindSourceDB;
    BindingsList1: TBindingsList;
    TabItem1: TTabItem;
    LinkFillControlToField1: TLinkFillControlToField;
    ContactsListView: TListView;
    LinkFillControlToField2: TLinkFillControlToField;
    LstContatos: TListBox;
    ListBoxItem2: TListBoxItem;
    SearchBox1: TSearchBox;
    ListBoxHeader2: TListBoxHeader;
    SpeedButton5: TSpeedButton;
    Label2: TLabel;
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
   FConnected: boolean;
   FNavegateObj: TNavegateList;
   FLogsConfObj: TLogsConfigurations;
   FContatosData: TContatosData;

  private
    { Private declarations }
    procedure ConfigureElements(const ShowText: boolean);
    procedure ListarContatos; //***
    procedure NavegateTo(Item: TViewItem);
    function GetRemoteService: IServiceConnection;
    function GetSelectedContact: TMyContato;
    procedure DoOnNewFileEvent(var NewFileName: string); //***

    //IChatApplication
    function GetDialogs: IDlgMessage;
    function GetMercurioLogs: IMercurioLogs;
    function GetContatosService: IContatosService;
    function GetTitle: string;

  public
    { Public declarations }
    property LogsConfObj: TLogsConfigurations read FLogsConfObj;
    property NavegateObj: TNavegateList read FNavegateObj;
    property RemoteService: IServiceConnection read GetRemoteService;
    property SelectedContact: TMyContato read GetSelectedContact;

    //IChatApplication
    property ContatosService: IContatosService read GetContatosService;
    property Dialogs: IDlgMessage read GetDialogs;
    property MercurioLogs: IMercurioLogs read GetMercurioLogs implements IMercurioLogs;

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
 FConnected := RemoteService.ConnectService;
 if FConnected then
  begin
   if not Assigned(FContatosData) then FContatosData := TContatosData.Create(BindContatos);
   self.ListarContatos;
  end;
end;

procedure TFrmMainForm.ActConnectServiceUpdate(Sender: TObject);
begin
 TAction(Sender).Enabled := (FConnected = False);
end;

procedure TFrmMainForm.ActDeleteContatoExecute(Sender: TObject);
begin
  if Dialogs.ConfirmationMessage(string.Empty, TDialogsConst.ConfDelContact) = TDialogsResult.mrYes then
  begin
   if ContatosService.ExcluirContato(SelectedContact) then
    begin
     LstContatos.Items.Delete(LstContatos.Selected.Index);
    end;
  end;
end;

procedure TFrmMainForm.ActDeleteContatoUpdate(Sender: TObject);
begin
 TAction(Sender).Enabled := (FConnected) and (TabMain.ActiveTab = TabContatos) and
   (LstContatos.Selected <> nil);
end;

procedure TFrmMainForm.ActDisconnectServiceExecute(Sender: TObject);
begin
 FConnected := not RemoteService.DisconnectService;
 if not FConnected then
   if Assigned(FContatosData) then FreeAndNil(FContatosData);
end;

procedure TFrmMainForm.ActDisconnectServiceUpdate(Sender: TObject);
begin
 TAction(Sender).Enabled := (FConnected = True);
end;

procedure TFrmMainForm.ActServiceInfoExecute(Sender: TObject);
var
 Counter: integer;
 ListObj: TStringList;
 ItemObj: TListBoxItem;
 HeaderObj: TListBoxGroupHeader;
begin
 if FConnected then
  begin
   ListObj := TStringList.Create;

    try
      //Busca informações sobre o serviço remoto.
      RemoteService.ServiceInfo.GetServiceInfo(ListObj);

    finally
      if ListObj.Count > 0 then
       begin
        { LstServiceInfo.BeginUpdate;
         LstServiceInfo.Items.Clear;

         HeaderObj :=  TListBoxGroupHeader.Create(LstServiceInfo);
         HeaderObj.Text := 'Header service';
         LstServiceInfo.AddObject(HeaderObj);

         for Counter := 0 to ListObj.Count - 1 do
          begin
             //Item do listbox.
             ItemObj := TListBoxItem.Create(LstServiceInfo);
             with ItemObj do
              begin
                 Text :=  ListObj.Names[Counter];
                 Height := 35;

                 ItemData.Detail:= ListObj.ValueFromIndex[Counter];
                 StyleLookup := TMercurioUI.ListBoxItemStyle;
                 ItemData.Accessory := TlistBoxItemData.TAccessory(1);
                 WordWrap := True;
                 Hint := ItemObj.ItemData.Detail;
              end;

             LstServiceInfo.AddObject(ItemObj);
          end;

         LstServiceInfo.EndUpdate; }

         NavegateTo(viServiceInfo);
         ActServiceInfoView.Execute;
       end;

      if Assigned(ListObj) then FreeAndNil(ListObj);
    end;
  end;
end;

procedure TFrmMainForm.ActServiceInfoUpdate(Sender: TObject);
begin
 TAction(Sender).Enabled := FConnected;
end;

procedure TFrmMainForm.ActSaveContatoDataExecute(Sender: TObject);
var
 MyContatoObj: TMyContato;
begin
 if FConnected then
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
 NavegateTo(viContatos);
end;

procedure TFrmMainForm.ActTabContactsUpdate(Sender: TObject);
begin
 TAction(Sender).Enabled := (FConnected) and (TabMain.ActiveTab <> TabContatos);
end;

procedure TFrmMainForm.ActTabNewContactExecute(Sender: TObject);
begin
 NavegateTo(viNovoContato);
end;

procedure TFrmMainForm.ActTabNewContactUpdate(Sender: TObject);
begin
 TAction(Sender).Enabled := (FConnected) and (TabMain.ActiveTab <> TabNewContact);
end;

procedure TFrmMainForm.ActUpdateContatosExecute(Sender: TObject);
begin
 self.ListarContatos;
end;

procedure TFrmMainForm.ActUpdateContatosUpdate(Sender: TObject);
begin
 TAction(sender).Enabled := (FConnected) and (TabMain.ActiveTab = TabContatos);
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
    BtnContacts.Text :=  string.Empty;
    BtnServiceInfo.Text :=  string.Empty;
    BtnNewContact.Text :=  string.Empty;
    BtnDelContact.Text :=  string.Empty;
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
 if (RemoteService <> nil) then RemoteService.DisconnectService;
end;

procedure TFrmMainForm.FormCreate(Sender: TObject);
begin
 FNavegateObj := TNavegateList.Create;
 FLogsConfObj := TLogsConfigurations.Create(GetCurrentDir + '\' + TMercurioConst.ConfigFile);

 FConnected := False; //default
 PnlServiceInfo.Visible := False;

 ConfigureElements(False);
 NavegateTo(viContatos);
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

function TFrmMainForm.GetContatosService: IContatosService;
begin
  //Interface que abstrai o serviço remoto de contatos do usuário.
  Result := TContatosModel.Create as IContatosService;
end;

function TFrmMainForm.GetDialogs: IDlgMessage;
begin
 //Interface que abstrai dialogs de tipos diversos nas múltiplas plataformas suportadas.
 Result := TDlgMessages.Create as IDlgMessage;
end;

function TFrmMainForm.GetMercurioLogs: IMercurioLogs;
var
 LogsObj: TMercurioLogsController;
begin
{Retorna uma interface que abstrai recursos de geração de registros de logs para
 toda a aplicação.}
 LogsObj := TMercurioLogsController.Create(LogsConfObj.Folder, TMercurioLogs.FileExtension, TEncoding.UTF8);
 LogsObj.MaxFileSize := LogsConfObj.MaxFileSize;
 LogsObj.AppName := TChatServiceLabels.ServiceName;
 LogsObj.CurrentFile := LogsConfObj.CurrentFile;
 LogsObj.OnNewFile := DoOnNewFileEvent;

 Result := LogsObj as IMercurioLogs;
end;

function TFrmMainForm.GetRemoteService: IServiceConnection;
begin
  //Interface que abstrai a conexão com o serviço remoto de chat.
  Result := TServiceConnection.Create as IServiceConnection;
  Result.Connected := FConnected;
end;

function TFrmMainForm.GetSelectedContact: TMyContato;
begin
 Result := nil;
 if LstContatos.Selected <> nil then Result := TMyContato(LstContatos.Selected.Data);
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
{Busca no serviço remoto os contatos do usuário corrente.}
 if FConnected then
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
          FullName := string.Empty;
          ItemObj.Text := FullName.Join(' ', [MyContatoObj.FirstName.TrimRight, MyContatoObj.LastName.TrimRight]);
          ItemObj.Height := 37;
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



end.
