program chatserver;
{$APPTYPE GUI}

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  server.classes.mainform in 'server.classes.mainform.pas' {Form1},
  server.webmodule in 'server.webmodule.pas' {WebModuleMercurio: TWebModule},
  server.chatserver.impl in 'server.chatserver.impl.pas',
  server.chatserver.intf in 'server.chatserver.intf.pas';

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
