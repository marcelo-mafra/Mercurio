unit client.model.contatos;

interface

uses
  System.SysUtils, System.Classes, client.resources.svcconsts, client.classes.json,
  client.interfaces.common, client.interfaces.baseclasses, client.interfaces.contatos,
  client.serverintf.contatos, client.interfaces.application, client.resources.consts,
  client.model.listacontatos, client.data.contatos;

type
   //Encapsula a interface com o serviço remoto para o domínio "CONTATOS".
   TContatosModel = class(TMercurioClass, IContatosService)
     private
       FContatosData: TContatosData;

     public
       constructor Create;
       destructor Destroy; override;

       //IContatosService
       function  NewContato(value: TMyContato): TMyContato;
       procedure GetMyContatos(List: TListaObjetos);
       function ExcluirContato(value: TMyContato): boolean;

   end;

implementation

{ TContatosService }

constructor TContatosModel.Create;
begin
 inherited;
 FContatosData := TContatosData.Create(nil);
end;

destructor TContatosModel.Destroy;
begin
  FContatosData.Free;
  inherited Destroy;
end;

function TContatosModel.ExcluirContato(value: TMyContato): boolean;
var
 IService: IMercurioContatosServer;
begin
 Result := False;

 try
   IService := GetIMercurioContatosServer();
   Result := IService.ExcluirContato(value) ;

   if value <> nil then
    begin
     MercurioLogs.RegisterRemoteCallSucess(TContatosConst.CallExcluirContatoSucess,
       Value.ContatoId.ToString);
    end;

 except
  on E: Exception do
   begin
     Result := False;
     MercurioLogs.RegisterRemoteCallFailure(TContatosConst.CallExcluirContatoError, E.Message);
   end;
 end;
end;

procedure TContatosModel.GetMyContatos(List: TListaObjetos);
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

     MercurioLogs.RegisterRemoteCallSucess(TContatosConst.CallGetContatosSucess, JsonData);
    end;

  {Não dar "FreeAndNil" em ContatoObj, uma vez que foi adicionado na lista
   da variável List. FreeAndNil aqui vai eliminar de List o último ponteiro
   associado à variável ContatoObj. }
 except
  on E: Exception do
   begin
     MercurioLogs.RegisterRemoteCallFailure(TContatosConst.CallGetContatosError, E.Message);
   end;
 end;
end;

function TContatosModel.NewContato(value: TMyContato): TMyContato;
var
 IService: IMercurioContatosServer;
begin

 try
   IService := GetIMercurioContatosServer();
   Result := IService.NewContato(Value);

   if Result <> nil then
    begin
     MercurioLogs.RegisterRemoteCallSucess(TContatosConst.CallNewContatoSucess, '');
    end;

 except
  on E: Exception do
   begin
     MercurioLogs.RegisterRemoteCallFailure(TContatosConst.CallNewContatoError, E.Message);
   end;
 end;
end;


end.
