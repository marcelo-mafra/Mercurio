unit client.view.mainform.helpers;

interface

uses
 System.SysUtils, client.resources.mercurio, client.view.mainform;

type
   TMercurioHelper = class helper for TFrmMainForm
    private
     function GetParamsFile: string;

    public
     property ParamsFile: string read GetParamsFile;
   end;

implementation

{ TMercurioHelper }

function TMercurioHelper.GetParamsFile: string;
begin
 Result := GetCurrentDir + '\' + TMercurioIniFile.ConfigFile;
end;

end.
