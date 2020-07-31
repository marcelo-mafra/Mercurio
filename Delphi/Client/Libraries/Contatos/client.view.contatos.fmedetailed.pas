unit client.view.contatos.fmedetailed;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.Components, Data.Bind.DBScope, FMX.ListView,
  //Mercúrio units
  client.data.contatos, client.interfaces.contatos, client.classes.session,
  client.model.connection.factory, client.serverintf.contatos,
  client.interfaces.observerscon, System.Rtti, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.StorageBin, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TFmeContatosDetailedView = class(TFrame, IContatosFrame, IObserverConnection)
    ContactsListview: TListView;
    BindContatos: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkFillControlToField1: TLinkFillControlToField;
    dsContatos: TFDMemTable;
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
 Result := FStatus = (TConnectionStatus.csConnected);
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
 FStatus := TConnectionStatus.csInactive;//default

 if not Assigned(FContatosData) then
  begin
   FContatosData := TContatosData.Create(BindContatos);
   BindContatos.DataSet := self.dsContatos;// FContatosData.dsContatos;
   LinkFillControlToField1.FillDataSource := BindContatos;
   LinkFillControlToField1.Control := ContactsListview;
  end;

 FContatosData.OnDestroy := DoOnDestroyEvent;
 self.UpdateData;
end;

procedure TFmeContatosDetailedView.UpdateData;
var
 IService: IContactsService;
begin
 if (BindContatos.DataSet <> nil) and (Application.MainForm <> nil) then
  begin
   IService := Application.MainForm as IContactsService;
   IService.GetMyContatos(BindContatos.DataSet);
  end;
end;

procedure TFmeContatosDetailedView.ChangedStatus(Sender: TObject;
  Status: TConnectionStatus);
begin
 FStatus := Status;
 if Status = TConnectionStatus.csConnected then
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
