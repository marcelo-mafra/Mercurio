unit classes.contatos.types;

interface

uses
 System.SysUtils;

type
 TContatosListStyle = (ltSample, ltDetailed);

 TContatoStatus = class
   const
    Active   = 1;
    Inactive = 0;
    Unknown  = -1;

    public
     constructor Create; virtual; abstract;
 end;


 TContatoStatusHelper = class helper for TContatoStatus
    function IsValid(const value: Shortint): boolean;
 end;



implementation

{ TContatoStatusHelper }

function TContatoStatusHelper.IsValid(const value: Shortint): boolean;
begin
 Result := (value = self.Unknown) or (value = self.Inactive) or (value = self.Active);
end;

end.
