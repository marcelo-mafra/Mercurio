unit client.classes.security;

interface

uses
  System.SysUtils, client.interfaces.security, classes.exceptions.connection;

 type
   TOnAuthenticateSucessEvent = procedure(Sender: TObject; const UserName, Password: string) of object;
   TOnAuthenticateFailureEvent = procedure(Sender: TObject; const UserName, Password: string; E: Exception) of object;

   TSecurityService = class(TInterfacedObject, ISecurityService)
     private
      FOnAuthenticateFailure: TOnAuthenticateFailureEvent;
      FOnAuthenticateSucess: TOnAuthenticateSucessEvent;

     public
       constructor Create;
       destructor Destroy; override;

       //ISecurityService methods
       function Authenticate(const UserName, Password: string): boolean;
       procedure NewSessionId(const UserObj: string; var Session: string);
       property OnAuthenticateFailure: TOnAuthenticateFailureEvent read FOnAuthenticateFailure write FOnAuthenticateFailure;
       property OnAuthenticateSucess: TOnAuthenticateSucessEvent read FOnAuthenticateSucess write FOnAuthenticateSucess;

   end;

implementation

{ TSecurityService }

function TSecurityService.Authenticate(const UserName,
  Password: string): boolean;
begin
 try
   Result := (UserName = 'fake_user') and (Password = 'fake_pass');
   if not Result then
    raise EAuthenticationError.Create;

   if Assigned(FOnAuthenticateSucess) then FOnAuthenticateSucess(self, UserName, Password);

 except
  on E: Exception do
   begin
    Result := False;
    if Assigned(FOnAuthenticateFailure) then
     FOnAuthenticateFailure(self, UserName, Password, E);
   end;
 end;
end;

constructor TSecurityService.Create;
begin
 inherited Create;
end;

destructor TSecurityService.Destroy;
begin
  FOnAuthenticateFailure := nil;
  FOnAuthenticateSucess := nil;
  inherited Destroy;
end;

procedure TSecurityService.NewSessionId(const UserObj: string;
  var Session: string);
begin
 Session := Random(MaxInt).ToString;
end;

end.
