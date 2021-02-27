unit server.contatos.data;

interface
 uses
  System.Classes, Data.DB, System.Json, System.SysUtils,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.Stan.StorageJSON,
  server.contatos.intf, classes.contatos.types, server.contatos.interfaces,
  server.json.consts, client.resources.contatos.dataobjects;

 type

   TContatosDAO = class(TInterfacedObject, IContatosData)
     private
      procedure GetContatos(Stream: TMemoryStream);
      function DoCreateObject(const Dataset: TDataset): TMyContato;

     public
      class function New: IContatosData;
      //IContatosData methods
      function NewContato(const value: TMyContato): TMyContato;
      function GetMyContatos: UnicodeString;
      function ExcluirContato(const value: TMyContato): boolean;
      function AsObjects: TMyContatos;
   end;

implementation

type

 TContatosDataUtils = class
   strict private
    function GetNewId: string;

   public
     constructor Create;
     destructor Destroy; override;
     function CreateDataset: TFDMemTable;
     function SerializeGraphic(Field: TGraphicField): string;

     property NewId: string read GetNewId;
 end;

{ TContatosData }

function TContatosDAO.AsObjects: TMyContatos;
 var
  ArrayPos: integer;
  Dataset: TFDMemTable;
  UtilsObj: TContatosDataUtils;
  ContatosSet: TContatosArray;
begin
 Result := TMyContatos.Create;
 UtilsObj := TContatosDataUtils.Create;
 Dataset := UtilsObj.CreateDataset;
 ArrayPos := 0;
 SetLength(ContatosSet, Dataset.RecordCount);

 try
    while not Dataset.Eof do
     begin
      ContatosSet[ArrayPos] := self.DoCreateObject(Dataset);
      Inc(ArrayPos);
      Dataset.Next;
     end;

 Result.Contatos := ContatosSet;

 finally
  if Assigned(UtilsObj) then FreeAndNil(UtilsObj);
  if Assigned(Dataset) then  FreeAndNil(Dataset);
 end;

end;

function TContatosDAO.DoCreateObject(const Dataset: TDataset): TMyContato;
begin
 Result := TMyContato.Create;
 with Dataset.Fields do
  begin
   Result.ContatoId   := FieldByName(TContatosFieldsNames.ContactId).Value;
   Result.LastName    := FieldByName(TContatosFieldsNames.Sobrenome).Value;
   Result.FirstName   := FieldByName(TContatosFieldsNames.Nome).Value;
   Result.Status      := FieldByName(TContatosFieldsNames.Status).Value;
  end;
end;

function TContatosDAO.ExcluirContato(const value: TMyContato): boolean;
 var
  Dataset: TFDMemTable;
  UtilsObj: TContatosDataUtils;
begin
 Result := False;

 if Value = nil then
  Exit;

 UtilsObj := TContatosDataUtils.Create;

 try
   Dataset := UtilsObj.CreateDataset;
   if Dataset.Locate(TContatosFieldsNames.ContactId, Value.ContatoId, []) then
    begin
     Dataset.Delete;
     Dataset.SaveToFile(TDataFile.FileName, sfJson);
     Result := True;
    end;

 finally
  if Assigned(UtilsObj) then FreeAndNil(UtilsObj);
  if Assigned(Dataset) then
   begin
    Dataset.Close;
    FreeAndNil(UtilsObj);
   end;
 end;
end;

procedure TContatosDAO.GetContatos(Stream: TMemoryStream);
 var
  Dataset: TFDMemTable;
  UtilsObj: TContatosDataUtils;
begin
 UtilsObj := TContatosDataUtils.Create;
 Dataset := UtilsObj.CreateDataset;

 try
    Dataset.SaveToStream(Stream, sfJson);

 finally
  if Assigned(UtilsObj) then FreeAndNil(UtilsObj);
  if Assigned(Dataset) then
   begin
    Dataset.Close;
    FreeAndNil(Dataset);
   end;
 end;
end;

function TContatosDAO.GetMyContatos: UnicodeString;
 var
  Dataset: TFDMemTable;
  JsonObj: TJsonObject;
  UtilsObj: TContatosDataUtils;
  JDocumment: TStringStream;
