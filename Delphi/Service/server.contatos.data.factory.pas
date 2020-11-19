unit server.contatos.data.factory;

interface

 uses
  System.Classes, System.SysUtils, server.contatos.interfaces,
  server.contatos.data;

 type
   TContatosDAOFactory = class
    private

    public
     class function New: IContatosData;
   end;


implementation

{ TContatosDAOFactory }

class function TContatosDAOFactory.New: IContatosData;
begin
 Result := TContatosDAO.New;
end;


end.
