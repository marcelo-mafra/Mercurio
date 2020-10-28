unit client.view.mainform;

interface

uses
  //RTL units
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.Rtti, System.Actions, System.Bindings.Outputs, System.ImageList,
  //FMX units
  FMX.Types, FMX.Controls, FMX.Forms, FMX.ActnList, FMX.ImgList, FMX.Controls.Presentation,
  FMX.StdCtrls, FMX.Objects, FMX.StdActns, FMX.ListBox, FMX.Layouts, FMX.MultiView,
  FMX.TabControl, FMX.Edit, FMX.SearchBox, Fmx.Bind.DBEngExt, Fmx.Bind.Editors,

  {Mercúrio units listed by domains or specializations.}
  //Connection
  client.classes.session, client.interfaces.connection, client.model.connection.factory,
  client.resources.connection, client.interfaces.observerscon, client.model.observerscon,
  //Logs
  classes.logs.types, classes.logs.params, classes.logs.factory, client.resources.logs,
  //Application and UX.
  client.interfaces.application, client.resources.mercurio, client.resources.servicelabels,
  client.classes.dlgmessages, client.view.navegatelist,
  //Contatos
  client.interfaces.contatos, classes.contatos.types, client.model.contatos.factory,
  client.serverintf.contatos, client.model.listacontatos, client.resources.contatos,
  client.resources.contatos.dataobjects,
  //Permissões
  client.interfaces.permissions, client.model.permissions.factory,
  classes.permissions.types;

type
  TFrmMainForm = class(TForm, IChatApplication, IContactsService, IMercurioLogs)
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
    TabItem1: TTabItem;
    TabControl1: TTabControl;
    TabContatosListView: TTabItem;
    TabContatosListBox: TTabItem;
    BtnConnect: TSpeedButton;
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
    FAllowedFeatures: TMercurioFeatures;
    FSessionObj: TConnectionSession;
    FNavegateObj: TNavegateList;
    FParamsObj: TLogsParams;
    FContatosStyle: TContatosListStyle;
    FContatosDetailed, FContatosSample: TFrame;
    FObserversConnection: IObserversConnection;

   procedure DoOnNewContato(value: TMyContato);
   function DoHasPermission(const Feature: TMercurioFeature): boolean;

  private
    { Private declarations }
    procedure ConfigureElements(const ShowText: boolean);
    procedure NavegateTo(Item: TViewItem; const Added: boolean = True);
    function GetPermissionsService: IPermissionsService;
    function GetServiceConnection: IServiceConnection;
    function GetSelectedContact: TMyContato;
    procedure SetContatosStyle(value: TContatosListStyle);

    //IChatApplication
    function GetConnected: boolean;
    function GetDialogs: IDlgMessage;
    function GetMercurioLogs: IMercurioLogs;
    function GetContatosService: IContactsService;
    function GetTitle: string;
    function HasPermission(const Feature: TMercurioFeature): boolean;

  public
    { Public declarations }
    property ParamsObj: TLogsParams read FParamsObj;
    property NavegateObj: TNavegateList read FNavegateObj;
    property PermissionsService: IPermissionsService read GetPermissionsService;
    property ServiceConnection: IServiceConnection read GetServiceConnection;
    property SelectedContact: TMyContato read GetSelectedContact;
    property ContatosStyle: TContatosListStyle read FContatosStyle write SetContatosStyle;

    //IChatApplication
    property AllowedFeatures: TMercurioFeatures read FAllowedFeatures;
    property Connected: boolean read GetConnected;
    property ContatosService: IContactsService read GetContatosService implements IContactsService;
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

function TFrmMainForm.DoHasPermission(const Feature: TMercurioFeature): boolean;
begin
 Result := Feature in FAllowedFeatures;
end;

{Implementação de TFrmMainForm para uma série de eventos disponibilizados por
meio de interfaces implementadas em classes de módulos externos.}

procedure TFrmMainForm.DoOnNewContato(value: TMyContato);
begin
{Implementa o evento OnNewContato, disparado sempre que a interface IContatosService
cria um novo contato no serviço remoto. Os dados do novo contato estão no parâmetro
"value".}
 //implementar mecanismo de notificação de bandeja ou push
end;

procedure TFrmMainForm.ActBackExecute(Sender: TObject);
begin
 NavegateTo(NavegateObj.PreviousItem, False);
end;

procedure TFrmMainForm.ActBackUpdate(Sender: TObject);
begin
 TAction(Sender).Enabled := not (NavegateObj.IsEmpty) and (NavegateObj.CurrentIndex > TNavConst.MinValue);
end;

procedure TFrmMainForm.ActConnectServiceExecute(Sender: TObject);
var
 SessionId: string;
begin
 if ServiceConnection.ConnectService(SessionId) then
  begin
    FSessionObj := TConnectionSession.Create(SessionId);
    FObserversConnection.NotifyObjects(Sender, csConnected);
    self.FAllowedFeatures := [];
    //self.RegisterPermission(mfListaContatos, 'Novo contato', 'Marcelo');
    self.PermissionsService.GetMyPermissions(self.FAllowedFeatures);
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
      case ContatosStyle of
       ltSample: (FContatosSample as IContatosFrame).DeleteSelected;
       ltDetailed: (FContatosDetailed as IContatosFrame).DeleteSelected;
      end;
    end;
  end;
