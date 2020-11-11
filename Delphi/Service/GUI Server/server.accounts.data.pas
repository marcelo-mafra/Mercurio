unit server.accounts.data;

interface

 uses
  System.Classes, Data.DB, Datasnap.DBClient, System.Json,

  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.Stan.StorageJSON, FireDAC.Comp.BatchMove,
  FireDAC.Comp.BatchMove.JSON, System.SysUtils, server.accounts.intf,
  client.resources.accounts.dataobjects;

 type

   TAccountsData = class
     strict private
      function DoCreateDataset: TFDMemTable;

     public
      class function New: TAccountsData;

      function NewAccount(const value: TMyAccount): TMyAccount;
      function GetAccounts: TStringList; overload;
      procedure GetAccounts(Stream: TMemoryStream); overload;
      function DropAccount(const value: TMyAccount): boolean;
   end;

implementation

type

 TAccountsDataUtils = class
   strict private

   public
     constructor Create;
     destructor Destroy; override;
     function CreateDataset: TFDMemTable;

 end;

{ TAccountsData }

function TAccountsData.GetAccounts: TStringList;
var
  Dataset: TFDMemTable;
  JsonObj: TJsonObject;
begin
 Result := TStringList.Create;
 Dataset := self.DoCreateDataset;

 try

    while not Dataset.Eof do
     begin
       JsonObj := TJsonObject.Create;
       JsonObj.AddPair(TJsonPair.Create(TAccountsJosonData.AccountId, Dataset.FieldByName(TAccountsFields.AccountId).AsString));
       JsonObj.AddPair(TJsonPair.Create(TAccountsJosonData.AccountName, Dataset.FieldByName(TAccountsFields.AccountName).AsString));
       JsonObj.AddPair(TJsonPair.Create(TAccountsJosonData.MyName, Dataset.FieldByName(TAccountsFields.MyName).AsString));
       JsonObj.AddPair(TJsonPair.Create(TAccountsJosonData.Enabled, Dataset.FieldByName(TAccountsFields.Enabled).AsString));
       JsonObj.AddPair(TJsonPair.Create(TAccountsJosonData.CreatedAt, Dataset.FieldByName(TAccountsFields.CreatedAt).AsString));

       Result.Append(JsonObj.ToString);
       JsonObj.Free;
       Dataset.Next;
     end;

 finally
  if Assigned(Dataset) then
   begin
    Dataset.Close;
    FreeAndNil(Dataset);
   end;
 end;

end;

function TAccountsData.DoCreateDataset: TFDMemTable;
var
  UtilsObj: TAccountsDataUtils;
begin
  UtilsObj := TAccountsDataUtils.Create;
  Result := UtilsObj.CreateDataset;
end;

function TAccountsData.DropAccount(const value: TMyAccount): boolean;
 var
  Dataset: TFDMemTable;
begin
 Dataset := self.DoCreateDataset;

 try
   Result := Dataset.Locate(TAccountsFields.AccountId, value.AccountId, []);

   if Result then
    begin
      Dataset.Delete;
      Result := True;
      Dataset.SaveToFile(TDataFile.FileName, sfJson);
    end;


 finally
  if Assigned(Dataset) then
    begin
     Dataset.Close;
     FreeAndNil(Dataset);
    end;
 end;

end;

procedure TAccountsData.GetAccounts(Stream: TMemoryStream);
 var
  Dataset: TFDMemTable;
begin
 Dataset := self.DoCreateDataset;

 try
    Dataset.SaveToStream(Stream, sfJson);

 finally
  if Assigned(Dataset) then
   begin
    Dataset.Close;
    FreeAndNil(Dataset);
   end;
 end;

end;

class function TAccountsData.New: TAccountsData;
begin
 Result := TAccountsData.Create;
end;

function TAccountsData.NewAccount(const value: TMyAccount): TMyAccount;
 var
  Dataset: TFDMemTable;
begin
 Result := Value;
 Dataset := self.DoCreateDataset;

 try
    with Dataset do
     begin
       Insert;
       Fields.FieldByName(TAccountsFields.AccountId).Value  := value.AccountId;
       Fields.FieldByName(TAccountsFields.AccountName).Value  := value.AccountName;
       Fields.FieldByName(TAccountsFields.MyName).Value  := value.MyName;
       Fields.FieldByName(TAccountsFields.Enabled).Value  := value.Enabled;
       Fields.FieldByName(TAccountsFields.CreatedAt).Value  := Now;
       //Value.CreatedAt := Now;
       Post;
       SaveToFile(TDataFile.FileName, sfJson);
     end;

 finally
  if Assigned(Dataset) then
    begin
     Dataset.Close;
     FreeAndNil(Dataset);
    end;
 end;

end;

{ TAccountsDataUtils }

constructor TAccountsDataUtils.Create;
begin
 inherited Create;
end;

function TAccountsDataUtils.CreateDataset: TFDMemTable;
var
 DataLink: TFDStanStorageJSONLink;
begin
  DataLink := TFDStanStorageJSONLink.Create(nil);
  Result := TFDMemTable.Create(nil);
  Result.LoadFromFile(TDataFile.FileName, sfJson);
  Result.Active := True;
end;

destructor TAccountsDataUtils.Destroy;
begin
  inherited;
end;

end.
