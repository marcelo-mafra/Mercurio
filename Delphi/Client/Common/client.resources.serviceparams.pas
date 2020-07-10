unit client.resources.serviceparams;

interface

uses
  System.SysUtils;

type
  TServiceParams = class
    const
      AcceptEncoding = '65001'; //UTF-8
      AcceptLanguage = 'zh-CN';
      ConnectionTimeout = 2000; // 2 seconds
      ContentType = 'application/json';
      ResponseTimeout = 10000; // 10 seconds
      ServiceCharset = 'utf-8';
      ServiceHostTEMP = 'https://viacep.com.br/ws/31030-440/json';
      ServiceHost    = 'http://localhost:8080/soap/IMercurioChatServer/';
      ServiceInfoURL = 'http://localhost:8080/wsdl/IMercurioChatServer/ServiceInfo';
      UserAgent = 'Embarcadeiro URI Client/1.0';
  end;


implementation

end.