end;

procedure TFrmMainForm.ActDeleteContatoUpdate(Sender: TObject);
begin
 TAction(Sender).Enabled := (Connected) and (TabMain.ActiveTab = TabContatos) and
    (SelectedContact <> nil) and (self.HasPermission(mfDeleteContato));
end;

procedure TFrmMainForm.ActDisconnectServiceExecute(Sender: TObject);
begin
 try
   ServiceConnection.DisconnectService;
   FObserversConnection.NotifyObjects(Sender, csInactive);

 finally
   if Assigned(FSessionObj) then FreeAndNil(FSessionObj);
 end;
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
 TAction(Sender).Enabled := Connected and self.HasPermission(mfServiceInfo)
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
 TAction(Sender).Enabled := (Connected) and not (EdtFirstName.Text.IsEmpty)
   and not (EdtLastName.Text.IsEmpty) and (self.HasPermission(mfInsertContato));
end;

procedure TFrmMainForm.ActTabContactsExecute(Sender: TObject);
begin
 NavegateTo(viContatos);
end;

procedure TFrmMainForm.ActTabContactsUpdate(Sender: TObject);
begin
 TAction(Sender).Enabled := (Connected) //and (TabMain.ActiveTab <> TabContatos)
   and (self.HasPermission(mfListaContatos));
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
 case ContatosStyle of
   ltSample:   (FContatosSample as IContatosFrame).UpdateData;
   ltDetailed: (FContatosDetailed as IContatosFrame).UpdateData;
 end;
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
 FNavegateObj := TNavegateList.Create;
 FParamsObj := TLogsParams.Create(ParamsFile);

{ Cria os frames de dados de contatos e os adiciona como "observers da conexão".}
 FContatosDetailed := TFactoryFrameContatos.New(FSessionObj, TabContatosListView, nil, cfDetailed);
 FContatosSample := TFactoryFrameContatos.New(FSessionObj, TabContatosListBox, ActUpdateContatos, cfSample);
 //Set these objects as observers for the connection status.
 FObserversConnection := TObserversConnection.New;
 FObserversConnection.Add(FContatosDetailed as IObserverConnection);
 FObserversConnection.Add(FContatosSample as IObserverConnection);

 PnlServiceInfo.Visible := False;
 ConfigureElements(False);
 //NavegateTo(viContatos);
end;

procedure TFrmMainForm.FormDestroy(Sender: TObject);
begin
 if Assigned(FContatosDetailed) then FreeAndNil(FContatosDetailed);
 if Assigned(FContatosSample) then FreeAndNil(FContatosSample);
 if Assigned(FNavegateObj) then FreeAndNil(FNavegateObj);
 if Assigned(FParamsObj) then FreeAndNil(FParamsObj);
end;

function TFrmMainForm.GetConnected: boolean;
begin
 Result := (FSessionObj <> nil) and (FSessionObj.Active);
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
 Result := TFactoryLogs.New(self.ParamsFile, ParamsObj.Folder, ParamsObj.CurrentFile,
    TServiceLabels.ServiceName, ParamsObj.MaxFileSize);
end;

function TFrmMainForm.GetPermissionsService: IPermissionsService;
begin
  //Interface que abstrai uma coleção de permissões de usuários.
  Result := TFactoryPermissions.New;
end;

function TFrmMainForm.GetServiceConnection: IServiceConnection;
begin
  //Interface que abstrai a conexão com o serviço remoto de chat.
  Result := TFactoryServiceConnection.New(FSessionObj);
end;

function TFrmMainForm.GetSelectedContact: TMyContato;
begin
 case ContatosStyle of
   ltSample: Result := (FContatosSample as IContatosFrame).SelectedContact;
   ltDetailed: Result := (FContatosDetailed as IContatosFrame).SelectedContact;
 end;
end;

function TFrmMainForm.GetTitle: string;
begin
 Result := Application.Title;
end;

function TFrmMainForm.HasPermission(const Feature: TMercurioFeature): boolean;
begin
 Result := self.DoHasPermission(Feature);
end;

procedure TFrmMainForm.MultiView1StartHiding(Sender: TObject);
begin
 ConfigureElements(False);
end;

procedure TFrmMainForm.MultiView1StartShowing(Sender: TObject);
begin
 ConfigureElements(True);
end;

procedure TFrmMainForm.NavegateTo(Item: TViewItem; const Added: boolean);
var
 NewItem: TTabItem;
begin
 case Item of
   viContatos:    NewItem := TabContatos;
   viNovoContato: NewItem := TabNewContact;
   viServiceInfo: NewItem := TabServiceInfo;
   viNone:        NewItem := nil;
 end;

 if (NewItem <> nil) and (NewItem <> TabMain.ActiveTab) then
  begin
   TabMain.ActiveTab := NewItem;
   if Added then FNavegateObj.AddItem(Item);
  end;
end;

procedure TFrmMainForm.SetContatosStyle(value: TContatosListStyle);
begin
 FContatosStyle := value;
end;



{initialization
RegisterFmxClasses([TFrmMainForm]);}


end.
