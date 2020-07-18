unit client.view.contatos.fmedetailed;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  client.data.contatos, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Components,
  Data.Bind.DBScope, FMX.ListView, client.interfaces.contatos, client.classes.session,
  client.model.connection.factory, client.serverintf.contatos,
  client.interfaces.observerscon;

type
  TFmeContatosDetailedView = class(TFrame, IContatosFrame, IObserverConnection)
    ContactsListview: TListView;
    BindContatos: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkFillControlToField1: TLinkFillControlToField;
  private
    { Private declarations }
    FSessionObj: TConnectionSession;
    FStatus: TConnectionStatus;
    FContatosData: TContatosData;
    procedure DoOnDestroyEvent(Sender: TObject);
    //IContatosFrame
    function GetConnected: boolean;
    function GetSelectedContact: TMyContato;
    procedure DeleteSelected;
    procedure UpdateData;

  public
    { Public declarations }
    procedure Init;
    //IObserverConnection
    procedure ChangedStatus(Sender: TObject; Status: TConnectionStatus);

   //IContatosFrame
   property Connected: boolean read GetConnected;
   property SelectedContact: TMyContato read GetSelectedContact;
  end;

implementation

{$R *.fmx}

{ TFmeContatosDetailedView }

function TFmeContatosDetailedView.GetConnected: boolean;
begin
 Result := FStatus = (csConnected);
 //Result := TFactoryServiceConnection.New(FSessionObj).Connected;
end;

function TFmeContatosDetailedView.GetSelectedContact: TMyContato;
begin
 if (ContactsListView.Selected <> nil) then
   Result := nil//TMyContato(ContactsListView.Selected.TagObject)
 else
   Result := nil;
end;

procedure TFmeContatosDetailedView.Init;
begin
 FStatus := csInactive;//default
 if not Assigned(FContatosData) then
  FContatosData := TContatosData.Create(BindContatos);

 FContatosData.OnDestroy := DoOnDestroyEvent;
end;

procedure TFmeContatosDetailedView.UpdateData;
begin
 if BindContatos.DataSet <> nil then BindContatos.DataSet.Refresh;
end;

procedure TFmeContatosDetailedView.ChangedStatus(Sender: TObject;
  Status: TConnectionStatus);
begin
 FStatus := Status;
 if Status = csConnected then
   self.UpdateData;
end;

procedure TFmeContatosDetailedView.DeleteSelected;
begin
 self.UpdateData;
end;

procedure TFmeContatosDetailedView.DoOnDestroyEvent(Sender: TObject);
begin
 BindContatos.DataSet := nil;
 if not Assigned(FContatosData) then FreeAndNil(FContatosData);
end;

end.
