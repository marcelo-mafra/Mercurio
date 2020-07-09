unit server.data.contatos;

interface
 uses
  System.Classes, Data.DB, Datasnap.DBClient, System.Json,
  server.contatos.intf,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.Stan.StorageJSON, FireDAC.Comp.BatchMove,
  FireDAC.Comp.BatchMove.JSON;

 type
   TContatosData = class
     class function CreateDataset: TFDMemTable;
     class function GetContatos: TStringList; overload;
     class procedure GetContatos(Stream: TMemoryStream); overload;
     class function NewContato(const Value: TMyContato): TMyContato;
     class function ExcluirContato(value: TMyContato): boolean;
   end;

implementation

{ TContatosData }

class function TContatosData.CreateDataset: TFDMemTable;
var
 DataLink: TFDStanStorageJSONLink;
begin
  DataLink := TFDStanStorageJSONLink.Create(nil);
  Result := TFDMemTable.Create(nil);
  Result.LoadFromFile('data.json', sfJson);
  Result.Active := True;
end;

class function TContatosData.ExcluirContato(value: TMyContato): boolean;
 var
  Dataset: TFDMemTable;
begin
 Result := False;

 if Value = nil then
  Exit;

 Dataset := self.CreateDataset;

 try
   if Dataset.Locate('CONTATOID', Value.ContatoId, []) then
    begin
     Dataset.Delete;
     Dataset.SaveToFile('data.json', sfJson);
     Result := True;
    end;

 finally
  Dataset.Close;
  Dataset.Free
 end;
end;

class procedure TContatosData.GetContatos(Stream: TMemoryStream);
 var
  Dataset: TFDMemTable;
  JsonObj: TJsonObject;
  BatchMoveObj: TFDBatchMoveJSONWriter;
begin
 Dataset := self.CreateDataset;

 BatchMoveObj := TFDBatchMoveJSONWriter.Create(nil);

 try
  BatchMoveObj.Stream := Stream;
  BatchMoveObj.Execute;

 finally
  Dataset.Close;
  Dataset.Free
 end;

end;

class function TContatosData.GetContatos: TStringList;
 var
  Dataset: TFDMemTable;
  JsonObj: TJsonObject;
  StreamObj: TMemoryStream;
  BatchMoveObj: TFDBatchMoveJSONWriter;
begin
 Result := TStringList.Create;
 Dataset := self.CreateDataset;

 { StreamObj := TMemoryStream.Create;
  BatchMoveObj := TFDBatchMoveJSONWriter.Create(nil);
  AResponse.Body.SetStream(StreamObj,'application/json', True);  }


 try
{  BatchMoveObj.Stream := StreamObj;
  BatchMoveObj.Execute;
  Result := StreamObj.ToString;}

    while not Dataset.Eof do
     begin
       JsonObj := TJsonObject.Create;
       JsonObj.AddPair(TJsonPair.Create('CONTACTID', Dataset.FieldByName('CONTACTID').AsString));
       JsonObj.AddPair(TJsonPair.Create('NOME', Dataset.FieldByName('NOME').AsString));
       JsonObj.AddPair(TJsonPair.Create('SOBRENOME', Dataset.FieldByName('SOBRENOME').AsString));
       JsonObj.AddPair(TJsonPair.Create('FOTO', Dataset.FieldByName('FOTO').AsString));
       JsonObj.AddPair(TJsonPair.Create('STATUS', Dataset.FieldByName('STATUS').AsString));
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
  Dataset: TFDMemTable;
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
