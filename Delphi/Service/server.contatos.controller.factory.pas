unit server.contatos.controller.factory;

interface
 uses
  System.Classes, System.SysUtils, server.contatos.interfaces,
  server.contatos.controller;

 type
   TContatosControllerFactory = class
    private

    public
     class function New: IContatosController;
   end;

implementation

{ TContatosControllerFactory }
class function TContatosControllerFactory.New: IContatosController;
begin
 Result := TContatosController.New;
end;
end.
