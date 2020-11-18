unit server.permissions.data;

interface

 uses
  System.Classes, System.SysUtils, Data.DB, Datasnap.DBClient, System.Json,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.Stan.StorageJSON, FireDAC.Comp.BatchMove,
  FireDAC.Comp.BatchMove.JSON,
  server.permissions.intf, server.permissions.interfaces, classes.permissions.types,
  server.json.consts, client.resources.permissions.dataobjects;

 type

   TPermissionsData = class(TInterfacedObject, IPermissionsData)
    private
     function DoCreateObject(const Dataset: TDataset): TMyPermission;
     procedure GetPermissions(Stream: TMemoryStream);
    public
     class function New: IPermissionsData;

     function NewPermission(const Value: TMyPermission): TMyPermission;
     function GetMyPermissions: UnicodeString; overload;
     procedure GetMyPermissions(List: TStringList); overload;
     function AsObjects: TMyPermissions;
   end;


implementation

type

 TPermissionsDataUtils = class
   strict private

   public
     constructor Create;
     destructor Destroy; override;
     function CreateDataset: TFDMemTable;

 end;


{ TPermissionsData }
class function TPermissionsData.New: IPermissionsData;
begin
 Result := TPermissionsData.Create as IPermissionsData;
end;

function TPermissionsData.AsObjects: TMyPermissions;
 var
  ArrayPos: integer;
  Dataset: TFDMemTable;
  UtilsObj: TPermissionsDataUtils;
  APermission: TMyPermission;
  PermissionSet: TPermissionsArray;
begin
 Result := TMyPermissions.Create;
 UtilsObj := TPermissionsDataUtils.Create;
 Dataset := UtilsObj.CreateDataset;
 ArrayPos := 0;
 SetLength(PermissionSet, Dataset.RecordCount);

 try
    while not Dataset.Eof do
     begin
      PermissionSet[ArrayPos] := self.DoCreateObject(Dataset);
      Inc(ArrayPos);
      Dataset.Next;
     end;

 Result.Permissions := PermissionSet;

 finally
  if Assigned(UtilsObj) then FreeAndNil(UtilsObj);
  if Assigned(Dataset) then
   begin
    Dataset.Close;
    FreeAndNil(Dataset);
   end;
 end;
end;

function TPermissionsData.DoCreateObject(
  const Dataset: TDataset): TMyPermission;
begin
 Result := TMyPermission.Create;
 with Dataset.Fields do
  begin
   Result.FeatureId   := FieldByName(TPermissionsFields.FeatureId).Value;
   Result.FeatureName := FieldByName(TPermissionsFields.Feature).Value;
   Result.Usuario     := FieldByName(TPermissionsFields.Usuario).Value;
   Result.Enabled     := FieldByName(TPermissionsFields.Enabled).Value;
  end;
end;

function TPermissionsData.GetMyPermissions: UnicodeString;
var
 I: integer;
 JDocumment: TStringStream;
 StrData: TStringList;
begin
  JDocumment := TStringStream.Create(string.Empty, TEncoding.UTF8);
  JDocumment.WriteString(TJsonConsts.ArrayPermissoes);
  StrData := TStringList.Create;
  self.GetMyPermissions(StrData);

  try
   if StrData.Count > 0 then
   begin
   for I := 0 to StrData.Count - 1 do
    begin
     if I < StrData.Count - 1 then
      JDocumment.WriteString(StrData.Strings[I] + TJsonConsts.JsonTerminator)
     else
      JDocumment.WriteString(StrData.Strings[I]);
    end;
   end;
 //Escreve o símbolo de fim do conjunto no padrão json.
  JDocumment.WriteString(TJsonConsts.ArrayTerminator);
  Result := JDocumment.DataString;

  finally
   if Assigned(JDocumment) then FreeAndNil(JDocumment);
  end;

end;

procedure TPermissionsData.GetPermissions(Stream: TMemoryStream);
 var
  Dataset: TFDMemTable;
  UtilsObj: TPermissionsDataUtils;
begin
 UtilsObj := TPermissionsDataUtils.Create;
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

function TPermissionsData.NewPermission(
  const Value: TMyPermission): TMyPermission;
 var
  Dataset: TFDMemTable;
  UtilsObj: TPermissionsDataUtils;
begin
 Result := Value;
 UtilsObj := TPermissionsDataUtils.Create;

 try
   Dataset := UtilsObj.CreateDataset;
    with Dataset do
     begin
       Insert;
       Fields.FieldByName(TPermissionsFields.FeatureId).Value  := Result.FeatureId;
       Fields.FieldByName(TPermissionsFields.Feature).Value  := Result.FeatureName;
       Fields.FieldByName(TPermissionsFields.Usuario).Value  := Result.Usuario;
       Fields.FieldByName(TPermissionsFields.Enabled).Value  := Result.Enabled;
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

procedure TPermissionsData.GetMyPermissions(List: TStringList);
var
  Dataset: TFDMemTable;
  JsonObj: TJsonObject;
  UtilsObj: TPermissionsDataUtils;
begin
 UtilsObj := TPermissionsDataUtils.Create;

 try
    Dataset := UtilsObj.CreateDataset;

    while not Dataset.Eof do
     begin
       JsonObj := TJsonObject.Create;
       JsonObj.AddPair(TJsonPair.Create(TPermissionsJosonData.FeatureId, Dataset.FieldByName(TPermissionsFields.FeatureId).AsString));
       JsonObj.AddPair(TJsonPair.Create(TPermissionsJosonData.Feature, Dataset.FieldByName(TPermissionsFields.Feature).AsString));
       JsonObj.AddPair(TJsonPair.Create(TPermissionsJosonData.Usuario, Dataset.FieldByName(TPermissionsFields.Usuario).AsString));
       JsonObj.AddPair(TJsonPair.Create(TPermissionsJosonData.Enabled, Dataset.FieldByName(TPermissionsFields.Enabled).AsString));

       List.Append(JsonObj.ToString);
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

{ TPermissionsDataUtils }

constructor TPermissionsDataUtils.Create;
begin
 inherited Create;
end;

function TPermissionsDataUtils.CreateDataset: TFDMemTable;
var
 DataLink: TFDStanStorageJSONLink;
begin
  DataLink := TFDStanStorageJSONLink.Create(nil);
  Result := TFDMemTable.Create(nil);
  Result.LoadFromFile(TDataFile.FileName, sfJson);
  Result.Active := True;

end;

destructor TPermissionsDataUtils.Destroy;
begin
  inherited;
end;



end.
