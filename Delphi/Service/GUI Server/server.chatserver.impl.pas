{ Invokable implementation File for TMercurioChatServer which implements IMercurioChatServer }

unit server.chatserver.impl;

interface

uses Soap.InvokeRegistry, System.Types, Soap.XSBuiltIns, server.chatserver.intf,
 System.SysUtils, System.Json, client.resources.svcconsts;

type

  { TMercurioChatServer }
  TMercurioChatServer = class(TInvokableClass, IMercurioChatServer)
  public
    function echoEnum(const Value: TEnumTest): TEnumTest; stdcall;
    function echoDoubleArray(const Value: TDoubleArray): TDoubleArray; stdcall;
    function echoMyEmployee(const Value: TMyEmployee): TMyEmployee; stdcall;
    function echoDouble(const Value: Double): Double; stdcall;
    //------------------------------------
    function ServiceInfo: UnicodeString; stdcall;
    function NewChatMessage(const Value: TChatMessage): TChatMessage; stdcall;
  end;

implementation

function TMercurioChatServer.echoEnum(const Value: TEnumTest): TEnumTest; stdcall;
begin
  { TODO : Implement method echoEnum }
  Result := Value;
end;

function TMercurioChatServer.echoDoubleArray(const Value: TDoubleArray): TDoubleArray; stdcall;
begin
  { TODO : Implement method echoDoubleArray }
  Result := Value;
end;

function TMercurioChatServer.echoMyEmployee(const Value: TMyEmployee): TMyEmployee; stdcall;
begin
  { TODO : Implement method echoMyEmployee }
  Result := Value;
end;

function TMercurioChatServer.NewChatMessage(
  const Value: TChatMessage): TChatMessage;
begin
  Result := Value;
  Result.MessageId := Result.MessageId * 2;
  Result.StatusMsg := msRegistered;
  Result.RegisteredTime := Now;
end;

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

function TMercurioChatServer.echoDouble(const Value: Double): Double; stdcall;
begin
  { TODO : Implement method echoDouble }
  Result := Value;
end;


initialization
{ Invokable classes must be registered }
   InvRegistry.RegisterInvokableClass(TMercurioChatServer);
end.

