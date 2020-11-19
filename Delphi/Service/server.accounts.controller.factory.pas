unit server.accounts.controller.factory;

interface

 uses
  System.Classes, System.SysUtils, server.accounts.interfaces,
  server.accounts.controller;

 type
   TAccountsControllerFactory = class
    private

    public
     class function New: IAccountsController;
   end;


implementation

{ TAccountsControllerFactory }

class function TAccountsControllerFactory.New: IAccountsController;
begin
 Result := TAccountsController.New;
end;

end.
