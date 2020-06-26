unit client.classes.json;

interface

uses
  System.SysUtils, System.Json, classes.exceptions, client.resources.consts;

 type
   {Classe utilitária para trabalho com dados no´padrão JSON.}
   TNetJsonUtils = class(TInterfacedObject)
     private

     public
      class function AsJsonObject(const JsonString: string): TJsonObject;
      class function FindValue(const JsonString: string; ValueName: string): string;

   end;

implementation

{ TNetJsonUtils }

class function TNetJsonUtils.AsJsonObject(const JsonString: string): TJsonObject;
var
 JsonValueObj: TJsonValue;
begin
 if JsonString.IsEmpty then
  raise EMercurioException.Create(TChatMessagesConst.MessageDataInvalid);

 try
   JsonValueObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(JsonString), 0);
   Result := JsonValueObj as TJSONObject;

 except
  on E: Exception do //to-do: logs e tratar os tipos de falhas possíveis.
   begin
     raise;
   end;
 end;
end;

class function TNetJsonUtils.FindValue(const JsonString: string;
  ValueName: string): string;
var
 JsonObj: TJsonObject;
begin
 JsonObj := self.AsJsonObject(JsonString);

 try
   Result := JsonObj.Values[ValueName].Value;

 finally
   JsonObj.Free;
 end;

end;

end.
