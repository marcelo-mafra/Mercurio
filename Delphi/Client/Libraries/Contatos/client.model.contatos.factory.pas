unit client.model.contatos.factory;

interface

uses
 System.Classes, FMX.Types, FMX.Forms, client.interfaces.contatos, client.model.contatos,
 client.view.contatos.fmedetailed, client.view.contatos.fmesample,
 client.classes.session;

type
  TContatosFrame = (cfSample, cfDetailed);

  TFactoryContatos = class
    class function New(OnNewContato: TNewContatoNotifyEvent;
          OnDeleteContato: TDeleteContatoNotifyEvent): IContactsService;
  end;

  TFactoryFrameContatos = class
    class function New(const SessionObj: TConnectionSession; const Parent: TFmxObject;
      UpdateAction: TBasicAction; Frame: TContatosFrame): TFrame;
  end;

implementation

{ TFactoryContatos }

class function TFactoryContatos.New(OnNewContato: TNewContatoNotifyEvent;
  OnDeleteContato: TDeleteContatoNotifyEvent): IContactsService;
begin
  //Interface que abstrai o serviço remoto de contatos do usuário.
  Result := TContatosModel.Create(OnNewContato, OnDeleteContato) as IContactsService;
end;


{ TFactoryFrameContatos }

class function TFactoryFrameContatos.New(const SessionObj: TConnectionSession;
  const Parent: TFmxObject; UpdateAction: TBasicAction; Frame: TContatosFrame): TFrame;
begin
 case Frame of
   cfSample:
    begin
      Result := TFmeContatosSampleView.Create(SessionObj, Parent, UpdateAction);
    end;
   cfDetailed:
    begin
     Result := TFmeContatosDetailedView.Create(nil);
     TFmeContatosDetailedView(Result).Init;
    end;
 end;

 Result.Parent := Parent;
 Result.Align := TAlignLayout.Client;
 Result.Visible := True;
end;

end.
