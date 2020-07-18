unit client.model.connection.factory;

interface

uses
 client.interfaces.connection, client.model.connection, client.classes.session;

type
  TFactoryServiceConnection = class
    class function New(const SessionObj: TConnectionSession): IServiceConnection; overload;
    class function New(const SessionObj: TConnectionSession;
       OnConnectEvent: TOnConnectEvent; OnConnectErrorEvent:
       TOnConnectErrorEvent; OnDisconnectEvent: TOnDisconnectEvent): IServiceConnection; overload;
  end;

implementation

{ TFactoryServiceConnection }

class function TFactoryServiceConnection.New(const SessionObj: TConnectionSession): IServiceConnection;
begin
{Retorna uma interface que abstrai recursos de conex�o com o servi�o remoto.}
  Result := TServiceConnection.Create(SessionObj) as IServiceConnection;
end;

class function TFactoryServiceConnection.New(const SessionObj: TConnectionSession;
  OnConnectEvent: TOnConnectEvent; OnConnectErrorEvent: TOnConnectErrorEvent;
  OnDisconnectEvent: TOnDisconnectEvent): IServiceConnection;
begin
{Retorna uma interface que abstrai recursos de conex�o com o servi�o remoto.
Nessa vers�o do m�todo, usa-se eventos definidos pelo chamador e n�o os
eventos interno de TServiceConnection.}
  Result := TServiceConnection.Create(SessionObj, OnConnectEvent, OnConnectErrorEvent,
    OnDisconnectEvent) as IServiceConnection;
end;

end.
