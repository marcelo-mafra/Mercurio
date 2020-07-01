unit client.classes.contatos;

interface

uses
  System.SysUtils, System.Classes, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent, Winapi.Windows, System.NetEncoding, classes.exceptions,
  client.resources.svcconsts, client.classes.nethttp, client.resources.httpstatus,
  client.interfaces.common, client.interfaces.contatos, client.serverintf.contatos,
  client.interfaces.application, Generics.Collections, client.classes.json;

type
   {Classe que representa uma lista de contatos.}
   TListaContatos = class(TListaObjetos)
    private
       FList: TObjectList<TMyContato>;
       function GetCount: integer;
       function GetIsEmpty: boolean;
    public
       constructor Create;
       destructor Destroy; override;

       procedure AddItem(value: TMyContato); reintroduce;
       function FindObject(Index: integer): TMyContato;

       property Count: integer read GetCount;
       property IsEmpty: boolean read GetIsEmpty;
   end;


   TContatosService = class(TInterfacedObject, IContatosService)
     private

     public
       constructor Create;
       destructor Destroy; override;

       //IContatosService
       function  NewContato(Value: TMyContato): TMyContato;
       procedure GetMyContatos(List: TListaObjetos);

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

procedure TContatosService.GetMyContatos(List: TListaObjetos);
var
 IService: IMercurioContatosServer;
 ContatoObj: TMyContato;
 JsonData: string;
 I , Counter: integer;
begin
 if List = nil then
  Exit;

 try
   IService := GetIMercurioContatosServer;
   JsonData := IService.GetMyContatos;

   if (IService <> nil) and not (JsonData.IsEmpty) then
    begin
     Counter := TNetJsonUtils.GetObjectCount(JsonData, 'ArrayContatos');

     for I := 0 to Counter - 1 do
       begin
        ContatoObj := TMyContato.Create;
        ContatoObj.FirstName := TNetJsonUtils.FindValue(JsonData, 'ArrayContatos', 'FirstName', I);
        ContatoObj.LastName :=  TNetJsonUtils.FindValue(JsonData, 'ArrayContatos', 'LastName', I);

        TListaContatos(List).AddItem(ContatoObj);
       end;
    end;

 finally
  if Assigned(ContatoObj) then FreeAndNil(ContatoObj);
 end;
end;

function TContatosService.NewContato(Value: TMyContato): TMyContato;
var
 IService: IMercurioContatosServer;
 //MessageObj: TMyContato;
begin

 try
   IService := GetIMercurioContatosServer();
   Result := IService.NewContato(Value);

 finally
   //if Assigned(MessageObj) then FreeAndNil(MessageObj);
 end;
end;

{ TListaContatos }

procedure TListaContatos.AddItem(value: TMyContato);
begin
 FList.Add(Value);
end;

constructor TListaContatos.Create;
begin
 FList := TObjectList<TMyContato>.Create;
 FList.OwnsObjects := true;
end;

destructor TListaContatos.Destroy;
begin
  FList.Clear;
  FList.Free;
  inherited;
end;

function TListaContatos.FindObject(Index: integer): TMyContato;
begin
 Result := FList.Items[Index];
end;

function TListaContatos.GetCount: integer;
begin
 Result :=  FList.Count;
end;

function TListaContatos.GetIsEmpty: boolean;
begin
 Result := FList.Count = 0;
end;

end.
