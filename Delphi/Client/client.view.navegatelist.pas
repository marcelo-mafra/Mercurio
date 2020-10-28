unit client.view.navegatelist;

interface

uses
 System.SysUtils, Generics.Collections;

type
  {Representam "views" acessadas ao longo da navegação pelo aplicativo.}
  TViewItem = (viNone, viContatos, viNovoContato, viProfile, viServiceInfo);

  {Constantes usadas pela classe TNavegateList.}
  TNavConst = class
    const
     InitialValue = -1;
     MinValue = 0;

  end;

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

      procedure AddItem(const value: TViewItem); reintroduce;
      property CurrentIndex: integer read FCurrentIndex;
      property CurrentItem: TViewItem read FCurrentItem;
      property PreviousItem: TViewItem read GetPreviousItem;
      property Count: integer read GetCount;
      property IsEmpty: boolean read GetIsEmpty;
  end;


implementation

{ TNavegationItems }

procedure TNavegateList.AddItem(const value: TViewItem);
begin
 FCurrentIndex := FList.Add(Value);
 FCurrentItem := Value;
end;

constructor TNavegateList.Create;
begin
 FList := TList<TViewItem>.Create;
 FCurrentIndex := TNavConst.InitialValue;
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
 if Index >= TNavConst.MinValue then Result := FList.Items[Index]
 else
   Result := viNone;

 FCurrentIndex := Index;
 FCurrentItem := Result;
end;

function TNavegateList.GetCount: integer;
begin
 Result :=  FList.Count;
end;

function TNavegateList.GetIsEmpty: boolean;
begin
 Result := FList.Count = TNavConst.MinValue;
end;

function TNavegateList.GetPreviousItem: TViewItem;
begin
 if CurrentIndex >= TNavConst.MinValue then
   Dec(FCurrentIndex);

 Result := self.FindObject(CurrentIndex);
end;

end.
