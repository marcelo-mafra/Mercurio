unit server.accounts.data.factory;

interface

 uses
  System.Classes, System.SysUtils, server.accounts.data, server.accounts.interfaces;

 type
   TAccountsDAOFactory = class
    private

    public
     class function New: IAccountsData;
   end;

implementation

{ TAccountsDAOFactory }

class function TAccountsDAOFactory.New: IAccountsData;
begin
 Result := TAccountsDAO.New;
end;

end.
