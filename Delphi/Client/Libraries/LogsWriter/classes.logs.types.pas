unit classes.logs.types;

interface

uses

 Winapi.Windows;

 type
    //Eventos de geração de logs.
   TLogEvent = (leOnPrepare, leOnError, leOnTrace, leOnAuthenticateSucess,
    leOnAuthenticateFail, leOnAuthorize, leOnInformation, leOnWarning,
    //esses abaixo somente são usados na camada cliente.
    leOnConnect, leOnConnectError, leOnConnectClose, leOnMethodCall,
    leOnMethodCallError, leUnknown);

   //Conjunto de eventos de geração de logs.
   TLogEvents = set of TLogEvent;


   //Encapsula as informações salvas em um registro de log.
   TLogInfo = class
     const
      CONTEXT = 'ContextInfo=%s'; //do not localize!
      APPLICATION = 'Application=%s'; //do not localize!
      DATETIME = 'DateTime=%s'; //do not localize!
      LOGTYPE = 'LogType=%s'; //do not localize!
      MESSAGEINFO = 'Message=%s'; //do not localize!

   end;

  ///<summary>
   ///  Classe que ordena pequenas strings usadas como parte de registros de
   /// logs. </summary>
   TMercurioLogs =  class
    const
      CommandId             = 'Número do comando: %d';
      SQLCommand            = 'Comando executado: %s';
      SQLStoredProc         = 'Stored procedure: %s';
      SQLParamsInfo         = 'Parâmetro: %s: Valor: %s';
      SequenceName          = 'Sequence: %';
      ExecutedRemoteCommand = 'Comando remoto executado com sucesso: %s';
      ExecutedRemoteCommandFail = 'Falha na execução do comando remoto: %s';
      ExecuteScriptBegin    = 'Inicianado a execução de script de comandos. Script: %s';
      ExecuteScriptEnd      = 'Término da execução de script de comandos. Script: %s';
      //Tipos de logs
      InfoLogType               = 'Informação';
      ErrorLogType              = 'Erro';
      WarnLogType               = 'Aviso';
      PrepareLogType            = 'Prepare';
      TraceLogType              = 'Trace';
      AuthLogType               = 'Autenticação';
      AuthFailLogType           = 'Autenticação inválida';
      AutLogType                = 'Autorização';
      ConLogType                = 'Conexão';
      ConErrorLogType           = 'Falha na conexão';
      ConCloseLogType           = 'Conexão encerrada';
      DatabasePoolCreated       = 'Database pool criado com sucesso.';
      RemoteCallLogType         = 'Chamada remota';
      RemoteCallErrorLogType    = 'Falha na chamada remota';
      UnknownLogType            = 'Desconhecido';
      InitializedServer         = 'Servidor inicializado.';
      AuthorizationsMethods     = 'Autorizações de acesso a métodos remotos carregada com sucesso!';
      ErrorCode                 = 'Código do erro: %d';
      ContextInfoSession        = 'Seção: %d';
      ContextInfoUser           = 'Usuário: %s';
      ContextInfoRoles          = 'Perfis: %s';
      ContextInfoProtocol       = 'Protocolo: %s';
      ConnectedUser             = 'Usuário %s conectado com sucesso!';
      DisconnectedUser          = 'Usuário %s desconectado com sucesso!';
      AutenticatedUser          = 'Usuário %s autenticado com sucesso!';
      InactivedUser             = 'O usuário %s está inativo. Ele não pode acessar as aplicações Cosmos.';
      IncorrectLogin            = 'Falha na tentativa de login. Usuário: %s. Mensagem: %s';
      IncorrectStatment         = 'Falha na execução de comando sql: %s';
      InvalidAuthentication     = 'Autenticação inválida de usuário! Login: %s';
      BlockedUser               = 'O usuário %s está bloqueado. Ele não pode acessar as aplicações Cosmos.';
      AuthorizedRoles           = 'Perfis autorizadas a acessar o método: %s';
      DeniedAuthorization       = 'O usuário %s não está autorizado a acessar o método "%s"!';
      CantAcessCosmosModule     = 'Usuário não está autorizado a acessar este aplicativo ' +
          'do Cosmos. Procure um administrador do sistema para solicitar a permissão de acesso.';
      AppMethod                 = 'AppMethod: %s';
      ConnectingToHost          = 'Conectando ao servidor remoto em %s ...';
      PrepareConnect            = 'Preparando a conexão do usuário %s...';
      PrepareDisconnect         = 'Preparando a desconexão do usuário %s...';
      Preparing                 = 'Preparando a execução do método %s...';
      VerifyingIdentity         = 'Verificando identidade do usuário %s...';
      GettingAuthorizations      = 'Obtendo permissões do usuário %s...';
      ApplyPermissions          = 'Aplicando as permissões do usuário e montando o ambiente. Por favor, aguarde.';
      LoadingData               = 'Carregando dados do servidor para início da seção...';
      CheckingCertificate       = 'Verificando validade do certificado digital recebido...';
      CreatingConnectionsPool   = 'Criando o pool de conexões e ativando-o. Por favor, agarde um momento.';
      BufferingData             = 'Recuperando dados do servidor para utilização durante a seção de trabalho...';
      //Indicadores de sensibilidade dos logs
      Baixa = 'Baixa';
      Media = 'Média';
      Alta = 'Alta';
      SettingFolders            = 'As configurações de pastas do sistema foram lidas com sucesso.';
      //Títulos usados apenas no sistema de logs.
      TitlePrepare= 'Prepare';
      TitleTrace= 'TraceInfo';
      TitleAuthenticate='Authenticate';
      TitleAuthorize='Authorization';
   end;


   IMercurioLogs = interface
    ['{1BA3657F-D67F-4909-8606-70494B2D265C}']
    procedure RegisterAuditFailure(const Message: string);
    procedure RegisterAuditSucess(const Message: string);
    procedure RegisterError(const Message: string); overload;
    procedure RegisterError(const Message, ContextInfo: string); overload;
    procedure RegisterInfo(const Message: string);
    procedure RegisterSucess(const Message: string);
    procedure RegisterWarning(const Message: string);
    procedure RegisterRemoteCallSucess(const Message, ContextInfo: string);
    procedure RegisterRemoteCallFailure(const Message, ContextInfo: string);
    procedure RegisterLog(const Info, ContextInfo: string; Event: TLogEvent);
  end;


  TCustomLog = class(TInterfacedObject)

   private
    FEvents: TLogEvents;

   public
    constructor Create(Events: TLogEvents);
    destructor Destroy; override;

    procedure RegisterAuditFailure(const Message: string); virtual; abstract;
    procedure RegisterAuditSucess(const Message: string); virtual; abstract;
    procedure RegisterError(const Message: string); virtual; abstract;
    procedure RegisterInfo(const Message: string); virtual; abstract;
    procedure RegisterSucess(const Message: string); virtual; abstract;
    procedure RegisterWarning(const Message: string); virtual; abstract;
    procedure RegisterLog(const Info, ContextInfo: string; Event: TLogEvent); virtual; abstract;

    property Events: TLogEvents read FEvents;

  end;

implementation

{ TCustomLog }

constructor TCustomLog.Create(Events: TLogEvents);
begin
 inherited Create;
 FEvents := Events;
end;

destructor TCustomLog.Destroy;
begin
 inherited Destroy;
end;

end.
