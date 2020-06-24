program mercurio;

uses
  System.StartUpCopy,
  FMX.Forms,
  client.application.mainform in 'client.application.mainform.pas' {FrmMainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMainForm, FrmMainForm);
  Application.Run;
end.
