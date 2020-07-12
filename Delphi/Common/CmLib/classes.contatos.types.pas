unit classes.contatos.types;

interface

uses
 System.SysUtils;

type
 TContatosListStyle = (ltSample, ltDetailed, ltFull);

 TContatoStatus = class
   const
    Active   = 1;
    Inactive = 0;
    Unknown  = -1;
 end;



implementation

end.
