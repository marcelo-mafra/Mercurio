program mercurio;

uses
  System.StartUpCopy,
  FMX.Forms,
  client.application.mainform in 'client.application.mainform.pas' {FrmMainForm};

{$R *.res}

begin
  //Exibe um modal com info sobre vazamento de memória a fechar a app.
  ReportMemoryLeaksOnShutdown := true;

  Application.Initialize;
  Application.CreateForm(TFrmMainForm, FrmMainForm);
  Application.Run;
end.
