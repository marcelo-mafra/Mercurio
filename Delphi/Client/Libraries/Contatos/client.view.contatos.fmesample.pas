unit client.view.contatos.fmesample;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListBox, FMX.Controls.Presentation, FMX.Edit, FMX.SearchBox, FMX.Layouts,
  client.model.listacontatos, client.serverintf.contatos, client.interfaces.contatos,
  client.resources.mercurio, client.data.contatos, client.model.contatos,
  client.model.connection.factory;

type
  TFmeContatosSampleView = class(TFrame, IContatosFrame)
    LstContatos: TListBox;
    ListBoxItem2: TListBoxItem;
    SearchBox1: TSearchBox;
    ListBoxHeader2: TListBoxHeader;
    BtnUpdate: TSpeedButton;
    Label2: TLabel;
  strict private

   FContatosData: TContatosData;

  private
    { Private declarations }
    procedure ListContacts;
    procedure DoOnDestroyEvent(Sender: TObject);
    procedure Init;
    function GetIContactsService: IContactsService;
    //IContatosFrame
    function GetConnected: boolean;
    function GetSelectedContact: TMyContato;
    procedure UpdateData;

  public
    { Public declarations }
    constructor Create(Parent: TFmxObject; UpdateAction: TBasicAction); reintroduce;
    property ContactsService: IContactsService read GetIContactsService ;
    //IContatosFrame
    property Connected: boolean read GetConnected;
    property SelectedContact: TMyContato read GetSelectedContact;

  end;

implementation

{$R *.fmx}

{ TFmeContatosSampleView }

constructor TFmeContatosSampleView.Create(Parent: TFmxObject; UpdateAction: TBasicAction);
begin
  inherited Create(nil);
  self.Parent := Parent;
  self.Align := TAlignLayout.Client;
  BtnUpdate.Action := UpdateAction;
  self.Init;
end;

procedure TFmeContatosSampleView.DoOnDestroyEvent(Sender: TObject);
begin
 if not Assigned(FContatosData) then FreeAndNil(FContatosData);
end;

function TFmeContatosSampleView.GetConnected: boolean;
begin
 Result := TFactoryServiceConnection.New.Connected;
end;

function TFmeContatosSampleView.GetIContactsService: IContactsService;
begin
  //Interface que abstrai o serviço remoto de contatos do usuário.
  Result := TContatosModel.Create(nil, nil) as IContactsService;
end;

function TFmeContatosSampleView.GetSelectedContact: TMyContato;
begin
 if (LstContatos.Selected <> nil) then
   Result := TMyContato(LstContatos.Selected.Data)
 else
   Result := nil;
end;

procedure TFmeContatosSampleView.Init;
begin
 if not Assigned(FContatosData) then
  FContatosData := TContatosData.Create(nil);

 FContatosData.OnDestroy := DoOnDestroyEvent;
 self.ListContacts;
end;

procedure TFmeContatosSampleView.ListContacts;
var
 I: integer;
 ListObj: TListaContatos;
 MyContatoObj: TMyContato;
 ItemObj: TListBoxItem;
 FullName: string;
begin
{Busca no serviço remoto os contatos do usuário corrente.}
 if Connected then
  begin
    ListObj := TListaContatos.Create;

    try
      ContactsService.GetMyContatos(ListObj);

      if ListObj.IsEmpty then Exit;

      LstContatos.BeginUpdate;
      LstContatos.Clear;

      for I := 0 to ListObj.Count - 1 do
       begin
        MyContatoObj := ListObj.FindObject(I);

        if MyContatoObj <> nil then
         begin
          ItemObj := TListBoxItem.Create(LstContatos);
          FullName := string.Empty;
          FullName := FullName.Join(' ', [MyContatoObj.FirstName.TrimRight, MyContatoObj.LastName.TrimRight]);
          ItemObj.Text := FullName;
          ItemObj.Height := 37;
          //ItemObj.ItemData.Bitmap := GetBitmap(3);

          ItemObj.ItemData.Detail := MyContatoObj.ContatoId;
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

procedure TFmeContatosSampleView.UpdateData;
begin
 self.ListContacts;
end;

end.
