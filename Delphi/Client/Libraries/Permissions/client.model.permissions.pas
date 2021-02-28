unit client.model.permissions;

interface

uses
  System.SysUtils, System.Classes, Soap.InvokeRegistry, client.classes.json, client.interfaces.json,
  client.interfaces.common, client.interfaces.baseclasses, client.interfaces.permissions,
  client.serverintf.permissions, client.interfaces.application, classes.exceptions,
  Data.DB, System.Variants, client.model.listapermissions, classes.permissions.types,
  client.resources.permissions.dataobjects, client.resources.permissions,
  client.model.permissions.consts;

type
   //Encapsula a interface com o serviço remoto para o domínio "PERMISSÕES".
   TPermissionsModel = class(TMercurioClass, IPermissionService, IPermissionsService)
     private
       FFeatureName: string;
       FEnabled: boolean;
       FAllowedFeatures: TMercurioFeatures;
       procedure Reset;
       function DoGetMyPermissions: string;
       procedure DoJsonToObject(JsonData: string; Obj: TObject; Model: TTransformModel);
       //INetJsonUtils
       function GetIJsonUtils: INetJsonUtils;

       //IPermissionService
       function GetEnabled: boolean;
       function GetFeatureName: string;
       function NewPermission(value: TMyPermission): TMyPermission;

       //IPermissionsService
       function GetAllowedFeatures: TMercurioFeatures;
       function GetIPermission: IPermissionService;

     public
       constructor Create;
       destructor Destroy; override;
       property IJsonUtils: INetJsonUtils read GetIJsonUtils;

       //IPermissionService
       property Enabled: boolean read GetEnabled;
       property FeatureName: string read GetFeatureName;

       //IPermissionsService
       procedure GetMyPermissions(List: TListaObjetos); overload;
       procedure GetMyPermissions(var AllowedFeatures: TMercurioFeatures); overload;
       function GetMyPermissions: TMyPermissions; overload;

       property IPermission: IPermissionService read GetIPermission;
       property AllowedFeatures: TMercurioFeatures read GetAllowedFeatures;


   end;

implementation

{ TPermissionsModel }

constructor TPermissionsModel.Create;
begin
 FFeatureName := string.Empty;
 FEnabled := False;
 self.Reset;
 inherited Create;
end;

destructor TPermissionsModel.Destroy;
begin
  inherited Destroy;
end;

function TPermissionsModel.DoGetMyPermissions: string;
var
 IService: IMercurioPermissionsServer;
begin
 IService := GetIMercurioPermissionsServer;

 try
   Result := IService.GetMyPermissions;
   if (IService <> nil) and not (Result.IsEmpty) then
     MercurioLogs.RegisterRemoteCallSucess(TPermissionsServerMethods.GetPermissionsSucess, Result);

 except
  on E: Exception do
   begin
     Result := string.Empty;
     MercurioLogs.RegisterRemoteCallFailure(TPermissionsServerMethods.GetPermissionsError, E.Message);
   end;
 end;

end;

procedure TPermissionsModel.DoJsonToObject(JsonData: string; Obj: TObject;
  Model: TTransformModel);
var
 I , Counter: integer;
 PermissionObj: TMyPermission;
 vFeatureId, vFeature, vUsuario, vEnabled: variant;
 DataValues: array of string;
