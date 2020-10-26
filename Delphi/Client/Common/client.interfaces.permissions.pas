unit client.interfaces.permissions;

interface
{Contém interfaces que abstraem entidades relacionadas ao permissionamento.}

uses
 client.interfaces.common, client.interfaces.baseclasses, classes.permissions.types,
 client.serverintf.permissions;

type
 //It abstracts the entity for a permission for feature.
 IPermissionService = interface(IMercurioInterface)
  ['{AC376710-F60A-4440-B2CB-23A34CC5D684}']
  function GetEnabled: boolean;
  function GetFeatureName: string;
  function NewPermission(Value: TMyPermission): TMyPermission;

  property Enabled: boolean read GetEnabled;
  property FeatureName: string read GetFeatureName;

 end;

 //It abstracts the entity for a set of permissions.
 IPermissionsService = interface(IMercurioInterface)
  ['{BBDD349D-4BF8-4E04-9B51-B404A11B136E}']

  function GetIPermission: IPermissionService;
  procedure GetMyPermissions(List: TListaObjetos); overload;
  procedure GetMyPermissions(var AllowedFeatures: TMercurioFeatures); overload;

  property IPermission: IPermissionService read GetIPermission;
 end;

implementation

end.
