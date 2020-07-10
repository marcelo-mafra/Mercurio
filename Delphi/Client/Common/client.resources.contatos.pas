unit client.resources.contatos;

interface

uses
  System.SysUtils;

type
{  Constantes relacionadas à execução de métodos no serviços remoto.}
  TContatosServerMethods = class
    const
      NewContatoSucess = 'A chamada do método remoto "NewContato" ' +
        'foi executada com sucesso.';
      NewContatoError = 'A chamada do método remoto "NewContato" falhou.';
      ExcluirContatoSucess = 'A chamada do método remoto "ExcluirContato" ' +
        'foi executada com sucesso.';
      ExcluirContatoError = 'A chamada do método remoto "ExcluirContato" falhou.';
      GetContatosSucess = 'A chamada do método remoto "GetContatos" ' +
        'foi executada com sucesso.';
      GetContatosError = 'A chamada do método remoto "GetContatos" falhou.';
      VariantCastError     = 'A conversão de um tipo de dados obtido do serviço remoto ' +
        'falhou e a leitura dos dados obtidos foi encerrada.';
  end;

{Constantes relacionadas a mensagens exibidas em caixas de diálogo.}
  TContatosDialogs = class
    const
      ConfDelContact = 'Confirma a exclusão do contato selecionado?';

  end;
implementation

end.
