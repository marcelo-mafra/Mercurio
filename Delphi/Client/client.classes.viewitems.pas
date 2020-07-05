unit client.classes.viewitems;

interface

uses
 System.SysUtils, Generics.Collections;

type
  TViewItem = (viNone, viContatos, viNovoContato, viProfile, viServiceInfo);
  {Classe que monta uma lista de "páginas" navegadas durante a sessão de uso
   do Mercúrio.}
  TNavegateList = class
    private
     FList: TList<TViewItem>;
     FCurrentIndex: integer;
     FCurrentItem: TViewItem;
     function GetCount: integer;
     function GetIsEmpty: boolean;
     function FindObject(Index: integer): TViewItem;
     function GetPreviousItem: TViewItem;

    public
      constructor Create;
      destructor Destroy; override;

      procedure AddItem(const Value: TViewItem); reintroduce;
      property CurrentIndex: integer read FCurrentIndex;
      property CurrentItem: TViewItem read FCurrentItem;
      property PreviousItem: TViewItem read GetPreviousItem;
      property Count: integer read GetCount;
      property IsEmpty: boolean read GetIsEmpty;
  end;


implementation

{ TNavegationItems }

procedure TNavegateList.AddItem(const Value: TViewItem);
begin
 FCurrentIndex := FList.Add(Value);
 FCurrentItem := Value;
end;

constructor TNavegateList.Create;
begin
 FList := TList<TViewItem>.Create;

 FCurrentItem := viNone;
end;

destructor TNavegateList.Destroy;
begin
  FList.Clear;
  FList.Free;
  inherited;
end;

function TNavegateList.FindObject(Index: integer): TViewItem;
begin
 if Index >= 0 then
  Result := FList.Items[Index]
 else
  Result := viNone;
end;

function TNavegateList.GetCount: integer;
begin
 Result :=  FList.Count;
end;

function TNavegateList.GetIsEmpty: boolean;
begin
 Result := FList.Count = 0;
end;

function TNavegateList.GetPreviousItem: TViewItem;
begin
 Result := self.FindObject(Pred(CurrentIndex));
end;

end.
