unit client.model.contatos;

interface

uses
  System.SysUtils, System.Classes, Soap.InvokeRegistry, client.classes.json,
  client.interfaces.common, client.interfaces.baseclasses, client.interfaces.contatos,
  client.serverintf.contatos, client.interfaces.application, client.resources.contatos,
  client.model.listacontatos, client.data.contatos, Data.DB, Variants,
  classes.contatos.types, client.resources.contatos.dataobjects;

type
   //Encapsula a interface com o serviço remoto para o domínio "CONTATOS".
   TContatosModel = class(TMercurioClass, IContatoService, IContatosService)
     private
       FOnNewContatoEvent: TNewContatoNotifyEvent;
       FOnDeleteContatoEvent: TDeleteContatoNotifyEvent;
       function DoGetMyContatos: string;
       procedure DoJsonToObject(JsonData: string; Obj: TObject; Model: TTransformModel);
       //IContatosService
       function GetIContato: IContatoService;

     public
       constructor Create(OnNewContato: TNewContatoNotifyEvent;
          OnDeleteContato: TDeleteContatoNotifyEvent);
       destructor Destroy; override;

       //IContatoService
       function  NewContato(value: TMyContato): TMyContato;
       function  ExcluirContato(value: TMyContato): boolean;

       //IContatosService
       procedure GetMyContatos(List: TListaObjetos); overload;
       procedure GetMyContatos(Dataset: TDataset); overload;
       property IContato: IContatoService read GetIContato;


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
     Counter := TNetJsonUtils.GetObjectCount(JsonData, TContatosJosonData.ArrayName);

     for I := 0 to Counter - 1 do
       begin
        vContactId := TNetJsonUtils.FindValue(JsonData, TContatosJosonData.ArrayName, TContatosJosonData.ContactId, I);
        vFirstName := TNetJsonUtils.FindValue(JsonData, TContatosJosonData.ArrayName, TContatosJosonData.Nome, I);
        vLastName  := TNetJsonUtils.FindValue(JsonData, TContatosJosonData.ArrayName, TContatosJosonData.Sobrenome, I);
        vStatus    := TNetJsonUtils.FindValue(JsonData, TContatosJosonData.ArrayName, TContatosJosonData.Status, I);

        case Model of
          tmDataset:
           begin
             TDataset(obj).Append;
             TDataset(obj).Fields.FieldByName(TContatosFieldsNames.ContactId).Value := vContactId;
             TDataset(obj).Fields.FieldByName(TContatosFieldsNames.Nome).Value := vFirstName;
             TDataset(obj).Fields.FieldByName(TContatosFieldsNames.Sobrenome).Value := vLastName;
             TDataset(obj).Fields.FieldByName(TContatosFieldsNames.Status).Value := vStatus;
             TDataset(obj).Post;
           end;
          tmListObject:
           begin
              ContatoObj := TMyContato.Create;
              ContatoObj.ContatoId := vContactId;
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

function TContatosModel.GetIContato: IContatoService;
begin
 Result := self as IContatoService;
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
 if Value = nil then
  exit;

 value.Status := TContatoStatus.Unknown; //Nasce com esse status
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
