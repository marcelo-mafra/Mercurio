unit server.chatserver.data;

interface

 uses
  System.Classes, Data.DB, System.Json, System.SysUtils,
 // FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
//  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
//  FireDAC.Comp.Client, FireDAC.Stan.StorageJSON,
  server.chatserver.intf, server.chatserver.interfaces,
  server.json.consts;//, client.resources.contatos.dataobjects;

 type

   TChatServerDAO = class(TInterfacedObject, IChatServerData)
     private

     public
      class function New: IChatServerData;
      function NewChatMessage(const value: TChatMessage): TChatMessage;
   end;

implementation

{ TChatServerDAO }

class function TChatServerDAO.New: IChatServerData;
begin
 Result := TChatServerDAO.Create as IChatServerData;
end;

function TChatServerDAO.NewChatMessage(const value: TChatMessage): TChatMessage;
begin

end;

end.
