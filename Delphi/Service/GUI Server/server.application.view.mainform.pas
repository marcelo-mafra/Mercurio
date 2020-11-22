unit server.application.view.mainform;

interface

uses
  Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.AppEvnts, Vcl.StdCtrls,
  IdHTTPWebBrokerBridge, Web.HTTPApp;

type
  TForm1 = class(TForm)
    ButtonStart: TButton;
    ButtonStop: TButton;
    EditPort: TEdit;
    Label1: TLabel;
    ApplicationEvents1: TApplicationEvents;
    ButtonOpenBrowser: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure ButtonStartClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure ButtonOpenBrowserClick(Sender: TObject);
  private
    FHTTPServer: TIdHTTPWebBrokerBridge;
    procedure StartServer;
    { Private declarations }
  public
    { Public declarations }
    property HTTPServer: TIdHTTPWebBrokerBridge read FHTTPServer;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  WinApi.Windows, Winapi.ShellApi;

procedure TForm1.ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
begin
  ButtonStart.Enabled := not HTTPServer.Active;
  ButtonStop.Enabled := HTTPServer.Active;
  EditPort.Enabled := not HTTPServer.Active;
end;

procedure TForm1.ButtonOpenBrowserClick(Sender: TObject);
const
 BaseUrl = 'http://localhost:%s';
var
  LURL: string;
begin
  StartServer;
  LURL := Format(BaseUrl, [EditPort.Text]);
  ShellExecute(0, nil, PChar(LURL), nil, nil, SW_SHOWNOACTIVATE);
end;

procedure TForm1.ButtonStartClick(Sender: TObject);
begin
  StartServer;
end;

procedure TForm1.ButtonStopClick(Sender: TObject);
begin
  HTTPServer.Active := False;
  HTTPServer.Bindings.Clear;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FHTTPServer := TIdHTTPWebBrokerBridge.Create(Self);
end;

procedure TForm1.StartServer;
begin
  if not HTTPServer.Active then
  begin
    HTTPServer.Bindings.Clear;
    HTTPServer.DefaultPort := StrToInt(EditPort.Text);
    HTTPServer.Active := True;
  end;
end;

end.
