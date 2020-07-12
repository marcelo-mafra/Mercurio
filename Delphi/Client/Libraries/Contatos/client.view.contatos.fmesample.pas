unit client.view.contatos.fmesample;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListBox, FMX.Controls.Presentation, FMX.Edit, FMX.SearchBox, FMX.Layouts,
  client.model.listacontatos, client.serverintf.contatos, client.interfaces.contatos,
  client.resources.mercurio;

type
  TFmeContatosSampleView = class(TFrame)
    LstContatos: TListBox;
    ListBoxItem2: TListBoxItem;
    SearchBox1: TSearchBox;
    ListBoxHeader2: TListBoxHeader;
    SpeedButton5: TSpeedButton;
    Label2: TLabel;
  strict private
   FIContatosService: IContatosService;
   FConnected: boolean;

  private
    { Private declarations }
    procedure ListContacts;

  public
    { Public declarations }
    constructor Create(IService: IContatosService; Parent: TFmxObject); reintroduce;
    property  Connected: boolean read FConnected;
    property ContatosService: IContatosService read FIContatosService;
  end;

implementation

{$R *.fmx}

{ TFmeContatosSampleView }

constructor TFmeContatosSampleView.Create(IService: IContatosService;
  Parent: TFmxObject);
begin
  inherited Create(self);
  FIContatosService := IService;
  self.Parent := Parent;
  self.Align := TAlignLayout.Client;
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

end.
