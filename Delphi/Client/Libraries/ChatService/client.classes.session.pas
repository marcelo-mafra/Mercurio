unit client.classes.session;

interface

uses
  System.Classes, System.SysUtils, System.DateUtils;

 type
   TConnectionSession = class(TInterfacedObject)
     private
       FSessionId: string;
       FSessionStart: TDateTime;
       function GetActive: boolean;
       function GetSessionTime: int64;

     public
       constructor Create(const Session: string);
       destructor Destroy; override;

       property Active: boolean read GetActive;
       property SessionId: string read FSessionId;
       property SessionStart: TDateTime read FSessionStart;
       property SessionTime: int64 read GetSessionTime;

   end;

implementation

{ TConnectionSession }

constructor TConnectionSession.Create(const Session: string);
begin
 FSessionId := Session;
 FSessionStart := Now;
end;

destructor TConnectionSession.Destroy;
begin
  inherited;
end;

function TConnectionSession.GetActive: boolean;
begin
 Result := SessionId.Trim <> '';
end;

function TConnectionSession.GetSessionTime: int64;
begin
 Result := SecondsBetween(Now, self.SessionStart);
end;

end.
