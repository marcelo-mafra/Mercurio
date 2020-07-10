unit classes.exceptions;

interface

uses
 System.SysUtils, client.resources.connection, client.resources.httpstatus,
 client.resources.chatmessages;

type
 //Classe base de exce��es do Merc�rio.
 EMercurioException = class(Exception)
  public
   constructor Create; virtual; abstract;
 end;

 //Valors inv�lidos de url
 EInvalidURL = class(EMercurioException)
  public
   constructor Create; override;
 end;

 //Exce��es relacionadas � comunica��o com o servi�o remoto.
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

 EJsonMessageTransf    = class(EMercurioException)
  public
   constructor Create; override;
 end;



implementation



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

{ EJsonMessageTransf }

constructor EJsonMessageTransf.Create;
begin
  inherited;
  Message := TChatMessages.MessageDataInvalid;
end;

{ EInvalidURL }

constructor EInvalidURL.Create;
begin
   inherited;
  Message := TConnectionError.InvalidUrl;
end;

end.
