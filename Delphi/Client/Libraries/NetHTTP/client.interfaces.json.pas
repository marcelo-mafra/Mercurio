unit client.interfaces.json;

interface

uses
 System.Classes, System.Json;

type
 INetJsonUtils = interface
  ['{6FE4B0DA-FC17-49EB-A508-D3A40CB60DBD}']

  function AsJsonObject(const JsonString: string): TJsonObject;
  function FindValue(const JsonString: string; ValueName: string): string; overload;
  function FindValue(const JsonString: string; ArrayName: string; ValueName: string; Index: integer): string; overload;
  procedure FindValues(const JsonString: string; ArrayName: string; var ArrayValues: array of string; Index: integer);
  //procedure ToDataset(const JsonString: string; Dataset: TDataset);
  function GetObjectCount(const JsonString: string; ArrayName: string): integer; overload;
  function GetObjectCount(const JsonString: string): integer; overload;
 end;

implementation

end.
