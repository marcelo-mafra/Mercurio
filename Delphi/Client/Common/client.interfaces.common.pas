unit client.interfaces.common;

interface

uses
 System.SysUtils;

type

 //Define que uma listagem ser� feita por meio de datasets ou listas de objetos.
 TTransformModel = (tmDataset, tmListObject);

 //Interface root do Merc�rio. Todas as demais interfaces derivam dela.
 IMercurioInterface = interface
  ['{C9359853-CF08-45E6-9A1E-99C0D6D41E59}']

 end;


implementation



end.
