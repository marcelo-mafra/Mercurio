unit client.classes.security;

interface

uses
  client.interfaces.security;

 type
   TSecurityService = class(TInterfacedObject, ISecurityService)
     private

     public
       constructor Create;
       destructor Destroy; override;

       //ISecurityService methods
       function Authenticate(const UserName, Password: string): boolean;
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

end.
