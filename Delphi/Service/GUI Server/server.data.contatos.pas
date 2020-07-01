unit server.data.contatos;

interface
 uses
  MidasLib, System.Classes, Data.DB, Datasnap.DBClient, System.Json;

 type
   TContatosData = class
     class function CreateDataset: TClientDataset;
     class function GetContatos: TStringList;
   end;

implementation

{ TContatosData }

class function TContatosData.CreateDataset: TClientDataset;
begin
  Result := TClientDataset.Create(nil);
  Result.LoadFromFile('contatos.cds');
  Result.Active := True;
end;

class function TContatosData.GetContatos: TStringList;
 var
  Dataset: TClientDataset;
  JsonObj: TJsonObject;
begin
 Result := TStringList.Create;
 Dataset := self.CreateDataset;

 try
    while not Dataset.Eof do
     begin
       JsonObj := TJsonObject.Create;
       JsonObj.AddPair(TJsonPair.Create('CONTATOID', Dataset.FieldByName('CONTATOID').AsString));
       JsonObj.AddPair(TJsonPair.Create('NOME', Dataset.FieldByName('NOME').AsString));
       Result.Append(JsonObj.ToString);
       JsonObj.Free;

       Dataset.Next;
     end;

 finally
  Dataset.Close;
  Dataset.Free
 end;
end;

end.
