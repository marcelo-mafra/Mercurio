unit server.accounts.impl;

interface

uses Soap.InvokeRegistry, System.Types, Soap.XSBuiltIns, server.accounts.intf,
 System.SysUtils, System.Json, System.Classes, server.accounts.data;

type
  TJsonConsts = class //do not localize!
    const
      ArrayAccounts = '{"ArrayAccounts":[';
      JsonTerminator  = ',';
      ArrayTerminator = ']}';
  end;

  { TMercurioAccountsServer }
  TMercurioAccountsServer = class(TInvokableClass, IMercurioAccountsServer)
  public
    function NewAccount(const Value: TMyAccount): TMyAccount; stdcall;
    function GetMyAccounts: UnicodeString; stdcall;
    function DropAccount(const value: TMyAccount): boolean; stdcall;
  end;

implementation

{ TMercurioAccountsServer }

function TMercurioAccountsServer.DropAccount(const value: TMyAccount): boolean;
begin
  Result := TAccountsData.DropAccount(value);
end;

function TMercurioAccountsServer.GetMyAccounts: UnicodeString;
var
 I: integer;
 JDocumment: TStringStream;
 StrData: TStringList;
begin
  JDocumment := TStringStream.Create(string.Empty, TEncoding.UTF8);
  JDocumment.WriteString(TJsonConsts.ArrayAccounts);
  StrData := TAccountsData.GetAccounts;

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

function TMercurioAccountsServer.NewAccount(
  const Value: TMyAccount): TMyAccount;
begin
  Result := TAccountsData.NewAccount(value);
end;


initialization
{ Invokable classes must be registered }
   InvRegistry.RegisterInvokableClass(TMercurioAccountsServer);
end.
