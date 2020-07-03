unit client.classes.contatos;

interface

uses
  System.SysUtils, System.Classes, client.resources.svcconsts, client.classes.json,
  client.interfaces.common, client.interfaces.contatos, client.serverintf.contatos,
  client.interfaces.application, client.classes.listacontatos;

type
   //Encapsula a interface com o serviço remoto para o domínio "CONTATOS".
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
        ContatoObj.ContatoId := TNetJsonUtils.FindValue(JsonData, 'ArrayContatos', 'ContatoId', I).ToInteger;
        ContatoObj.FirstName := TNetJsonUtils.FindValue(JsonData, 'ArrayContatos', 'FirstName', I);
        ContatoObj.LastName :=  TNetJsonUtils.FindValue(JsonData, 'ArrayContatos', 'LastName', I);

        TListaContatos(List).AddItem(ContatoObj);
       end;
    end;

  {Não dar "FreeAndNil" em ContatoObj, uma vez que foi adicionado na lista
   da variável List. FreeAndNil aqui vai eliminar de List o último ponteiro
   associado à variável ContatoObj. }
 except
   //to-do: gerar logs.

 end;
end;

function TContatosService.NewContato(Value: TMyContato): TMyContato;
var
 IService: IMercurioContatosServer;
begin

 try
   IService := GetIMercurioContatosServer();
   Result := IService.NewContato(Value);

 except
   //to-do: gerar logs.

 end;
end;


end.
