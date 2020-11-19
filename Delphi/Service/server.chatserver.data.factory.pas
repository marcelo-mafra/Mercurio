unit server.chatserver.data.factory;

interface

 uses
  System.Classes, System.SysUtils, server.chatserver.data, server.chatserver.interfaces;

 type
   TChatServerDAOFactory = class
    private

    public
     class function New: IChatServerData;
   end;

implementation

{ TChatServerDAOFactory }

class function TChatServerDAOFactory.New: IChatServerData;
begin
 Result := TChatServerDAO.New;
end;

end.
