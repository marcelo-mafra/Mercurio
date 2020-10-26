unit server.permissions.data;

interface

 uses
  System.Classes, Data.DB, Datasnap.DBClient, System.Json,

  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.Stan.StorageJSON, FireDAC.Comp.BatchMove,
  FireDAC.Comp.BatchMove.JSON, System.SysUtils, server.permissions.intf,
  classes.permissions.types, client.resources.permissions.dataobjects;

 type

   TPermissionsData = class
     class function NewPermission(const Value: TMyPermission): TMyPermission;
     class function GetPermissions: TStringList; overload;
     class procedure GetPermissions(Stream: TMemoryStream); overload;

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

class procedure TPermissionsData.GetPermissions(Stream: TMemoryStream);
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

class function TPermissionsData.NewPermission(
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

class function TPermissionsData.GetPermissions: TStringList;
var
  Dataset: TFDMemTable;
  JsonObj: TJsonObject;
  UtilsObj: TPermissionsDataUtils;
//  StreamObj: TStringStream;
begin
 Result := TStringList.Create;
 UtilsObj := TPermissionsDataUtils.Create;
 //StreamObj := TStringStream.Create('', TEncoding.UTF8);

 try
    Dataset := UtilsObj.CreateDataset;
    //Dataset.SaveToStream(StreamObj, sfJson);
    //Result.LoadFromStream(StreamObj, TEncoding.UTF8);

    while not Dataset.Eof do
     begin
       JsonObj := TJsonObject.Create;
       JsonObj.AddPair(TJsonPair.Create(TPermissionsJosonData.FeatureId, Dataset.FieldByName(TPermissionsFields.FeatureId).AsString));
       JsonObj.AddPair(TJsonPair.Create(TPermissionsJosonData.Feature, Dataset.FieldByName(TPermissionsFields.Feature).AsString));
       JsonObj.AddPair(TJsonPair.Create(TPermissionsJosonData.Usuario, Dataset.FieldByName(TPermissionsFields.Usuario).AsString));
       JsonObj.AddPair(TJsonPair.Create(TPermissionsJosonData.Enabled, Dataset.FieldByName(TPermissionsFields.Enabled).AsString));

       Result.Append(JsonObj.ToString);
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
