unit mercurio.client.classes.security;

interface

uses
 System.SysUtils, mercurio.client.interfaces.service;

 type
   TSecurityService = class(TInterfacedObject, ISecurityService)
     private

     public
       constructor Create;
       destructor Destroy; override;

       //ISecurityService
       function Authenticate(const UserName, Password: string): boolean;
 end;

implementation

{ TSecurityService }

function TSecurityService.Authenticate(const UserName,
  Password: string): boolean;
begin
 try
   Result := True;

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
