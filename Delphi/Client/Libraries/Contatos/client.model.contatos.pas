unit client.model.contatos;

interface

uses
  System.SysUtils, System.Classes, Soap.InvokeRegistry, client.classes.json, client.interfaces.json,
  client.interfaces.common, client.interfaces.baseclasses, client.interfaces.contatos,
  client.serverintf.contatos, client.interfaces.application, client.resources.contatos,
  client.model.listacontatos, Data.DB, System.Variants,
  classes.contatos.types, client.resources.contatos.dataobjects;

type
   //Encapsula a interface com o serviço remoto para o domínio "CONTATOS".
   TContatosModel = class(TMercurioClass, IContactService, IContactsService)
     private
       FOnNewContatoEvent: TNewContatoNotifyEvent;
       FOnDeleteContatoEvent: TDeleteContatoNotifyEvent;

       function DoGetMyContatos: string;
       procedure DoJsonToObject(JsonData: string; Obj: TObject; Model: TTransformModel);
       //IContactService
       function GetIContact: IContactService;
       //INetJsonUtils
       function GetIJsonUtils: INetJsonUtils;

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
       property IContact: IContactService read GetIContact;
       property IJsonUtils: INetJsonUtils read GetIJsonUtils;

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

 except
  on E: Exception do
   begin
     Result := string.Empty;
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
 DataValues: array of string;
begin

 try
   if not (JsonData.IsEmpty) then
    begin
     Counter := IJsonUtils.GetObjectCount(JsonData);
     SetLength(DataValues, 5);

     for I := 0 to Pred(Counter) do
       begin
        IJsonUtils.FindValues(JsonData, string.Empty, DataValues, I);
        vContactId := DataValues[0];
        vFirstName := DataValues[1];
        vLastName  := DataValues[2];
        //vFoto  :=   DataValues[3];
        vStatus    := DataValues[4];

        case Model of
          tmDataset:
           begin
             TDataset(obj).Append;
             with TDataset(obj).Fields do
              begin
               FieldByName(TContatosFieldsNames.ContactId).Value := vContactId;
               FieldByName(TContatosFieldsNames.Nome).Value := vFirstName;
               FieldByName(TContatosFieldsNames.Sobrenome).Value := vLastName;
               FieldByName(TContatosFieldsNames.Status).Value := vStatus;
              end;
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

function TContatosModel.GetIContact: IContactService;
begin
 Result := self as IContactService;
end;

function TContatosModel.GetIJsonUtils: INetJsonUtils;
begin
 Result := TNetJsonUtils.New;
end;

procedure TContatosModel.GetMyContatos(Dataset: TDataset);
var
 JsonData: string;
begin
 if Dataset = nil then Exit;

 JsonData := DoGetMyContatos;
 if not (JsonData.IsEmpty) then DoJsonToObject(JsonData, Dataset, tmDataset);
end;

procedure TContatosModel.GetMyContatos(List: TListaObjetos);
var
 JsonData: string;
begin
 if List = nil then Exit;

 JsonData := DoGetMyContatos;
 if not (JsonData.IsEmpty) then DoJsonToObject(JsonData, List, tmListObject);
end;

function TContatosModel.NewContato(value: TMyContato): TMyContato;
var
 IService: IMercurioContatosServer;
begin
 Result := value;
 if Result = nil then Exit;

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
