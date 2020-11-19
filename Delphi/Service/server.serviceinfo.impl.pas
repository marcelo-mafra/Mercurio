{ Invokable implementation File for TMercurioServiceInfo which implements IMercurioServiceInfo }

unit server.serviceinfo.impl;

interface

uses Soap.InvokeRegistry, System.Types, Soap.XSBuiltIns, System.SysUtils,
server.serviceinfo.intf, server.serviceinfo.interfaces,
server.serviceinfo.controller;

type

  { IMercurioServiceInfo }
  TMercurioServiceInfo = class(TInvokableClass, IMercurioServiceInfo)
  strict private
    function GetController: IServiceInfoController;

  public
    function ServiceInfo: TServiceInfo; stdcall;

    property Controller: IServiceInfoController read GetController;
  end;

implementation

function TMercurioServiceInfo.GetController: IServiceInfoController;
begin
 Result := TServiceInfoController.New;
end;

function TMercurioServiceInfo.ServiceInfo: TServiceInfo;
begin
  Result := self.Controller.ServiceInfo;
end;


initialization
{ Invokable classes must be registered }
   InvRegistry.RegisterInvokableClass(TMercurioServiceInfo);
end.

