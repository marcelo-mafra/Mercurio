{ Invokable interface IMercurioServiceInfo }

unit server.serviceinfo.intf;

interface

uses Soap.InvokeRegistry, System.Types, Soap.XSBuiltIns;

type

  TServiceInfo = class(TRemotable)
  private
    FServiceName: string;
    FHost: string;
    FServerTime: TDateTime;
  published
    property ServiceName: string read FServiceName write FServiceName;
    property Host: string read FHost write FHost;
    property ServerTime: TDateTime read FServerTime write FServerTime;
  end;

  { Invokable interfaces must derive from IInvokable }
  IMercurioServiceInfo = interface(IInvokable)
  ['{381FB9B9-1033-4887-B5DB-E13EE44C3C6C}']

    { Methods of Invokable interface must not use the default }
    { calling convention; stdcall is recommended }
    function ServiceInfo: TServiceInfo; stdcall;
  end;

implementation

initialization
  { Invokable interfaces must be registered }
  InvRegistry.RegisterInterface(TypeInfo(IMercurioServiceInfo));

end.
