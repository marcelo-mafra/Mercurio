unit client.model.observerscon;

interface

uses
  System.Classes, System.SysUtils, client.interfaces.observerscon;

type
  TStatusEvent = procedure (Sender: TObject; const Value: TConnectionStatus) of object;

  TObserverConnection = class(TInterfacedObject, IObserverConnection)
   private
    FConnected: boolean;
    FStatus: TConnectionStatus;
    FOnStatus: TStatusEvent;
    procedure DoStatus(const Value: TConnectionStatus);

   protected
    constructor Create(OnStatus: TStatusEvent);
    //IObserverConnection
    procedure ChangedStatus(Sender: TObject; Status: TConnectionStatus);

   public
    destructor Destroy; override;
    class function New(OnStatus: TStatusEvent): IObserverConnection;

    property Connected: boolean read FConnected;
  end;

  TObserversConnection = class(TInterfacedObject, IObserversConnection)
  private
    FList: IInterfaceList;

  protected
    constructor Create;
    //IObserversConnection
    function Add(Observer: IObserverConnection): IObserversConnection;
    function Get(const Index: Integer): IObserverConnection;
    function Count: integer;
    procedure NotifyObjects(Sender: TObject; Status: TConnectionStatus);

  public
    class function New: IObserversConnection;
  end;

implementation

{ TObserverConnection }

procedure TObserverConnection.ChangedStatus(Sender: TObject;
  Status: TConnectionStatus);
begin
 case status of
   csConnected: FConnected := True;
   csInactive:  FConnected := False;
 end;

 if Status <> FStatus then
  begin
    FStatus := Status;
    DoStatus(Status);
  end;
end;

constructor TObserverConnection.Create(OnStatus: TStatusEvent);
begin
  inherited Create;
  FStatus := csInactive;//default
  FOnStatus := OnStatus;
end;

destructor TObserverConnection.Destroy;
begin
  FOnStatus := nil;
  inherited;
end;

procedure TObserverConnection.DoStatus(const Value: TConnectionStatus);
begin
 if Assigned(FOnStatus) then FOnStatus(self, Value);
end;

class function TObserverConnection.New(
  OnStatus: TStatusEvent): IObserverConnection;
begin
 Result := TObserverConnection.Create(OnStatus) ;
end;



{ TObserversConnection }

function TObserversConnection.Add(
  Observer: IObserverConnection): IObserversConnection;
begin
  Result := self;
  FList.Add(Observer);
end;

procedure TObserversConnection.NotifyObjects(Sender: TObject;
  Status: TConnectionStatus);
var
  I: Integer;
  IObserver:  IObserverConnection;
begin
  for I := 0 to Count -1 do
   begin
    IObserver := self.Get(I);
    IObserver.ChangedStatus(Sender, Status);
   end;
end;

function TObserversConnection.Count: Integer;
begin
  Result := FList.Count;
end;

constructor TObserversConnection.Create;
begin
  inherited Create;
  FList := TInterfaceList.Create;
end;

function TObserversConnection.Get(const Index: Integer): IObserverConnection;
begin
  Result := FList.Items[Index] as IObserverConnection;
end;

class function TObserversConnection.New: IObserversConnection;
begin
  Result := TObserversConnection.Create;
end;

end.
