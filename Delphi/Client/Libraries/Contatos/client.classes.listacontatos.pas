unit client.classes.listacontatos;

interface

uses
  System.SysUtils, System.Classes, client.interfaces.common, Generics.Collections,
  client.interfaces.contatos, client.serverintf.contatos ;

type
   {Classe que representa uma lista de contatos.}
   TListaContatos = class(TListaObjetos)
    private
       FList: TObjectList<TMyContato>;
       function GetCount: integer;
       function GetIsEmpty: boolean;
    public
       constructor Create;
       destructor Destroy; override;

       procedure AddItem(value: TMyContato); reintroduce;
       function Remove(Value: TMyContato): boolean;
       function FindObject(Index: integer): TMyContato;

       property Count: integer read GetCount;
       property IsEmpty: boolean read GetIsEmpty;
   end;


implementation


{ TListaContatos }

procedure TListaContatos.AddItem(value: TMyContato);
begin
 FList.Add(Value);
end;

constructor TListaContatos.Create;
begin
 FList := TObjectList<TMyContato>.Create;
 FList.OwnsObjects := true;
end;

destructor TListaContatos.Destroy;
begin
  FList.Clear;
  FList.Free;
  inherited;
end;

function TListaContatos.FindObject(Index: integer): TMyContato;
begin
 Result := FList.Items[Index];
end;

function TListaContatos.GetCount: integer;
begin
 Result :=  FList.Count;
end;

function TListaContatos.GetIsEmpty: boolean;
begin
 Result := FList.Count = 0;
end;
function TListaContatos.Remove(Value: TMyContato): boolean;
begin
 Result := FList.Remove(Value) >= 0;
end;

end.
