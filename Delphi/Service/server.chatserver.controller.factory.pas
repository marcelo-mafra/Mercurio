unit server.chatserver.controller.factory;

interface

 uses
  System.Classes, System.SysUtils, server.chatserver.interfaces,
  server.chatserver.controller;

 type
   TChatServerControllerFactory = class
    private

    public
     class function New: IChatServerController;
   end;


implementation

{ TChatServerControllerFactory }

class function TChatServerControllerFactory.New: IChatServerController;
begin
 Result := TChatServerController.New;
end;

end.
