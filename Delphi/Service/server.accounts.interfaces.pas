unit server.accounts.interfaces;

interface

 uses
  System.Classes, server.common.interfaces, server.accounts.intf;

 type
   IAccountsData = interface(IServerInterface)
     ['{1B4FF30A-BF61-4603-A0F5-B6FE8B563DAF}']
      function NewAccount(const value: TMyAccount): TMyAccount;
      function GetAccounts: TStringList; overload;
      procedure GetAccounts(Stream: TMemoryStream); overload;
      function GetMyAccounts: UnicodeString;
      function DropAccount(const value: TMyAccount): boolean;
   end;

 type
   IAccountsController = interface(IServerInterface)
     ['{AB6FA87E-AF2D-4BA7-BF47-40CA0A9972A4}']
    function NewAccount(const Value: TMyAccount): TMyAccount;
    function GetMyAccounts: UnicodeString;
    function DropAccount(const value: TMyAccount): boolean;
   end;

implementation

end.
