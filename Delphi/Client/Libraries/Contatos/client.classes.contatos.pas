unit client.classes.contatos;

interface

uses
  System.SysUtils, System.Classes, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent, Winapi.Windows, System.NetEncoding, classes.exceptions,
  client.resources.svcconsts, client.classes.nethttp, client.resources.httpstatus,
  client.interfaces.contatos, client.serverintf.contatos;

type
   {Classe que representa um contato.}
   TContatosService = class(TInterfacedObject, IContatosService)
     private


     public
       constructor Create;
       destructor Destroy; override;

       //IContatosService
       function  NewContato: boolean;//(const Value: TMyContato): TMyContato;

   end;

implementation

{ TContatosService }

constructor TContatosService.Create;
begin
 inherited
end;

destructor TContatosService.Destroy;
begin

  inherited Destroy;
end;

function TContatosService.NewContato: boolean;//(const Value: TMyContato): TMyContato;
var
 IContatosService: IMercurioContatosServer;
 MessageObj: TMyContato;
begin
 MessageObj := TMyContato.Create;

 try
   IContatosService := GetIMercurioContatosServer();

   MessageObj.LastName := 'Sanches';
   MessageObj.FirstName := 'Marcelo';

   Result := IContatosService.NewContato(MessageObj) <> nil;

   if (IContatosService <> nil) and (Result = True) then
    begin
      MessageObj.LastName := 'ok1';
    end;

  finally
     if Assigned(MessageObj) then FreeAndNil(MessageObj);

    end;
 end;

end.
