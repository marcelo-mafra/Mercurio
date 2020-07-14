unit classes.logs.types;

interface

uses

 Winapi.Windows;

 type
    //Eventos de gera��o de logs.
   TLogEvent = (leOnPrepare, leOnError, leOnTrace, leOnAuthenticateSucess,
    leOnAuthenticateFail, leOnAuthorize, leOnInformation, leOnWarning,
    //esses abaixo somente s�o usados na camada cliente.
    leOnConnect, leOnConnectError, leOnConnectClose, leOnMethodCall,
    leOnMethodCallError, leUnknown);

   //Conjunto de eventos de gera��o de logs.
   TLogEvents = set of TLogEvent;


   //Encapsula as informa��es salvas em um registro de log.
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
      CommandId             = 'N�mero do comando: %d';
      SQLCommand            = 'Comando executado: %s';
      SQLStoredProc         = 'Stored procedure: %s';
      SQLParamsInfo         = 'Par�metro: %s: Valor: %s';
      SequenceName          = 'Sequence: %';
      ExecutedRemoteCommand = 'Comando remoto executado com sucesso: %s';
      ExecutedRemoteCommandFail = 'Falha na execu��o do comando remoto: %s';
      ExecuteScriptBegin    = 'Inicianado a execu��o de script de comandos. Script: %s';
      ExecuteScriptEnd      = 'T�rmino da execu��o de script de comandos. Script: %s';
      //Tipos de logs
      InfoLogType               = 'Informa��o';
      ErrorLogType              = 'Erro';
      WarnLogType               = 'Aviso';
      PrepareLogType            = 'Prepare';
      TraceLogType              = 'Trace';
      AuthLogType               = 'Autentica��o';
      AuthFailLogType           = 'Autentica��o inv�lida';
      AutLogType                = 'Autoriza��o';
      ConLogType                = 'Conex�o';
      ConErrorLogType           = 'Falha na conex�o';
      ConCloseLogType           = 'Conex�o encerrada';
      DatabasePoolCreated       = 'Database pool criado com sucesso.';
      RemoteCallLogType         = 'Chamada remota';
      RemoteCallErrorLogType    = 'Falha na chamada remota';
      UnknownLogType            = 'Desconhecido';
      InitializedServer         = 'Servidor inicializado.';
      AuthorizationsMethods     = 'Autoriza��es de acesso a m�todos remotos carregada com sucesso!';
      ErrorCode                 = 'C�digo do erro: %d';
      ContextInfoSession        = 'Se��o: %d';
      ContextInfoUser           = 'Usu�rio: %s';
      ContextInfoRoles          = 'Perfis: %s';
      ContextInfoProtocol       = 'Protocolo: %s';
      ConnectedUser             = 'Usu�rio %s conectado com sucesso!';
      DisconnectedUser          = 'Usu�rio %s desconectado com sucesso!';
      AutenticatedUser          = 'Usu�rio %s autenticado com sucesso!';
      InactivedUser             = 'O usu�rio %s est� inativo. Ele n�o pode acessar as aplica��es Cosmos.';
      IncorrectLogin            = 'Falha na tentativa de login. Usu�rio: %s. Mensagem: %s';
      IncorrectStatment         = 'Falha na execu��o de comando sql: %s';
      InvalidAuthentication     = 'Autentica��o inv�lida de usu�rio! Login: %s';
      BlockedUser               = 'O usu�rio %s est� bloqueado. Ele n�o pode acessar as aplica��es Cosmos.';
      AuthorizedRoles           = 'Perfis autorizadas a acessar o m�todo: %s';
      DeniedAuthorization       = 'O usu�rio %s n�o est� autorizado a acessar o m�todo "%s"!';
      CantAcessCosmosModule     = 'Usu�rio n�o est� autorizado a acessar este aplicativo ' +
          'do Cosmos. Procure um administrador do sistema para solicitar a permiss�o de acesso.';
      AppMethod                 = 'AppMethod: %s';
      ConnectingToHost          = 'Conectando ao servidor remoto em %s ...';
      PrepareConnect            = 'Preparando a conex�o do usu�rio %s...';
      PrepareDisconnect         = 'Preparando a desconex�o do usu�rio %s...';
      Preparing                 = 'Preparando a execu��o do m�todo %s...';
      VerifyingIdentity         = 'Verificando identidade do usu�rio %s...';
      GettingAuthorizations      = 'Obtendo permiss�es do usu�rio %s...';
      ApplyPermissions          = 'Aplicando as permiss�es do usu�rio e montando o ambiente. Por favor, aguarde.';
      LoadingData               = 'Carregando dados do servidor para in�cio da se��o...';
      CheckingCertificate       = 'Verificando validade do certificado digital recebido...';
      CreatingConnectionsPool   = 'Criando o pool de conex�es e ativando-o. Por favor, agarde um momento.';
      BufferingData             = 'Recuperando dados do servidor para utiliza��o durante a se��o de trabalho...';
      //Indicadores de sensibilidade dos logs
      Baixa = 'Baixa';
      Media = 'M�dia';
      Alta = 'Alta';
      SettingFolders            = 'As configura��es de pastas do sistema foram lidas com sucesso.';
      //T�tulos usados apenas no sistema de logs.
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
