program chatclient;

uses
  System.StartUpCopy,
  FMX.Forms,
  mychat.mainform in 'mychat.mainform.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
