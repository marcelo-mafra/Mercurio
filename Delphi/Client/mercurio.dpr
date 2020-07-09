program mercurio;

uses
  System.StartUpCopy,
  FMX.Forms,
  client.view.mainform in 'client.view.mainform.pas' {FrmMainForm},
  client.view.navegatelist in 'client.view.navegatelist.pas';

{$R *.res}

begin
  //Exibe um modal com info sobre vazamento de memória a fechar a app.
  ReportMemoryLeaksOnShutdown := true;

  Application.Initialize;
  Application.CreateForm(TFrmMainForm, FrmMainForm);
  Application.Run;
end.
