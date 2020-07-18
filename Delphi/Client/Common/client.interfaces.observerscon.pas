unit client.interfaces.observerscon;

interface

type
 TConnectionStatus = (csConnected, csInactive);

 IObserverConnection = interface
 ['{B790F255-065D-46CA-8326-1934B7E74897}']

 procedure ChangedStatus(Sender: TObject; Status: TConnectionStatus);
 end;

 IObserversConnection = interface
 ['{CF6B01A6-94D8-4253-A4C1-FF7C174C6FD4}']

 function Add(Observer: IObserverConnection): IObserversConnection;
 function Get(const Index: integer): IObserverConnection;
 function Count: integer;

 procedure NotifyObjects(Sender: TObject; Status: TConnectionStatus);
 end;

implementation

end.
