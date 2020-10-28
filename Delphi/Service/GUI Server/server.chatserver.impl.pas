{ Invokable implementation File for TMercurioChatServer which implements IMercurioChatServer }

unit server.chatserver.impl;

interface

uses Soap.InvokeRegistry, System.Types, Soap.XSBuiltIns, server.chatserver.intf,
 System.SysUtils, System.Json;

type

  { TMercurioChatServer }
  TMercurioChatServer = class(TInvokableClass, IMercurioChatServer)
  public
{
    function ServiceInfo: UnicodeString; stdcall;    }
    function NewChatMessage(const Value: TChatMessage): TChatMessage; stdcall;
  end;

implementation

function TMercurioChatServer.NewChatMessage(
  const Value: TChatMessage): TChatMessage;
begin
  Result := Value;
  Result.MessageId := Result.MessageId * 2;
  Result.StatusMsg := msRegistered;
  Result.RegisteredTime := Now;
end;
{
function TMercurioChatServer.ServiceInfo: UnicodeString;
var
 JsonObj: TJsonObject;
begin
  JSonObj := TJsonObject.Create;

  try
   with JsonObj do
    begin
     AddPair('ServerHost', TChatServiceConst.ServiceHost);
     AddPair('ServerName', TChatServiceLabels.ServiceName);
     AddPair('ServerTime', DateTimeToStr(Now));
    end;

   Result := JsonObj.ToString;

  finally
   if Assigned(JsonObj) then FreeAndNil(JsonObj);
  end;
end;
}


initialization
{ Invokable classes must be registered }
   InvRegistry.RegisterInvokableClass(TMercurioChatServer);
end.

