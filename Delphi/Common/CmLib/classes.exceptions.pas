unit classes.exceptions;

interface

uses
 System.SysUtils;

type
 EMercurioException = class(Exception);

 //Exce��es relacionadas � comunica��o com o servi�o remoto.
 ENoServiceResponse = class(EMercurioException);
 EHTTPStatus        = class(EMercurioException);
 EHTTPBadRequest    = class(EMercurioException);



implementation



end.
