program mercurio;

uses
  System.StartUpCopy,
  FMX.Forms,
  client.application.mainform in 'client.application.mainform.pas' {FrmMainForm},
  client.classes.viewitems in 'client.classes.viewitems.pas';

{$R *.res}

begin
  //Exibe um modal com info sobre vazamento de mem�ria a fechar a app.
  ReportMemoryLeaksOnShutdown := true;

  Application.Initialize;
  Application.CreateForm(TFrmMainForm, FrmMainForm);
  Application.Run;
end.
