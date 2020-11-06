unit client.view.controls.helpers;

interface

uses
 System.SysUtils, FMX.Edit;

type
   TEditHelper = class helper for TEdit

     function IsEmpty: boolean;

   end;

implementation

{ TEditHelper }

function TEditHelper.IsEmpty: boolean;
begin
 result := self.Text.Trim = string.Empty;
end;



end.
