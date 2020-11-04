unit client.resources.accounts.dataobjects;

interface

uses
  System.SysUtils;

type
  TDataFile = class
   const
     FileName = 'accounts.json';
  end;

{  Field names}
  TAccountsFields = class
    const
      AccountId = 'ACCOUNTID';  //do not localize!
      AccountName   = 'ACCOUNTNAME';
      MyName   = 'MYNAME' ;//do not localize!
      Enabled   = 'ENABLED';   //do not localize!
      CreatedAt = 'CREATEDAT'; //do not localize!
  end;

{  Json fields names and names of other json file objects}
  TAccountsJosonData = class
    const
      AccountId = 'AccountId';  //do not localize!
      AccountName   = 'AccountName';
      MyName   = 'MyName' ;//do not localize!
      Enabled   = 'Enabled';   //do not localize!
      CreatedAt = 'CreatedAt'; //do not localize!
      ArrayName = 'ArrayAccounts';  //do not localize!
  end;

implementation

end.
