unit client.model.contatos;

interface

uses
  System.SysUtils, System.Classes, Soap.InvokeRegistry, client.classes.json,
  client.interfaces.common, client.interfaces.baseclasses, client.interfaces.contatos,
  client.serverintf.contatos, client.interfaces.application, client.resources.contatos,
  client.model.listacontatos, client.data.contatos, Data.DB, Variants;

type
   TTransformModel = (tmDataset, tmListObject);

   //Encapsula a interface com o serviço remoto para o domínio "CONTATOS".
   TContatosModel = class(TMercurioClass, IContatosService)
     private
       FOnNewContatoEvent: TNewContatoNotifyEvent;
       FOnDeleteContatoEvent: TDeleteContatoNotifyEvent;
       function DoGetMyContatos: string;
       procedure DoJsonToObject(JsonData: string; Obj: TObject; Model: TTransformModel);

     public
       constructor Create(OnNewContato: TNewContatoNotifyEvent;
          OnDeleteContato: TDeleteContatoNotifyEvent);
       destructor Destroy; override;

       //IContatosService
       function  NewContato(value: TMyContato): TMyContato;
       procedure GetMyContatos(List: TListaObjetos); overload;
       procedure GetMyContatos(Dataset: TDataset); overload;
       function  ExcluirContato(value: TMyContato): boolean;

   end;

implementation

{ TContatosService }

constructor TContatosModel.Create(OnNewContato: TNewContatoNotifyEvent;
  OnDeleteContato: TDeleteContatoNotifyEvent);
begin
 inherited Create;
 FOnNewContatoEvent := OnNewContato;
 FOnDeleteContatoEvent := OnDeleteContato;
end;

destructor TContatosModel.Destroy;
begin
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
     MercurioLogs.RegisterRemoteCallSucess(TContatosServerMethods.GetContatosSucess, Result);

  {Não dar "FreeAndNil" em ContatoObj, uma vez que foi adicionado na lista
   da variável List. FreeAndNil aqui vai eliminar de List o último ponteiro
   associado à variável ContatoObj. }
 except
  on E: Exception do
   begin
     Result := '';
     MercurioLogs.RegisterRemoteCallFailure(TContatosServerMethods.GetContatosError, E.Message);
   end;
 end;

end;

procedure TContatosModel.DoJsonToObject(JsonData: string; Obj: TObject;
  Model: TTransformModel);
var
 I , Counter: integer;
 ContatoObj: TMyContato;
 vContactId, vFirstName, vLastName, vStatus: variant;
begin

 try
   if not (JsonData.IsEmpty) then
    begin
     Counter := TNetJsonUtils.GetObjectCount(JsonData, 'ArrayContatos');

     for I := 0 to Counter - 1 do
       begin
        vContactId := TNetJsonUtils.FindValue(JsonData, 'ArrayContatos', 'CONTACTID', I);
        vFirstName := TNetJsonUtils.FindValue(JsonData, 'ArrayContatos', 'NOME', I);
        vLastName  := TNetJsonUtils.FindValue(JsonData, 'ArrayContatos', 'SOBRENOME', I);
        vStatus    := TNetJsonUtils.FindValue(JsonData, 'ArrayContatos', 'STATUS', I);

        case Model of
          tmDataset:
           begin
             TDataset(obj).Append;
             TDataset(obj).Fields.FieldByName('CONTACTID').Value := vContactId;
             TDataset(obj).Fields.FieldByName('NOME').Value := vFirstName;
             TDataset(obj).Fields.FieldByName('SOBRENOME').Value := vLastName;
             TDataset(obj).Fields.FieldByName('STATUS').Value := vStatus;
             TDataset(obj).Post;
           end;
          tmListObject:
           begin
              ContatoObj := TMyContato.Create;
              ContatoObj.ContatoId := Random(97997656).toString;//vContactId;
              ContatoObj.FirstName := vFirstName;
              ContatoObj.LastName :=  vLastName;
              ContatoObj.Status  := vStatus;

              TListaContatos(Obj).AddItem(ContatoObj);
           end;
        end;
       end;
    end;
  {Não dar "FreeAndNil" em ContatoObj, uma vez que foi adicionado na lista
   da variável List que gerencia automaticamente o ciclo de vida dos seus objetos. }
 except
  on E: EVariantTypeCastError do
   begin
     MercurioLogs.RegisterError(TContatosServerMethods.VariantCastError, E.Message);
   end;
 end;
end;

function TContatosModel.ExcluirContato(value: TMyContato): boolean;
var
 IService: IMercurioContatosServer;
begin
 IService := GetIMercurioContatosServer();
 try
   Result := IService.ExcluirContato(value) ;

   if (Result = True) and (value <> nil) then
    begin
     MercurioLogs.RegisterRemoteCallSucess(TContatosServerMethods.ExcluirContatoSucess,
       Value.ContatoId);
     if Assigned(FOnDeleteContatoEvent) then FOnDeleteContatoEvent;
    end;

 except
  on E: ERemotableException do
   begin
     Result := False;
     MercurioLogs.RegisterRemoteCallFailure(TContatosServerMethods.ExcluirContatoError, E.Message);
   end;
  on E: Exception do
    begin
     Result := False;
     MercurioLogs.RegisterError(TContatosServerMethods.ExcluirContatoError, E.Message);
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
 Result := value;

 try
   IService := GetIMercurioContatosServer();
   Result := IService.NewContato(Value);

   if Result <> nil then
    begin
     MercurioLogs.RegisterRemoteCallSucess(TContatosServerMethods.NewContatoSucess, '');
     if Assigned(FOnNewContatoEvent) then FOnNewContatoEvent(Result); //Dispara o evento OnNewContato...
    end;

 except
  on E: ERemotableException do
   begin
     MercurioLogs.RegisterRemoteCallFailure(TContatosServerMethods.NewContatoError, E.Message);
   end;
  on E: Exception do
   begin
     MercurioLogs.RegisterError(TContatosServerMethods.NewContatoError, E.Message);
   end;
 end;
end;


end.