begin
  UtilsObj := TContatosDataUtils.Create;
  JDocumment := TStringStream.Create(string.Empty, TEncoding.UTF8);
  JDocumment.WriteString(TJsonConsts.ArrayContatos);

 try
    Dataset := UtilsObj.CreateDataset;

    while not Dataset.Eof do
     begin
       JsonObj := TJsonObject.Create;
       JsonObj.AddPair(TJsonPair.Create(TContatosJosonData.ContactId, Dataset.FieldByName(TContatosFieldsNames.ContactId).AsString));
       JsonObj.AddPair(TJsonPair.Create(TContatosJosonData.Nome, Dataset.FieldByName(TContatosFieldsNames.Nome).AsString));
       JsonObj.AddPair(TJsonPair.Create(TContatosJosonData.Sobrenome, Dataset.FieldByName(TContatosFieldsNames.Sobrenome).AsString));
      { if not Dataset.FieldByName('FOTO').IsNull then
        begin
          StreamObj.Clear;
          TGraphicField(Dataset.FieldByName('FOTO')).SaveToStream(StreamObj);
          JsonObj.AddPair(TJsonPair.Create('FOTO', StreamObj.DataString));
        end
        else }
          JsonObj.AddPair(TJsonPair.Create(TContatosJosonData.Foto, ''));
       JsonObj.AddPair(TJsonPair.Create(TContatosJosonData.Status, Dataset.FieldByName(TContatosFieldsNames.Status).AsString));

       JDocumment.WriteString(JsonObj.ToString);
       JsonObj.Free;
       Dataset.Next;
     end;

    //Escreve o símbolo de fim do conjunto no padrão json.
    JDocumment.WriteString(TJsonConsts.ArrayTerminator);
    Result := JDocumment.DataString;

 finally
  if Assigned(UtilsObj) then FreeAndNil(UtilsObj);
  if Assigned(Dataset) then
   begin
    Dataset.Close;
    FreeAndNil(Dataset);
   end;
 end;
end;

class function TContatosDAO.New: IContatosData;
begin
 Result := TContatosDAO.Create as IContatosData;
end;

function TContatosDAO.NewContato(const value: TMyContato): TMyContato;
 var
  Dataset: TFDMemTable;
  UtilsObj: TContatosDataUtils;
begin
 Result := Value;
 Result.Status := TContatoStatus.Active;
 UtilsObj := TContatosDataUtils.Create;
 Result.ContatoId := UtilsObj.NewId;

 try
   Dataset := UtilsObj.CreateDataset;
    with Dataset do
     begin
       Insert;
       Fields.FieldByName(TContatosFieldsNames.ContactId).Value  := Result.ContatoId;
       Fields.FieldByName(TContatosFieldsNames.Nome).Value  := Result.FirstName;
       Fields.FieldByName(TContatosFieldsNames.Sobrenome).Value  := Result.LastName;
       Fields.FieldByName(TContatosFieldsNames.Foto).Clear; //to-do
       Fields.FieldByName(TContatosFieldsNames.Status).Value  := Result.Status;
       Post;
       SaveToFile(TDataFile.FileName, sfJson);
     end;

 finally
  if Assigned(UtilsObj) then FreeAndNil(UtilsObj);
  if Assigned(Dataset) then
    begin
     Dataset.Close;
     FreeAndNil(Dataset);
    end;
 end;


end;

{ TContatosDataUtils }

constructor TContatosDataUtils.Create;
begin
 inherited Create;
end;

destructor TContatosDataUtils.Destroy;
begin

  inherited;
end;

function TContatosDataUtils.GetNewId: string;
begin
 Result := Random(MaxInt).ToString;
end;

function TContatosDataUtils.SerializeGraphic(Field: TGraphicField): string;
begin
 Result := '';
end;

function TContatosDataUtils.CreateDataset: TFDMemTable;
var
 DataLink: TFDStanStorageJSONLink;
begin
  DataLink := TFDStanStorageJSONLink.Create(nil);
  Result := TFDMemTable.Create(nil);
  Result.LoadFromFile(TDataFile.FileName, sfJson);
  Result.Active := True;
end;

end.
