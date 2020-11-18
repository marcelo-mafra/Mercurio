unit server.json.consts;

interface


uses System.Classes, System.SysUtils, System.Json;

type
  TJsonConsts = class //do not localize!
    const
      //Common consts
      JsonTerminator  = ',';
      ArrayTerminator = ']}';

      //Permissions consts
      ArrayPermissoes = '{"ArrayPermissoes":[';
  end;

implementation

end.
