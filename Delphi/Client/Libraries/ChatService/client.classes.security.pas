unit client.classes.security;

interface

uses
  System.SysUtils, client.interfaces.security;

 type
   TSecurityService = class(TInterfacedObject, ISecurityService)
     private

     public
       constructor Create;
       destructor Destroy; override;

       //ISecurityService methods
       function Authenticate(const UserName, Password: string): boolean;
       procedure NewSessionId(const UserObj: string; var Session: string);



   end;

implementation

{ TSecurityService }

function TSecurityService.Authenticate(const UserName,
  Password: string): boolean;
begin
 try
   Result := (UserName = 'fake_user') and (Password = 'fake_pass');

 except
   Result := False;
 end;
end;

constructor TSecurityService.Create;
begin
 inherited Create;
end;

destructor TSecurityService.Destroy;
begin
  inherited Destroy;
end;

procedure TSecurityService.NewSessionId(const UserObj: string;
  var Session: string);
begin
 Session := Random(MaxInt).ToString;
end;

end.
