unit server.contatos.data;

interface
 uses
  System.Classes, Data.DB, Datasnap.DBClient, System.Json,

  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.Stan.StorageJSON, FireDAC.Comp.BatchMove,
  FireDAC.Comp.BatchMove.JSON, System.SysUtils, server.contatos.intf,
  classes.contatos.types, server.contatos.interfaces, client.resources.contatos.dataobjects;

 type

   TContatosDAO = class(TInterfacedObject, IContatosData)
     public
      class function New: IContatosData;


      procedure GetContatos(Stream: TMemoryStream);

      function NewContato(const value: TMyContato): TMyContato;
      function GetMyContatos: UnicodeString;
      function ExcluirContato(const value: TMyContato): boolean;
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
   if Dataset.Locate('CONTACTID', Value.ContatoId, []) then
    begin
     Dataset.Delete;
     Dataset.SaveToFile('data.json', sfJson);
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
//  JsonObj: TJsonObject;
//  BatchMoveObj: TFDBatchMoveJSONWriter;
begin
 UtilsObj := TContatosDataUtils.Create;
 Dataset := UtilsObj.CreateDataset;
// BatchMoveObj := TFDBatchMoveJSONWriter.Create(nil);

 try
    Dataset.SaveToStream(Stream, sfJson);
 // BatchMoveObj.Stream := Stream;
 // BatchMoveObj.Execute;

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
 StrData: TStringList;
begin
 //Result := TStringList.Create;
 UtilsObj := TContatosDataUtils.Create;
 //StreamObj := TStringStream.Create('', TEncoding.UTF8);

 try
    Dataset := UtilsObj.CreateDataset;
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

       //Result.Append(JsonObj.ToString);
       JsonObj.Free;
       Dataset.Next;
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
       //Fields.FieldByName(TContatosFieldsNames.Foto).Value  := to-do;
       Fields.FieldByName(TContatosFieldsNames.Status).Value  := Result.Status;
       Post;
       SaveToFile('data.json', sfJson);
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
  Result.LoadFromFile('data.json', sfJson);
  Result.Active := True;
end;

end.
