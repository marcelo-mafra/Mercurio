unit client.resources.svcconsts;

interface

uses
  System.SysUtils;

type
  TChatServiceConst = class
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
  //Labels usados em diversos pontos da interface de uso da aplicação.
  TChatServiceLabels = class
    const
      ServiceName = 'Mercúrio chat';
      ServiceHost = 'Endereço remoto';
      ServiceTime = 'Server time';
  end;


implementation

end.
