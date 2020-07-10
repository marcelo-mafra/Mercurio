unit server.data.contatos;

interface
 uses
  System.Classes, Data.DB, Datasnap.DBClient, System.Json,
  server.contatos.intf,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.Stan.StorageJSON, FireDAC.Comp.BatchMove,
  FireDAC.Comp.BatchMove.JSON, System.SysUtils;

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
//  JsonObj: TJsonObject;
//  BatchMoveObj: TFDBatchMoveJSONWriter;
begin
 Dataset := self.CreateDataset;
// BatchMoveObj := TFDBatchMoveJSONWriter.Create(nil);

 try
    Dataset.SaveToStream(Stream, sfJson);
 // BatchMoveObj.Stream := Stream;
 // BatchMoveObj.Execute;

 finally
  Dataset.Close;
  Dataset.Free
 end;
end;

class function TContatosData.GetContatos: TStringList;
 var
  Dataset: TFDMemTable;
  JsonObj: TJsonObject;
//  StreamObj: TStringStream;
begin
 Result := TStringList.Create;
 Dataset := self.CreateDataset;
 //StreamObj := TStringStream.Create('', TEncoding.UTF8);

 try
    //Dataset.SaveToStream(StreamObj, sfJson);
    //Result.LoadFromStream(StreamObj, TEncoding.UTF8);

    while not Dataset.Eof do
     begin
       JsonObj := TJsonObject.Create;
       JsonObj.AddPair(TJsonPair.Create('CONTACTID', Dataset.FieldByName('CONTACTID').AsString));
       JsonObj.AddPair(TJsonPair.Create('NOME', Dataset.FieldByName('NOME').AsString));
       JsonObj.AddPair(TJsonPair.Create('SOBRENOME', Dataset.FieldByName('SOBRENOME').AsString));
      { if not Dataset.FieldByName('FOTO').IsNull then
        begin
          StreamObj.Clear;
          TGraphicField(Dataset.FieldByName('FOTO')).SaveToStream(StreamObj);
          JsonObj.AddPair(TJsonPair.Create('FOTO', StreamObj.DataString));
        end
        else }
          JsonObj.AddPair(TJsonPair.Create('FOTO', ''));
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
 Result.Status := 1;
 Result.ContatoId :=  Random(6786578).ToString;
 Dataset := self.CreateDataset;

 try
    with Dataset do
     begin
       Insert;
       Fields.FieldByName('CONTACTID').Value  := Result.ContatoId;
       Fields.FieldByName('NOME').Value  := Result.FirstName;
       Fields.FieldByName('SOBRENOME').Value  := Result.LastName;
       //Fields.FieldByName('FOTO').Value  := to-do;
       Fields.FieldByName('STATUS').Value  := Result.Status;
       Post;
       SaveToFile('data.json', sfJson);
     end;

 finally
  Dataset.Close;
  Dataset.Free
 end;
end;

end.
