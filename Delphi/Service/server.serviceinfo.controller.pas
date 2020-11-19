unit server.serviceinfo.controller;

interface

 uses
  System.Classes, System.SysUtils,
  server.serviceinfo.intf, server.serviceinfo.interfaces, client.resources.serviceparams,
  client.resources.servicelabels;

 type

   TServiceInfoController = class(TInterfacedObject, IServiceInfoController)
    private

    public
     class function New: IServiceInfoController;

     function ServiceInfo: TServiceInfo;
   end;

implementation

{ TServiceInfoController }

class function TServiceInfoController.New: IServiceInfoController;
begin
 Result := TServiceInfoController.Create as IServiceInfoController;
end;

function TServiceInfoController.ServiceInfo: TServiceInfo;
begin
  Result := TServiceInfo.Create;
  Result.ServiceName := TServiceLabels.ServiceName;
  Result.Host := TServiceParams.ServiceHost;
  Result.ServerTime := Now;
end;

end.
