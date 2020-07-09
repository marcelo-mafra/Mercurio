unit client.classes.json;

interface

uses
  System.SysUtils, System.Json, classes.exceptions, System.Generics.Collections,
  Data.DB;

 type
   {Classe utilitária para trabalho com dados no´padrão JSON.}
   TNetJsonUtils = class(TInterfacedObject)
     private

     public
      class function AsJsonObject(const JsonString: string): TJsonObject;
      class function FindValue(const JsonString: string; ValueName: string): string; overload;
      class function GetObjectCount(const JsonString: string; ArrayName: string): integer;
      class function FindValue(const JsonString: string; ArrayName: string; ValueName: string; Index: integer): string; overload;
      class procedure ToDataset(const JsonString: string; Dataset: TDataset);

   end;

implementation

{ TNetJsonUtils }

class function TNetJsonUtils.AsJsonObject(const JsonString: string): TJsonObject;
var
 JsonValueObj: TJsonValue;
begin
 if JsonString.IsEmpty then
  raise EJsonMessageTransf.Create;

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
{Encontra o valor de um atributo de um objeto JSON único. Só funciona com
um objeto JSON único. Não funciona com um array ou coleção de objetos.}
 JsonObj := self.AsJsonObject(JsonString);

 try
   Result := JsonObj.Values[ValueName].Value;

 finally
   JsonObj.Free;
 end;
end;

class function TNetJsonUtils.FindValue(const JsonString: string; ArrayName,
  ValueName: string; Index: integer): string;
var
  jsValueObj   : TJsonValue;
  originalObject : TJsonObject;
  jsPairObj : TJsonPair;
  jsArrayObj : TJsonArray;
  jsObject  : TJsonObject;
begin
    try
     //parse json string
     jsValueObj := TJSONObject.ParseJSONValue(UnicodeString(JsonString));

     try
       //value as object
       originalObject := jsValueObj as TJsonObject;

      //get pair, wich contains Array of objects
       jsPairObj := originalObject.Get(ArrayName);
       //pair value as array

       jsArrayObj := jsPairObj.jsonValue as  TJsonArray;

      //enumerate objects in array
      // i-th object
       jsObject := jsArrayObj.Items[Index] as TJsonObject;

      //Percorre os campos do objeto json
      for jsPairObj in jsObject do
        begin
          if UpperCase(jsPairObj.JsonString.Value.Trim) = UpperCase(ValueName.Trim) then
            begin
              Result := jsPairObj.JsonValue.Value;
              Break;
            end;
        end;

     finally
      jsValueObj.Free();
      {jsObject.Free;
      jsArray.Free;
      jsPair.Free;
      originalObject.Free;  }
     end;

    except
     raise;
    end;

end;

class function TNetJsonUtils.GetObjectCount(const JsonString: string;
   ArrayName: string): integer;
var
 jsValueObj   : TJsonValue;
 jsObject : TJsonObject;
 jsPairObj : TJsonPair;
 jsArrayObj : TJsonArray;

begin
 Result := 0;
 //parse json string
 jsValueObj := TJSONObject.ParseJSONValue(UnicodeString(JsonString));

 try
   //value as object
   jsObject := jsValueObj as TJsonObject;

   //get pair, wich contains Array of objects
   jsPairObj := jsObject.Get(ArrayName);
   //pair value as array
   jsArrayObj := jsPairObj.jsonValue as  TJsonArray;

   Result := jsArrayObj.Count;

 finally
  jsValueObj.Free();
 end;

end;

class procedure TNetJsonUtils.ToDataset(const JsonString: string;
  Dataset: TDataset);
begin

end;

end.
