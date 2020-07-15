unit client.view.mainform;

interface

uses
  //RTL units
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.Rtti, System.Actions, System.Bindings.Outputs, System.ImageList,
  Data.Bind.EngExt,  Data.Bind.Components, Data.Bind.DBScope,
  //FMX units
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ActnList, FMX.ImgList, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.Objects, FMX.StdActns, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.ListBox, FMX.Layouts,
  FMX.MultiView, FMX.TabControl, FMX.Edit, FMX.SearchBox, Fmx.Bind.DBEngExt,
  Fmx.Bind.Editors,

  {Mercúrio units listed by domains or specializations.}

  //Connection
  client.interfaces.connection, client.model.connection.factory, client.resources.connection,
  //Logs
  classes.logs.types, classes.logs.params, classes.logs.factory, client.resources.logs,
  //Application and UX.
  client.interfaces.application, client.resources.mercurio, client.resources.servicelabels,
  client.classes.dlgmessages, client.view.navegatelist,
  //Contatos
  client.interfaces.contatos, classes.contatos.types, client.model.contatos.factory,
  client.serverintf.contatos, client.model.listacontatos, client.resources.contatos,
  client.resources.contatos.dataobjects;

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
    TabItem1: TTabItem;
    LstContatos: TListBox;
    SearchBox1: TSearchBox;
    ListBoxHeader2: TListBoxHeader;
    SpeedButton5: TSpeedButton;
    Label2: TLabel;
    TabControl1: TTabControl;
    TabContatosListView: TTabItem;
    TabContatosListBox: TTabItem;
    BtnConnect: TSpeedButton;
    ContactsListview: TListView;
    BindingsList1: TBindingsList;
    LinkFillControlToField1: TLinkFillControlToField;
    procedure ActDisconnectServiceExecute(Sender: TObject);
    procedure ActDisconnectServiceUpdate(Sender: TObject);
    procedure ActConnectServiceUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ActConnectServiceExecute(Sender: TObject);
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
   FParamsObj: TLogsParams;
   FContatosStyle: TContatosListStyle;
   FContatosDetailed: TFrame;

   procedure DoOnNewContato(value: TMyContato);

  private
    { Private declarations }
    procedure ConfigureElements(const ShowText: boolean);
    procedure ListarContatos; //***Levar para TFmeContatosSampleView
    procedure NavegateTo(Item: TViewItem);
    function GetServiceConnection: IServiceConnection;
    function GetSelectedContact: TMyContato;
    procedure SetContatosStyle(value: TContatosListStyle);

    //IChatApplication
    function GetDialogs: IDlgMessage;
    function GetMercurioLogs: IMercurioLogs;
    function GetContatosService: IContactsService;
    function GetTitle: string;

  public
    { Public declarations }
    property ParamsObj: TLogsParams read FParamsObj;
    property Connected: boolean read FConnected;
    property NavegateObj: TNavegateList read FNavegateObj;
    property ServiceConnection: IServiceConnection read GetServiceConnection;
    property SelectedContact: TMyContato read GetSelectedContact;
    property ContatosStyle: TContatosListStyle read FContatosStyle write SetContatosStyle;

    //IChatApplication
    property ContatosService: IContactsService read GetContatosService;
    property Dialogs: IDlgMessage read GetDialogs;
    property MercurioLogs: IMercurioLogs read GetMercurioLogs implements IMercurioLogs;
    property Title: string read GetTitle;
  end;


var
  FrmMainForm: TFrmMainForm;

implementation

{$R *.fmx}

uses client.view.mainform.helpers;

{$R *.iPad.fmx IOS}
{$R *.iPhone55in.fmx IOS}
{$R *.Moto360.fmx ANDROID}
{$R *.LgXhdpiPh.fmx ANDROID}

{Implementação de TFrmMainForm para uma série de eventos disponibilizados por
meio de interfaces implementadas em classes de módulos externos.}
procedure TFrmMainForm.DoOnNewContato(value: TMyContato);
begin
{Implementa o evento OnNewContato, disparado sempre que a interface IContatosService
cria um novo contato no serviço remoto. Os dados do novo contato estão no parâmetro
"value".}
 //implementar mecanismo de notificação de bandeja ou push
end;

//Fim da "seção" que implementa eventos de interfaces externas.

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
 FConnected := ServiceConnection.ConnectService;
 if Connected then
  begin
   self.ListarContatos;
  end;
end;

procedure TFrmMainForm.ActConnectServiceUpdate(Sender: TObject);
begin
 TAction(Sender).Enabled := (Connected = False);
end;

