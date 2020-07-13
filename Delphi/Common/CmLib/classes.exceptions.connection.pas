unit classes.exceptions.connection;

interface

uses System.SysUtils, classes.exceptions, client.resources.connection,
 client.resources.httpstatus;

type
 //Valors inválidos de url
 EInvalidURL = class(EMercurioException)
  public
   constructor Create; override;
 end;

 //Exceções relacionadas à comunicação com o serviço remoto.
 ENoServiceResponse = class(EMercurioException)
  public
   constructor Create; override;
 end;

 EHTTPStatus        = class(EMercurioException)
  public
   constructor Create(const StatusCode: integer); reintroduce; overload; virtual;
 end;

 EHTTPBadRequest    = class(EMercurioException)
  public
   constructor Create; override;
 end;

 EAuthenticationError = class(EMercurioException)
  public
   constructor Create; override;
 end;

implementation

{ EInvalidURL }

constructor EInvalidURL.Create;
begin
   inherited;
  Message := TConnectionError.InvalidUrl;
end;

{ EHTTPBadRequest }

constructor EHTTPBadRequest.Create;
begin
  inherited;
  Message := TConnectionError.StatusBadRequest;
end;

{ ENoServiceResponse }

constructor ENoServiceResponse.Create;
begin
  inherited;
  Message := TConnectionError.NoServiceResponse;
end;


{ EHTTPStatus }

constructor EHTTPStatus.Create(const StatusCode: integer);
var
HttpMessage: string;
begin
  inherited;
  HttpMessage := THTTPStatus.ToText(StatusCode);
  Message := string.Format(TConnectionError.HttpStatus, [StatusCode, HttpMessage]);
end;

{ EAuthenticationError }

constructor EAuthenticationError.Create;
begin
  inherited;
  Message := 'Usuário ou senha incorretos!';
end;

end.
