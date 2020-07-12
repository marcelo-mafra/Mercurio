program mercurio;

uses
  System.StartUpCopy,
  FMX.Forms,
  client.view.mainform in 'client.view.mainform.pas' {FrmMainForm},
  client.view.navegatelist in 'client.view.navegatelist.pas',
  client.view.mainform.helpers in 'client.view.mainform.helpers.pas',
  client.view.contatos.fmedetailed in 'Libraries\Contatos\client.view.contatos.fmedetailed.pas' {FmeContatosDetailedView: TFrame};

{$R *.res}

begin
  {$WARNINGS OFF}
  //Exibe info sobre vazamento de memória ao fechar a app caso em modo debug.
  ReportMemoryLeaksOnShutdown := (DebugHook <> 0);
  {$WARNINGS ON}
  Application.Initialize;
  Application.CreateForm(TFrmMainForm, FrmMainForm);
  Application.Run;
end.