begin

 try
   if not (JsonData.IsEmpty) then
    begin
     //Não pode executar esse método interno sem um objeto definido.
     if Obj = nil then raise EInvalidObjectList.Create;

     self.Reset; //Limpa o set de features permitidas
     Counter := IJsonUtils.GetObjectCount(JsonData, TPermissionsJosonData.ArrayName);
     SetLength(DataValues, 4);

     for I := 0 to Counter - 1 do
       begin
        IJsonUtils.FindValues(JsonData, TPermissionsJosonData.ArrayName, DataValues, I);
        vFeatureId := DataValues[TJsonFields.FeatureId];
        vFeature   := DataValues[TJsonFields.Feature];
        vUsuario   := DataValues[TJsonFields.Usuario];
        vEnabled   := DataValues[TJsonFields.Enabled];

        case Model of
          tmDataset:
           begin
             TDataset(obj).Append;
             with TDataset(obj).Fields do
              begin
               FieldByName(TPermissionsFields.FeatureId).Value := vFeatureId;
               FieldByName(TPermissionsFields.Feature).Value := vFeature;
               FieldByName(TPermissionsFields.Usuario).Value := vUsuario;
               FieldByName(TPermissionsFields.Enabled).Value := vEnabled;
              end;
             TDataset(obj).Post;
           end;
          tmListObject:
           begin
              PermissionObj := TMyPermission.Create;
              PermissionObj.FeatureId := vFeatureId;
              PermissionObj.FeatureName := vFeature;
              PermissionObj.Usuario :=  vUsuario;
              PermissionObj.Enabled :=  vEnabled;
              TListaPermissions(Obj).AddItem(PermissionObj);
           end;
        end;
       end;

       case Model of
         tmDataset: ;//to-do;
         tmListObject: self.FAllowedFeatures := TListaPermissions(Obj).AllowedFeatures;
       end;
    end;
  {Não dar "FreeAndNil" em PermissionObj, uma vez que foi adicionado na lista
   da variável List que gerencia automaticamente o ciclo de vida dos seus objetos. }
 except
  on E: EVariantTypeCastError do
   begin
     MercurioLogs.RegisterError(TPermissionsServerMethods.VariantCastError, E.Message);
   end;
  on E: EInvalidObjectList do
   begin
     MercurioLogs.RegisterError(TPermissionsServerMethods.GetPermissionsError, E.Message);
   end;
 end;

end;

function TPermissionsModel.GetAllowedFeatures: TMercurioFeatures;
begin
 Result := FAllowedFeatures;
end;

function TPermissionsModel.GetEnabled: boolean;
begin
 Result := FEnabled;
end;

function TPermissionsModel.GetFeatureName: string;
begin
 Result := FFeatureName;
end;

function TPermissionsModel.GetIJsonUtils: INetJsonUtils;
begin
 Result := TNetJsonUtils.New;
end;

function TPermissionsModel.GetIPermission: IPermissionService;
begin
 Result := self as IPermissionService;
end;

function TPermissionsModel.GetMyPermissions: TMyPermissions;
var
 IService: IMercurioPermissionsServer;
begin
 IService := GetIMercurioPermissionsServer;
 Result := IService.AsObjects;
end;

procedure TPermissionsModel.GetMyPermissions(
  var AllowedFeatures: TMercurioFeatures);
var
 JsonData: string;
 ListaObj: TListaPermissions;
begin
 JsonData := DoGetMyPermissions;

 if not (JsonData.IsEmpty) then
  begin
   ListaObj := TListaPermissions.Create;

   try
    DoJsonToObject(JsonData, ListaObj, tmListObject);
    AllowedFeatures := ListaObj.AllowedFeatures;

   finally
    FreeAndNil(ListaObj);
   end;
  end;
end;

procedure TPermissionsModel.GetMyPermissions(List: TListaObjetos);
var
 JsonData: string;
begin
 JsonData := DoGetMyPermissions;
 if not (JsonData.IsEmpty) then
   DoJsonToObject(JsonData, List, tmListObject);
end;

function TPermissionsModel.NewPermission(value: TMyPermission): TMyPermission;
var
 IService: IMercurioPermissionsServer;
begin
 Result := value;
 if Result = nil then Exit;

 try
   IService := GetIMercurioPermissionsServer();
   Result := IService.NewPermission(Value);

   if Result <> nil then
    begin
     MercurioLogs.RegisterRemoteCallSucess(TPermissionsServerMethods.NewPermissionSucess, '');
    end;

 except
  on E: ERemotableException do
   begin
     MercurioLogs.RegisterRemoteCallFailure(TPermissionsServerMethods.NewPermissionError, E.Message);
   end;
  on E: Exception do
   begin
     MercurioLogs.RegisterError(TPermissionsServerMethods.NewPermissionError, E.Message);
   end;
 end;

end;

procedure TPermissionsModel.Reset;
begin
 FAllowedFeatures := [];
end;

end.
