unit server.chatserver.interfaces;

interface

 uses
  System.Classes, server.common.interfaces, server.chatserver.intf;

 type
   IChatServerData = interface(IServerInterface)
     ['{E547214B-9180-4D62-8578-56C3B0455894}']
     function NewChatMessage(const value: TChatMessage): TChatMessage;
   end;

 type
   IChatServerController = interface(IServerInterface)
     ['{A4885B69-3D44-4DBA-8C6A-7905D3A94606}']
     function NewChatMessage(const value: TChatMessage): TChatMessage;
   end;

implementation

end.
