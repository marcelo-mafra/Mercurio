unit client.classes.json;

interface

uses
  System.SysUtils, System.Json, classes.exceptions, client.resources.consts,
  System.Generics.Collections;

 type
   {Classe utilitária para trabalho com dados no´padrão JSON.}
   TNetJsonUtils = class(TInterfacedObject)
     private

     public
      class function AsJsonObject(const JsonString: string): TJsonObject;
      class function FindValue(const JsonString: string; ValueName: string): string; overload;
      class function GetObjectCount(const JsonString: string; ArrayName: string): integer;
      class function FindValue(const JsonString: string; ArrayName: string; ValueName: string; Index: integer): string; overload;

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
  jsValue   : TJsonValue;
  originalObject : TJsonObject;
  jsPair : TJsonPair;
  jsArray : TJsonArray;
  jsObject  : TJsonObject;
begin
    try
     //parse json string
     jsValue := TJSONObject.ParseJSONValue(UnicodeString(JsonString));

     try
       //value as object
       originalObject := jsValue as TJsonObject;

      //get pair, wich contains Array of objects
       jsPair := originalObject.Get(ArrayName);
       //pair value as array

       jsArray := jsPair.jsonValue as  TJsonArray;

      //enumerate objects in array
      // i-th object
       jsObject := jsArray.Items[Index] as TJsonObject;

      //Percorre os campos do objeto json
      for jsPair in jsObject do
        begin
          if UpperCase(jsPair.JsonString.Value.Trim) = UpperCase(ValueName.Trim) then
            begin
              Result := jsPair.JsonValue.Value;
              Break;
            end;
        end;

     finally
      jsValue.Free();
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
 jsValue   : TJsonValue;
 jsObject : TJsonObject;
 jsPair : TJsonPair;
 jsArray : TJsonArray;

begin
 Result := 0;
 //parse json string
 jsValue := TJSONObject.ParseJSONValue(UnicodeString(JsonString));

 try
   //value as object
   jsObject := jsValue as TJsonObject;

   //get pair, wich contains Array of objects
   jsPair := jsObject.Get(ArrayName);
   //pair value as array
   jsArray := jsPair.jsonValue as  TJsonArray;

   Result := jsArray.Count;

 finally
  jsValue.Free();
 end;

end;

end.
