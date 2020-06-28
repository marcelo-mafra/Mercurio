unit client.application.mainform;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  client.interfaces.service, client.classes.chatservice, System.Actions, FMX.ActnList,
  System.ImageList, FMX.ImgList, FMX.Controls.Presentation, FMX.StdCtrls,
  client.interfaces.application, client.classes.dlgmessages, FMX.Objects,
  FMX.StdActns, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.ListBox, FMX.Layouts,
  client.resources.svcconsts, client.interfaces.contatos, client.classes.contatos,
  client.serverintf.contatos;

type
  TFrmMainForm = class(TForm, IChatApplication)
    ActList: TActionList;
    ActConnectService: TAction;
    ActDisconnectService: TAction;
    ImgList: TImageList;
    Panel1: TPanel;
    ImgProfile: TImage;
    ActProfile: TAction;
    PnlServiceInfo: TCalloutPanel;
    ActServiceInfoView: TViewAction;
    LstServiceInfo: TListBox;
    ListBoxHeader1: TListBoxHeader;
    ListBoxItem1: TListBoxItem;
    LstContatos: TListBox;
    procedure ActDisconnectServiceExecute(Sender: TObject);
    procedure ActDisconnectServiceUpdate(Sender: TObject);
    procedure ActConnectServiceUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ActConnectServiceExecute(Sender: TObject);
    procedure ImgProfileClick(Sender: TObject);
    procedure FormShow(Sender: TObject);

  strict private
   FConnected: boolean;
   function GetBitmap(const ImageIndex: integer): TBitmap; inline;

  private
    { Private declarations }
    //IChatApplication
    function GetConnected: boolean;
    procedure SetConnected(const Value: boolean);
    function GetDialogs: IDlgMessage;
    function GetContatosService: IContatosService;
    function GetRemoteService: IChatService;
    function GetTitle: string;
    procedure ListarContatos;

  public
    { Public declarations }

    //IChatApplication
    property Connected: boolean read GetConnected write SetConnected;
    property ContatosService: IContatosService read GetContatosService;
    property Dialogs: IDlgMessage read GetDialogs;
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
 PnlServiceInfo.Visible := False;
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
             ItemObj.Height := 40;
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

procedure TFrmMainForm.ListarContatos;
var
 I: integer;
 ContatosList: TListaContatos;
 MyContatoObj: TMyContato;
 ItemObj: TListBoxItem;
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
          ItemObj.Text :=  MyContatoObj.FirstName.TrimRight;
          ItemObj.Height := 40;
          //ItemObj.ItemData.Bitmap := GetBitmap(3);

          ItemObj.ItemData.Detail:= MyContatoObj.LastName.TrimRight;
          ItemObj.StyleLookup := 'listboxitembottomdetail';
          ItemObj.ItemData.Accessory := TlistBoxItemData.TAccessory(1);
          ItemObj.WordWrap := True;
          ItemObj.Hint := ItemObj.ItemData.Detail;

          LstContatos.AddObject(ItemObj);
         end;
       end;

    finally
     LstContatos.EndUpdate;
     //Não descomentar. Dá memory leak ao chamar o método FREE da classe.
     //if Assigned(ContatosList) then
       //FreeAndNil(ContatosList);
    end;

  end;

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
