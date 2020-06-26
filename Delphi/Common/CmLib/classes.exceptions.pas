unit classes.exceptions;

interface

uses
 System.SysUtils;

type
 EMercurioException = class(Exception);

 //Valors inválidos de url
 EInvalidURL    = class(EMercurioException);

 //Exceções relacionadas à comunicação com o serviço remoto.
 ENoServiceResponse = class(EMercurioException);
 EHTTPStatus        = class(EMercurioException);
 EHTTPBadRequest    = class(EMercurioException);



implementation



end.
