unit classes.exceptions;

interface

uses
 System.SysUtils, client.resources.chatmessages;

type
 //Classe base de exce��es do Merc�rio.
 EMercurioException = class(Exception)
  public
   constructor Create; virtual; abstract;
 end;

 EJsonMessageTransf = class(EMercurioException)
  public
   constructor Create; override;
 end;

implementation


{ EJsonMessageTransf }

constructor EJsonMessageTransf.Create;
begin
  inherited;
  Message := TChatMessages.MessageDataInvalid;
end;



end.
