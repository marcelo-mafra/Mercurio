unit server.data.contatos;

interface
 uses
  MidasLib, System.Classes, Data.DB, Datasnap.DBClient, System.Json,
  server.contatos.intf;

 type
   TContatosData = class
     class function CreateDataset: TClientDataset;
     class function GetContatos: TStringList;
     class function NewContato(const Value: TMyContato): TMyContato;
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
       JsonObj.AddPair(TJsonPair.Create('FIRSTNAME', Dataset.FieldByName('FIRSTNAME').AsString));
       JsonObj.AddPair(TJsonPair.Create('LASTNAME', Dataset.FieldByName('LASTNAME').AsString));
       Result.Append(JsonObj.ToString);
       JsonObj.Free;

       Dataset.Next;
     end;

 finally
  Dataset.Close;
  Dataset.Free
 end;
end;

class function TContatosData.NewContato(const Value: TMyContato): TMyContato;
 var
  Dataset: TClientDataset;
begin
 Result := Value;
 Dataset := self.CreateDataset;

 try
    with Dataset do
     begin
       Insert;
       Fields.FieldByName('CONTATOID').Value  := Random(6786578);
       Result.ContatoId := Fields.FieldByName('CONTATOID').Value;

       Fields.FieldByName('FIRSTNAME').Value  := Value.FirstName;
       Fields.FieldByName('LASTNAME').Value  := Value.LastName;
       Post;
       SaveToFile('contatos.cds');
     end;

 finally
  Dataset.Close;
  Dataset.Free
 end;
end;

end.
