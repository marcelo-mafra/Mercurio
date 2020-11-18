program chatserver;
{$APPTYPE GUI}

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  server.classes.mainform in 'server.classes.mainform.pas' {Form1},
  server.webmodule in 'server.webmodule.pas' {WebModuleMercurio: TWebModule},
  server.chatserver.impl in '..\server.chatserver.impl.pas',
  server.chatserver.intf in '..\server.chatserver.intf.pas',
  server.contatos.intf in '..\server.contatos.intf.pas',
  server.contatos.impl in '..\server.contatos.impl.pas',
  server.contatos.data in '..\server.contatos.data.pas',
  server.serviceinfo.intf in '..\server.serviceinfo.intf.pas',
  server.serviceinfo.impl in '..\server.serviceinfo.impl.pas',
  server.permissions.intf in '..\server.permissions.intf.pas',
  server.permissions.impl in '..\server.permissions.impl.pas',
  server.permissions.data in '..\server.permissions.data.pas',
  server.accounts.intf in '..\server.accounts.intf.pas',
  server.accounts.data in '..\server.accounts.data.pas',
  server.accounts.impl in '..\server.accounts.impl.pas',
  server.permissions.interfaces in '..\server.permissions.interfaces.pas',
  server.permissions.data.factory in '..\server.permissions.data.factory.pas',
  server.json.consts in '..\server.json.consts.pas';

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