procedure TFrmMainForm.ActDeleteContatoExecute(Sender: TObject);
begin
  if Dialogs.ConfirmationMessage(string.Empty, TContatosDialogs.ConfDelContact) = TDialogsResult.mrYes then
  begin
   if ContatosService.IContact.ExcluirContato(SelectedContact) then
    begin
     LstContatos.Items.Delete(LstContatos.Selected.Index);
    end;
  end;
end;

procedure TFrmMainForm.ActDeleteContatoUpdate(Sender: TObject);
begin
 TAction(Sender).Enabled := (Connected) and (TabMain.ActiveTab = TabContatos) and
    (SelectedContact <> nil);
end;

procedure TFrmMainForm.ActDisconnectServiceExecute(Sender: TObject);
begin
 ServiceConnection.DisconnectService;
 FConnected := ServiceConnection.Connected;
end;

procedure TFrmMainForm.ActDisconnectServiceUpdate(Sender: TObject);
begin
 TAction(Sender).Enabled := (Connected = True);
end;

procedure TFrmMainForm.ActServiceInfoExecute(Sender: TObject);
var
 //Counter: integer;
 ListObj: TStringList;
 //ItemObj: TListBoxItem;
// HeaderObj: TListBoxGroupHeader;
begin
 if Connected then
  begin
   ListObj := TStringList.Create;

    try
      //Busca informações sobre o serviço remoto.
      ServiceConnection.ServiceInfo.GetServiceInfo(ListObj);

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
      MyContatoObj := ContatosService.IContact.NewContato(MyContatoObj);

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
 TAction(Sender).Enabled := (Connected) and (TabMain.ActiveTab <> TabContatos);
end;

procedure TFrmMainForm.ActTabNewContactExecute(Sender: TObject);
begin
 NavegateTo(viNovoContato);
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
end;

procedure TFrmMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 ActDisconnectService.Execute;
end;

procedure TFrmMainForm.FormCreate(Sender: TObject);
begin
 FConnected := False; //default
 FNavegateObj := TNavegateList.Create;
 FParamsObj := TLogsParams.Create(ParamsFile);
{ Cria os frames de dados de contatos.}
 FContatosDetailed := TFactoryFrameContatos.New(TabContatosListView, cfDetailed);

 PnlServiceInfo.Visible := False;
 ConfigureElements(False);
 NavegateTo(viContatos);
end;

procedure TFrmMainForm.FormDestroy(Sender: TObject);
begin
 if Assigned(FContatosDetailed) then FreeAndNil(FContatosDetailed);
 if Assigned(FNavegateObj) then FreeAndNil(FNavegateObj);
 if Assigned(FParamsObj) then FreeAndNil(FParamsObj);
end;

function TFrmMainForm.GetContatosService: IContactsService;
begin
  //Interface que abstrai o serviço remoto de contatos do usuário.
  Result := TFactoryContatos.New(DoOnNewContato, nil);
end;

function TFrmMainForm.GetDialogs: IDlgMessage;
begin
 //Interface que abstrai dialogs de tipos diversos nas múltiplas plataformas suportadas.
 Result := TDlgMessages.Create as IDlgMessage;
end;

function TFrmMainForm.GetMercurioLogs: IMercurioLogs;
begin
{Retorna uma interface que abstrai recursos de geração de registros de logs para
 toda a aplicação.}
 Result := TFactoryLogs.New(ParamsFile, ParamsObj.Folder, ParamsObj.CurrentFile,
    TServiceLabels.ServiceName, ParamsObj.MaxFileSize);
end;

function TFrmMainForm.GetServiceConnection: IServiceConnection;
begin
  //Interface que abstrai a conexão com o serviço remoto de chat.
  Result := TFactoryServiceConnection.New;
end;

function TFrmMainForm.GetSelectedContact: TMyContato;
begin
 case ContatosStyle of
   ltSample:
     begin
       if (LstContatos.Selected <> nil) then
         Result := TMyContato(LstContatos.Selected.Data)
       else
         Result := nil;                                                                                                          ;
     end;
   ltDetailed:
     begin
       if (ContactsListView.Selected <> nil) then
         Result := nil//TMyContato(ContactsListView.Selected.TagObject)
       else
         Result := nil;                                                                                                          ;
     end;
   ltFull: Result := nil;
 end;
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

          ItemObj.ItemData.Detail := MyContatoObj.ContatoId;
          ItemObj.StyleLookup := TMercurioUI.ListBoxItemStyle;
          ItemObj.ItemData.Accessory := TListBoxItemData.TAccessory(1);
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


procedure TFrmMainForm.SetContatosStyle(value: TContatosListStyle);
begin
 FContatosStyle := value;
end;

end.
