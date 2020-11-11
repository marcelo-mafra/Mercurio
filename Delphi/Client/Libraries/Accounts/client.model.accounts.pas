unit client.model.accounts;

interface

uses
  System.SysUtils, System.Classes, Soap.InvokeRegistry, client.classes.json,
  client.interfaces.common, client.interfaces.baseclasses, client.interfaces.accounts,
  client.serverintf.accounts, classes.exceptions, Data.DB, System.Variants,
  client.model.listaaccounts, client.resources.accounts.dataobjects, client.resources.accounts,
  client.model.accounts.consts;

type
   //Encapsula a interface com o serviço remoto para o domínio "CONTAS".
   TAccountsModel = class(TMercurioClass, IAccountService, IAccountsService)
     private
       function DoGetMyAccounts: string;
       procedure DoJsonToObject(JsonData: string; Obj: TObject; Model: TTransformModel);

      //IAccountsService
       function GetIAccount: IAccountService;

     public
       constructor Create;
       destructor Destroy; override;

       //IAccountService
       function NewAccount(value: TMyAccount): TMyAccount;

       //IAccountsService
       procedure GetMyAccounts(List: TListaObjetos);
       property IAccount: IAccountService read GetIAccount;
   end;

implementation

{ TAccountsModel }

constructor TAccountsModel.Create;
begin
 inherited Create;
end;

destructor TAccountsModel.Destroy;
begin
  inherited;
end;

function TAccountsModel.DoGetMyAccounts: string;
var
 IService: IMercurioAccountsServer;
begin
 IService := GetIMercurioAccountsServer;

 try
   Result := IService.GetMyAccounts;
   if (IService <> nil) and not (Result.IsEmpty) then
     MercurioLogs.RegisterRemoteCallSucess(TAccountsServerMethods.GetAccountsSucess, Result);

 except
  on E: Exception do
   begin
     Result := string.Empty;
     MercurioLogs.RegisterRemoteCallFailure(TAccountsServerMethods.GetAccountsError, E.Message);
   end;
 end;

end;

procedure TAccountsModel.DoJsonToObject(JsonData: string; Obj: TObject;
  Model: TTransformModel);
var
 I , Counter: integer;
 AccountObj: TMyAccount;
 vAccountId, vAccountName, vMyName, vEnabled, vCreatedAt: variant;
 DataValues: array of string;
begin

 try
   if not (JsonData.IsEmpty) then
    begin
     //Não pode executar esse método interno sem um objeto definido.
     if Obj = nil then raise EInvalidObjectList.Create;

     Counter := TNetJsonUtils.GetObjectCount(JsonData, TAccountsJosonData.ArrayName);
     SetLength(DataValues, 5);

     for I := 0 to Counter - 1 do
       begin
        TNetJsonUtils.FindValue(JsonData, TAccountsJosonData.ArrayName, DataValues, I);

        vAccountId := DataValues[TJsonFields.AccountId];
        vAccountName   := DataValues[TJsonFields.AccountName];
        vMyName   := DataValues[TJsonFields.MyName];
        vEnabled   := DataValues[TJsonFields.Enabled];
        vCreatedAt   := DataValues[TJsonFields.CreatedAt];

        case Model of
          tmDataset:
           begin
             TDataset(obj).Append;
             with TDataset(obj).Fields do
              begin
               FieldByName(TAccountsFields.AccountId).Value := vAccountId;
               FieldByName(TAccountsFields.AccountName).Value := vAccountName;
               FieldByName(TAccountsFields.MyName).Value := vMyName;
               FieldByName(TAccountsFields.Enabled).Value := vEnabled;
               FieldByName(TAccountsFields.CreatedAt).Value := vCreatedAt;
              end;
             TDataset(obj).Post;
           end;
          tmListObject:
           begin
              AccountObj := TMyAccount.Create;
              AccountObj.AccountId := vAccountId;
              AccountObj.AccountName := vAccountName;
              AccountObj.MyName :=  vMyName;
              AccountObj.Enabled :=  vEnabled;
              AccountObj.CreatedAt.AsDateTime := vCreatedAt;
              //data := XMLTimeToDateTime('2017-11-24T00:08:41-02:00', True);
              TListaAccounts(Obj).AddItem(AccountObj);
           end;
        end;
       end;

    end;
  {Não dar "FreeAndNil" em PermissionObj, uma vez que foi adicionado na lista
   da variável List que gerencia automaticamente o ciclo de vida dos seus objetos. }
 except
  on E: EVariantTypeCastError do
   begin
     MercurioLogs.RegisterError(TAccountsServerMethods.VariantCastError, E.Message);
   end;
  on E: EInvalidObjectList do
   begin
     MercurioLogs.RegisterError(TAccountsServerMethods.GetAccountsError, E.Message);
   end;
 end;

end;

function TAccountsModel.GetIAccount: IAccountService;
begin
 Result := self as IAccountService;
end;

procedure TAccountsModel.GetMyAccounts(List: TListaObjetos);
var
 JsonData: string;
begin
 JsonData := DoGetMyAccounts;
 if not (JsonData.IsEmpty) then
   DoJsonToObject(JsonData, List, tmListObject);

end;

function TAccountsModel.NewAccount(value: TMyAccount): TMyAccount;
var
 IService: IMercurioAccountsServer;
begin
 Result := value;
 if Result = nil then Exit;

 try
   IService := GetIMercurioAccountsServer();
   Result := IService.NewAccount(value);

   if Result <> nil then
    begin
     MercurioLogs.RegisterRemoteCallSucess(TAccountsServerMethods.NewAccountSucess, string.Empty);
    end;

 except
  on E: ERemotableException do
   begin
     MercurioLogs.RegisterRemoteCallFailure(TAccountsServerMethods.NewAccountError, E.Message);
   end;
  on E: Exception do
   begin
     MercurioLogs.RegisterError(TAccountsServerMethods.NewAccountError, E.Message);
   end;
 end;
end;

end.
