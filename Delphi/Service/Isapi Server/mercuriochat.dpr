library mercuriochat;

uses
  Winapi.ActiveX,
  System.Win.ComObj,
  Web.WebBroker,
  Web.Win.ISAPIApp,
  Web.Win.ISAPIThreadPool,
  server.application.webmodule in 'server.application.webmodule.pas' {WebModuleMercurio: TWebModule},
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
  server.json.consts in '..\server.json.consts.pas',
  server.accounts.controller.factory in '..\server.accounts.controller.factory.pas',
  server.accounts.controller in '..\server.accounts.controller.pas',
  server.accounts.data.factory in '..\server.accounts.data.factory.pas',
  server.accounts.interfaces in '..\server.accounts.interfaces.pas',
  server.chatserver.controller.factory in '..\server.chatserver.controller.factory.pas',
  server.chatserver.controller in '..\server.chatserver.controller.pas',
  server.chatserver.data.factory in '..\server.chatserver.data.factory.pas',
  server.chatserver.data in '..\server.chatserver.data.pas',
  server.chatserver.interfaces in '..\server.chatserver.interfaces.pas',
  server.common.interfaces in '..\server.common.interfaces.pas',
  server.contatos.controller.factory in '..\server.contatos.controller.factory.pas',
  server.contatos.controller in '..\server.contatos.controller.pas',
  server.contatos.data.factory in '..\server.contatos.data.factory.pas',
  server.contatos.interfaces in '..\server.contatos.interfaces.pas',
  server.permissions.controller.factory in '..\server.permissions.controller.factory.pas',
  server.permissions.controller in '..\server.permissions.controller.pas',
  server.permissions.interfaces in '..\server.permissions.interfaces.pas',
  server.serviceinfo.controller in '..\server.serviceinfo.controller.pas',
  server.serviceinfo.interfaces in '..\server.serviceinfo.interfaces.pas';

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
