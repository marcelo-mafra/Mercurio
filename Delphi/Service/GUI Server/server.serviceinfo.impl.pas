{ Invokable implementation File for TMercurioServiceInfo which implements IMercurioServiceInfo }

unit server.serviceinfo.impl;

interface

uses Soap.InvokeRegistry, System.Types, Soap.XSBuiltIns, server.serviceinfo.intf,
 System.SysUtils, client.resources.svcconsts;

type

  { IMercurioServiceInfo }
  TMercurioServiceInfo = class(TInvokableClass, IMercurioServiceInfo)
  public
    function ServiceInfo: TServiceInfo; stdcall;
  end;

implementation

function TMercurioServiceInfo.ServiceInfo: TServiceInfo;
begin
  Result := TServiceInfo.Create;

  try
   Result.ServiceName := TChatServiceLabels.ServiceName;
   Result.Host := TChatServiceConst.ServiceHost;
   Result.ServerTime := Now;

  finally

  end;
end;


initialization
{ Invokable classes must be registered }
   InvRegistry.RegisterInvokableClass(TMercurioServiceInfo);
end.

