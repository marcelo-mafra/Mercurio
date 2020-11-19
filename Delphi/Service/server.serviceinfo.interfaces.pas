unit server.serviceinfo.interfaces;

interface

 uses
  System.Classes, server.common.interfaces, server.serviceinfo.intf;

 type
   IServiceInfoController = interface(IServerInterface)
     ['{5270F312-6655-4C3A-A9E0-497563AB7F6B}']
     function ServiceInfo: TServiceInfo;
   end;

implementation

end.
