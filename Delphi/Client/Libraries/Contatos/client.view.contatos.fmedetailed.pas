unit client.view.contatos.fmedetailed;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  client.data.contatos, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Components,
  Data.Bind.DBScope, FMX.ListView;

type
  TFmeContatosDetailedView = class(TFrame)
    ContactsListview: TListView;
    BindContatos: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkFillControlToField1: TLinkFillControlToField;
  private
    { Private declarations }
    FContatosData: TContatosData;
    procedure DoOnDestroyEvent(Sender: TObject);
  public
    { Public declarations }
    procedure Init;
  end;

implementation

{$R *.fmx}

{ TFmeContatosDetailedView }

procedure TFmeContatosDetailedView.Init;
begin
 if not Assigned(FContatosData) then
  FContatosData := TContatosData.Create(BindContatos);

 FContatosData.OnDestroy := DoOnDestroyEvent;
end;

procedure TFmeContatosDetailedView.DoOnDestroyEvent(Sender: TObject);
begin
 BindContatos.DataSet := nil;
 if not Assigned(FContatosData) then FreeAndNil(FContatosData);
end;

end.
