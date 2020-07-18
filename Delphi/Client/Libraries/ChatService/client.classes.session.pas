unit client.classes.session;

interface

uses
  System.Classes, System.SysUtils;

 type
   TConnectionSession = class(TInterfacedObject)
     private
       FSessionId: string;
       function GetActive: boolean;

     public
       constructor Create(const Session: string);
       destructor Destroy; override;

       property Active: boolean read GetActive;
       property SessionId: string read FSessionId;

   end;

implementation

{ TConnectionSession }

constructor TConnectionSession.Create(const Session: string);
begin
 FSessionId := Session;
end;

destructor TConnectionSession.Destroy;
begin

  inherited;
end;

function TConnectionSession.GetActive: boolean;
begin
 Result := SessionId.Trim <> '';
end;

end.
