library mercuriochat;

uses
  Winapi.ActiveX,
  System.Win.ComObj,
  Web.WebBroker,
  Web.Win.ISAPIApp,
  Web.Win.ISAPIThreadPool,
  server.webmodule in 'server.webmodule.pas' {WebModuleMercurio: TWebModule},
  server.accounts.data in '..\server.accounts.data.pas',
  server.accounts.impl in '..\server.accounts.impl.pas',
  server.accounts.intf in '..\server.accounts.intf.pas',
  server.chatserver.impl in '..\server.chatserver.impl.pas',
  server.chatserver.intf in '..\server.chatserver.intf.pas',
  server.contatos.data in '..\server.contatos.data.pas',
  server.contatos.impl in '..\server.contatos.impl.pas',
  server.contatos.intf in '..\server.contatos.intf.pas',
  server.permissions.data in '..\server.permissions.data.pas',
  server.permissions.impl in '..\server.permissions.impl.pas',
  server.permissions.intf in '..\server.permissions.intf.pas',
  server.serviceinfo.impl in '..\server.serviceinfo.impl.pas',
  server.serviceinfo.intf in '..\server.serviceinfo.intf.pas',
  server.permissions.data.factory in '..\server.permissions.data.factory.pas',
  server.json.consts in '..\server.json.consts.pas';

{$R *.res}

exports
  GetExtensionVersion,
  HttpExtensionProc,
  TerminateExtension;

begin
  CoInitFlags := COINIT_MULTITHREADED;
  Application.Initialize;
  Application.WebModuleClass := WebModuleClass;
  Application.Run;
end.
