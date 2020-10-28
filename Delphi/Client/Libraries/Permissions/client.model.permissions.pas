unit client.model.permissions;

interface

uses
  System.SysUtils, System.Classes, Soap.InvokeRegistry, client.classes.json,
  client.interfaces.common, client.interfaces.baseclasses, client.interfaces.permissions,
  client.serverintf.permissions, client.interfaces.application,
  Data.DB, System.Variants, client.model.listapermissions, classes.permissions.types,
  client.resources.permissions.dataobjects, client.resources.permissions;

type
   //Encapsula a interface com o servi�o remoto para o dom�nio "PERMISS�ES".
   TPermissionsModel = class(TMercurioClass, IPermissionService, IPermissionsService)
     private
       FFeatureName: string;
       FEnabled: boolean;
       FAllowedFeatures: TMercurioFeatures;
       procedure Reset;
       function DoGetMyPermissions: string;
       procedure DoAllowFeature(const Feature: TMercurioFeature);
       procedure DoJsonToObject(JsonData: string; Obj: TObject; Model: TTransformModel);

       //IPermissionService
       function GetEnabled: boolean;
       function GetFeatureName: string;
       function NewPermission(Value: TMyPermission): TMyPermission;

       //IPermissionsService
       function GetAllowedFeatures: TMercurioFeatures;
       function GetIPermission: IPermissionService;

     public
       constructor Create;
       destructor Destroy; override;

       //IPermissionService
       property Enabled: boolean read GetEnabled;
       property FeatureName: string read GetFeatureName;

       //IPermissionsService
       procedure GetMyPermissions(List: TListaObjetos); overload;
       procedure GetMyPermissions(var AllowedFeatures: TMercurioFeatures); overload;
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

procedure TPermissionsModel.DoAllowFeature(const Feature: TMercurioFeature);
begin
 FAllowedFeatures := FAllowedFeatures + [Feature];
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
     self.Reset; //Limpa o set de features permitidas
     Counter := TNetJsonUtils.GetObjectCount(JsonData, TPermissionsJosonData.ArrayName);
     SetLength(DataValues, 4);

     for I := 0 to Counter - 1 do
       begin
        TNetJsonUtils.FindValue(JsonData, TPermissionsJosonData.ArrayName, DataValues, I);
        vFeatureId := DataValues[0];
        vFeature   := DataValues[1];
        vUsuario   := DataValues[2];
        vEnabled   := DataValues[3];
        //Registra que o usu�rio pode acessar uma feature
        self.DoAllowFeature(TMercurioFeature(vFeatureId));

        if Obj = nil then Continue;

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
    end;
  {N�o dar "FreeAndNil" em PermissionObj, uma vez que foi adicionado na lista
   da vari�vel List que gerencia automaticamente o ciclo de vida dos seus objetos. }
 except
  on E: EVariantTypeCastError do
   begin
     MercurioLogs.RegisterError(TPermissionsServerMethods.VariantCastError, E.Message);
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

function TPermissionsModel.GetIPermission: IPermissionService;
begin
 Result := self as IPermissionService;
end;

procedure TPermissionsModel.GetMyPermissions(
  var AllowedFeatures: TMercurioFeatures);
var
 JsonData: string;
begin
 JsonData := DoGetMyPermissions;
 if not (JsonData.IsEmpty) then
  begin
   DoJsonToObject(JsonData, nil, tmListObject);
   AllowedFeatures := self.FAllowedFeatures;
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

function TPermissionsModel.NewPermission(Value: TMyPermission): TMyPermission;
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
