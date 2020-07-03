unit client.interfaces.common;

interface

type
 MsgIdentifier = int64;

 //Classe abstrata usada como classe-base para diversas listas de objetos.
 TListaObjetos = class

   public
     procedure AddItem(value: TObject); virtual; abstract;
 end;

 //Interface root do Mercúrio. Todas as demais interfaces derivam dela.
 IChatInterface = interface
  ['{C9359853-CF08-45E6-9A1E-99C0D6D41E59}']

 end;



implementation

end.
