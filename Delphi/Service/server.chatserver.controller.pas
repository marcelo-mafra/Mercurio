unit server.chatserver.controller;

interface

 uses
  System.Classes, System.SysUtils, System.Json,
  server.chatserver.intf, server.chatserver.interfaces, server.chatserver.data.factory;

 type

   TChatServerController = class(TInterfacedObject, IChatServerController)
    private
     function GetDAOInterface: IChatServerData;

    public
     class function New: IChatserverController;
     function NewChatMessage(const value: TChatMessage): TChatMessage;

     property DAOInterface: IChatServerData read GetDAOInterface;
   end;

implementation

{ TChatserverController }

function TChatServerController.GetDAOInterface: IChatServerData;
begin
 Result := TChatServerDAOFactory.New;
end;

class function TChatServerController.New: IChatserverController;
begin
 Result := TChatServerController.Create as IChatserverController;
end;

function TChatServerController.NewChatMessage(
  const value: TChatMessage): TChatMessage;
begin
  Result := self.DAOInterface.NewChatMessage(value);
end;

end.
