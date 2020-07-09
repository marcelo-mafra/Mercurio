unit classes.exceptions;

interface

uses
 System.SysUtils, client.resources.svccon, client.resources.httpstatus,
 client.resources.consts;

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
  Message := TServiceConnectionConst.StatusBadRequest;
end;

{ ENoServiceResponse }

constructor ENoServiceResponse.Create;
begin
  inherited;
  Message := TServiceConnectionConst.NoServiceResponse;
end;


{ EHTTPStatus }

constructor EHTTPStatus.Create(const StatusCode: integer);
var
HttpMessage: string;
begin
  inherited;
  HttpMessage := THTTPStatus.ToText(StatusCode);
  Message := string.Format(TServiceConnectionConst.HttpStatus, [StatusCode, HttpMessage]);
end;

{ EJsonMessageTransf }

constructor EJsonMessageTransf.Create;
begin
  inherited;
  Message := TChatMessagesConst.MessageDataInvalid;
end;

{ EInvalidURL }

constructor EInvalidURL.Create;
begin
   inherited;
  Message := TServiceConnectionConst.InvalidUrl;
end;

end.
