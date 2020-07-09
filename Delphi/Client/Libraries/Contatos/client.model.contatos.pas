unit client.model.contatos;

interface

uses
  System.SysUtils, System.Classes, client.resources.svcconsts, client.classes.json,
  client.interfaces.common, client.interfaces.baseclasses, client.interfaces.contatos,
  client.serverintf.contatos, client.interfaces.application, client.resources.consts,
  client.model.listacontatos, client.data.contatos, Data.DB;

type
   TTransformModel = (tmDataset, tmListObject);

   //Encapsula a interface com o serviço remoto para o domínio "CONTATOS".
   TContatosModel = class(TMercurioClass, IContatosService)
     private
       function DoGetMyContatos: string;
       procedure DoJsonToObject(JsonData: string; Obj: TObject; Model: TTransformModel);

     public
       constructor Create;
       destructor Destroy; override;

       //IContatosService
       function  NewContato(value: TMyContato): TMyContato;
       procedure GetMyContatos(List: TListaObjetos); overload;
       procedure GetMyContatos(Dataset: TDataset); overload;
       function ExcluirContato(value: TMyContato): boolean;

   end;

implementation

{ TContatosService }

constructor TContatosModel.Create;
begin
 inherited;
// FContatosData := TContatosData.Create(nil);
end;

destructor TContatosModel.Destroy;
begin
//  FContatosData.Free;
  inherited Destroy;
end;

function TContatosModel.DoGetMyContatos: string;
var
 IService: IMercurioContatosServer;
begin
 IService := GetIMercurioContatosServer;

 try
   Result := IService.GetMyContatos;
   if (IService <> nil) and not (Result.IsEmpty) then
     MercurioLogs.RegisterRemoteCallSucess(TContatosConst.CallGetContatosSucess, Result);

  {Não dar "FreeAndNil" em ContatoObj, uma vez que foi adicionado na lista
   da variável List. FreeAndNil aqui vai eliminar de List o último ponteiro
   associado à variável ContatoObj. }
 except
  on E: Exception do
   begin
     Result := '';
     MercurioLogs.RegisterRemoteCallFailure(TContatosConst.CallGetContatosError, E.Message);
   end;
 end;

end;

procedure TContatosModel.DoJsonToObject(JsonData: string; Obj: TObject;
  Model: TTransformModel);
var
 I , Counter: integer;
 ContatoObj: TMyContato;
 vContactId, vFirstName, vLastName: variant;
begin

 try
   if not (JsonData.IsEmpty) then
    begin
     Counter := TNetJsonUtils.GetObjectCount(JsonData, 'ArrayContatos');

     for I := 0 to Counter - 1 do
       begin
        vContactId := TNetJsonUtils.FindValue(JsonData, 'ArrayContatos', 'ContatoId', I).ToInteger;
        vFirstName := TNetJsonUtils.FindValue(JsonData, 'ArrayContatos', 'FirstName', I);
        vLastName  := TNetJsonUtils.FindValue(JsonData, 'ArrayContatos', 'LastName', I);

        case Model of
          tmDataset:
           begin
             TDataset(obj).Append;
             TDataset(obj).Fields.FieldByName('ContatoId').Value := vContactId;
             TDataset(obj).Fields.FieldByName('FirstName').Value := vFirstName;
             TDataset(obj).Fields.FieldByName('LastName').Value := vLastName;
             TDataset(obj).Post;
           end;
          tmListObject:
           begin
              ContatoObj := TMyContato.Create;
              ContatoObj.ContatoId := vContactId;
              ContatoObj.FirstName := vFirstName;
              ContatoObj.LastName :=  vLastName;

              TListaContatos(Obj).AddItem(ContatoObj);
           end;
        end;

       end;

    end;

  {Não dar "FreeAndNil" em ContatoObj, uma vez que foi adicionado na lista
   da variável List. FreeAndNil aqui vai eliminar de List o último ponteiro
   associado à variável ContatoObj. }
 except
  on E: Exception do
   begin
     //MercurioLogs.RegisterRemoteCallFailure(TContatosConst.CallGetContatosError, E.Message);
   end;
 end;

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

procedure TContatosModel.GetMyContatos(Dataset: TDataset);
var
 JsonData: string;
begin
 if Dataset = nil then
  Exit;

 JsonData := DoGetMyContatos;
 if not (JsonData.IsEmpty) then
    DoJsonToObject(JsonData, Dataset, tmDataset);
end;

procedure TContatosModel.GetMyContatos(List: TListaObjetos);
var
 JsonData: string;
begin
 if List = nil then
  Exit;

 JsonData := DoGetMyContatos;

 if not (JsonData.IsEmpty) then
   DoJsonToObject(JsonData, List, tmListObject);
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
