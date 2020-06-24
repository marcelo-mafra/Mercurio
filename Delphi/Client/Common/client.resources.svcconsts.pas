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
      ServiceHost = 'https://viacep.com.br/ws/31030-440/json';//'http://offeu.com/utf8.txt';
      ServiceName = 'Mercúrio chat service';

      UserAgent = 'Embarcadero URI Client/1.0';
  end;



implementation

end.
