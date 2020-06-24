unit client.application.mainform;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  client.interfaces.service, client.classes.svccon, System.Actions, FMX.ActnList,
  System.ImageList, FMX.ImgList, FMX.Controls.Presentation, FMX.StdCtrls;

type
  TFrmMainForm = class(TForm)
    ActList: TActionList;
    ActConnectService: TAction;
    ActDisconnectService: TAction;
    ImgList: TImageList;
    ActionList1: TActionList;
    Button1: TButton;
    Button2: TButton;
    procedure ActDisconnectServiceExecute(Sender: TObject);
    procedure ActDisconnectServiceUpdate(Sender: TObject);
    procedure ActConnectServiceUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ActConnectServiceExecute(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    FMercurioObj: TChatService;
    function GetMercurio: IChatService;

  public
    { Public declarations }
    property MercurioIntf: IChatService read GetMercurio;
  end;

var
  FrmMainForm: TFrmMainForm;

implementation

{$R *.fmx}

procedure TFrmMainForm.ActConnectServiceExecute(Sender: TObject);
begin
 if not MercurioIntf.ConnectService then
  Tag := 0;
end;

procedure TFrmMainForm.ActConnectServiceUpdate(Sender: TObject);
begin
 TAction(Sender).Enabled := (Assigned(FMercurioObj)) and (MercurioIntf <> nil) and
   (MercurioIntf.Connected = False);
end;

procedure TFrmMainForm.ActDisconnectServiceExecute(Sender: TObject);
begin
 MercurioIntf.DisconnectService;
end;

procedure TFrmMainForm.ActDisconnectServiceUpdate(Sender: TObject);
begin
 TAction(Sender).Enabled := (MercurioIntf <> nil) and (MercurioIntf.Connected = True);
end;

procedure TFrmMainForm.Button1Click(Sender: TObject);
begin
 MercurioIntf.ConnectService;
end;

procedure TFrmMainForm.Button2Click(Sender: TObject);
begin
 MercurioIntf.DisconnectService;
end;

procedure TFrmMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if Assigned(FMercurioObj) then
  begin
    MercurioIntf.DisconnectService;
   //FreeAndNil(FMercurioObj);
  end;
end;

procedure TFrmMainForm.FormCreate(Sender: TObject);
begin
 FMercurioObj := TChatService.Create;
end;

function TFrmMainForm.GetMercurio: IChatService;
begin
 Result := nil;
 if FMercurioObj <> nil then
   Result := FMercurioObj as IChatService;
end;

end.
