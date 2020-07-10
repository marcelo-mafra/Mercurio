unit client.resources.contatos;

interface

uses
  System.SysUtils;

type
{  Constantes relacionadas � execu��o de m�todos no servi�os remoto.}
  TContatosServerMethods = class
    const
      NewContatoSucess = 'A chamada do m�todo remoto "NewContato" ' +
        'foi executada com sucesso.';
      NewContatoError = 'A chamada do m�todo remoto "NewContato" falhou.';
      ExcluirContatoSucess = 'A chamada do m�todo remoto "ExcluirContato" ' +
        'foi executada com sucesso.';
      ExcluirContatoError = 'A chamada do m�todo remoto "ExcluirContato" falhou.';
      GetContatosSucess = 'A chamada do m�todo remoto "GetContatos" ' +
        'foi executada com sucesso.';
      GetContatosError = 'A chamada do m�todo remoto "GetContatos" falhou.';
      VariantCastError     = 'A convers�o de um tipo de dados obtido do servi�o remoto ' +
        'falhou e a leitura dos dados obtidos foi encerrada.';
  end;

{Constantes relacionadas a mensagens exibidas em caixas de di�logo.}
  TContatosDialogs = class
    const
      ConfDelContact = 'Confirma a exclus�o do contato selecionado?';

  end;
implementation

end.
