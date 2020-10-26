unit client.resources.permissions.dataobjects;

interface

uses
  System.SysUtils;

type
  TDataFile = class
   const
     FileName = 'permissions.json';
  end;

{  Field names}
  TPermissionsFields = class
    const
      FeatureId = 'FEATUREID';  //do not localize!
      Feature   = 'FEATURE';
      Usuario   = 'USUARIO' ;//do not localize!
      Enabled   = 'ENABLED';   //do not localize!
  end;

{  Json fields names and names of other json file objects}
  TPermissionsJosonData = class
    const
      FeatureId = 'FEATUREID';  //do not localize!
      Feature   = 'FEATURE';
      Usuario   = 'USUARIO' ;//do not localize!
      Enabled   = 'ENABLED';   //do not localize!
      ArrayName = 'ArrayPermissoes';  //do not localize!
  end;

implementation

end.
