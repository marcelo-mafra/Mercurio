unit client.model.listaaccounts;

interface
uses
  System.SysUtils, System.Classes, client.interfaces.common, Generics.Collections,
  client.interfaces.baseclasses, client.serverintf.accounts ;

type
   {Classe que representa uma lista de contas.}
   TListaAccounts = class(TListaObjetos)
    private
       FList: TObjectList<TMyAccount>;
       function GetCount: integer;
       function GetIsEmpty: boolean;

    public
       constructor Create;
       destructor Destroy; override;

       procedure AddItem(value: TMyAccount); reintroduce;
       procedure Clear;

       function Remove(Value: TMyAccount): boolean;
       function FindObject(Index: integer): TMyAccount;

       property Count: integer read GetCount;
       property IsEmpty: boolean read GetIsEmpty;
   end;

implementation

{ TListaAccounts }

procedure TListaAccounts.AddItem(value: TMyAccount);
begin
 FList.Add(Value);
end;

procedure TListaAccounts.Clear;
begin
 FList.Clear;
end;

constructor TListaAccounts.Create;
begin
 FList := TObjectList<TMyAccount>.Create;
 FList.OwnsObjects := true;
end;

destructor TListaAccounts.Destroy;
begin
  FList.Clear;
  FList.Free;
  inherited;
end;

function TListaAccounts.FindObject(Index: integer): TMyAccount;
begin
 Result := FList.Items[Index];
end;

function TListaAccounts.GetCount: integer;
begin
 Result :=  FList.Count;
end;

function TListaAccounts.GetIsEmpty: boolean;
begin
 Result := FList.Count = 0;
end;

function TListaAccounts.Remove(Value: TMyAccount): boolean;
begin
 Result := FList.Remove(Value) >= 0;
end;



end.
