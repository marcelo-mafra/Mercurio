unit client.resources.contatos.dataobjects;

interface

uses
  System.SysUtils;

type
  TDataFile = class
   const
     FileName = 'data.json';
  end;

{  Field names}
  TContatosFieldsNames = class
    const
      ContactId = 'CONTACTID';  //do not localize!
      Nome = 'NOME';
      Sobrenome = 'SOBRENOME' ;//do not localize!
      Foto = 'FOTO';   //do not localize!
      Status = 'STATUS';   //do not localize!
  end;

{  Json fields names and names of other json file objects}
  TContatosJosonData = class
    const
      ContactId = 'CONTACTID'; //do not localize!
      Nome = 'NOME'; //do not localize!
      Sobrenome = 'SOBRENOME' ; //do not localize!
      Foto = 'FOTO'; //do not localize!
      Status = 'STATUS'; //do not localize!
      ArrayName = 'ArrayContatos';  //do not localize!
  end;


implementation

end.
