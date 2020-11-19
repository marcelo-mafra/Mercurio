unit server.contatos.controller;

interface

 uses
  System.Classes, System.SysUtils, System.Json,
  server.contatos.intf, server.contatos.interfaces, server.contatos.data.factory;

 type

   TContatosController = class(TInterfacedObject, IContatosController)
    private
     function GetDAOInterface: IContatosData;

    public
     class function New: IContatosController;

     function NewContato(const value: TMyContato): TMyContato;
     function GetMyContatos: UnicodeString;
     function ExcluirContato(const value: TMyContato): boolean;

     property DAOInterface: IContatosData read GetDAOInterface;
   end;

implementation

{ TContatosController }
class function TContatosController.New: IContatosController;
begin
 Result := TContatosController.Create as IContatosController;
end;

function TContatosController.ExcluirContato(const value: TMyContato): boolean;
begin
 Result := self.DAOInterface.ExcluirContato(value);
end;

function TContatosController.GetDAOInterface: IContatosData;
begin
 Result := TContatosDAOFactory.New;
end;

function TContatosController.GetMyContatos: UnicodeString;
begin
 Result := self.DAOInterface.GetMyContatos;
end;

function TContatosController.NewContato(const value: TMyContato): TMyContato;
begin
 Result := self.DAOInterface.NewContato(value);
end;

end.
