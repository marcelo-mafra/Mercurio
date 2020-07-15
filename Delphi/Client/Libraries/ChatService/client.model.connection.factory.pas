unit client.model.connection.factory;

interface

uses
 client.interfaces.connection, client.model.connection;

type
  TFactoryServiceConnection = class
    class function New: IServiceConnection; overload;
    class function New(OnConnectEvent: TOnConnectEvent; OnConnectErrorEvent:
       TOnConnectErrorEvent; OnDisconnectEvent: TOnDisconnectEvent): IServiceConnection; overload;
  end;

implementation

{ TFactoryServiceConnection }

class function TFactoryServiceConnection.New: IServiceConnection;
begin
{Retorna uma interface que abstrai recursos de conex�o com o servi�o remoto.}
  Result := TServiceConnection.Create as IServiceConnection;
end;

class function TFactoryServiceConnection.New(OnConnectEvent: TOnConnectEvent;
  OnConnectErrorEvent: TOnConnectErrorEvent;
  OnDisconnectEvent: TOnDisconnectEvent): IServiceConnection;
begin
{Retorna uma interface que abstrai recursos de conex�o com o servi�o remoto.
Nessa vers�o do m�todo, usa-se eventos definidos pelo chamador e n�o os
eventos interno de TServiceConnection.}
  Result := TServiceConnection.Create(OnConnectEvent, OnConnectErrorEvent,
    OnDisconnectEvent) as IServiceConnection;
end;

end.
