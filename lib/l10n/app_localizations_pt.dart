// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Jogo de Vocabulário';

  @override
  String get appLoading => 'Carregando...';

  @override
  String get homeWelcome => 'Bem-vindo ao Jogo de Vocabulário!';

  @override
  String homeYouAreLearning(String language) {
    return 'Você está aprendendo $language';
  }

  @override
  String get homeStartGame => 'Iniciar jogo';

  @override
  String get homeVocabularyTooSmall =>
      'Você precisa de pelo menos 5 palavras para começar um jogo';

  @override
  String get homeLanguages => 'Idiomas de aprendizagem';

  @override
  String get homeVocabulary => 'Vocabulário';

  @override
  String get languagesTitle => 'Idiomas de aprendizagem';

  @override
  String get languagesAdd => 'Adicionar idioma';

  @override
  String get languagesSelect => 'Selecionar idioma de aprendizagem';

  @override
  String languagesCurrent(String language) {
    return 'Atual: $language';
  }

  @override
  String get vocabularyTitle => 'Vocabulário';

  @override
  String get vocabularyAddWord => 'Adicionar palavra';

  @override
  String get vocabularyNoWords =>
      'Nenhuma palavra ainda. Adicione algumas para começar!';

  @override
  String get vocabularyDeleteConfirm =>
      'Tem certeza que deseja excluir esta palavra?';

  @override
  String get vocabularyDelete => 'Excluir';

  @override
  String get vocabularyCancel => 'Cancelar';

  @override
  String get gameSelectTitle => 'Selecione o jogo';

  @override
  String get gameSelectGameMode => 'Selecione um modo de jogo:';

  @override
  String get gameDifficultyEasy => 'Fácil';

  @override
  String get gameDifficultyMedium => 'Médio';

  @override
  String get gameDifficultyHard => 'Difícil';

  @override
  String get gameDifficultyRandom => 'Aleatório';

  @override
  String get gameConnectWords => 'Conectar palavras';

  @override
  String get gameMultipleChoice => 'Múltipla escolha';

  @override
  String get gameWriteWords => 'Escrever palavras';

  @override
  String get connectionGameTitle => 'Jogo de Conexão';

  @override
  String get multipleChoiceGameTitle => 'Jogo de Múltipla Escolha';

  @override
  String get writeGameTitle => 'Jogo de Escrita';

  @override
  String get gameFromTranslations => 'de traduções';

  @override
  String get gameAnyGameMode => 'Qualquer modo de jogo';

  @override
  String get gameFlashcards => 'Cartões de memória';

  @override
  String get gameTyping => 'Digitação';

  @override
  String get gamePlayButton => 'Jogar';

  @override
  String get gameBack => 'Voltar';

  @override
  String gameScore(int score) {
    return 'Pontuação: $score';
  }

  @override
  String get gameCompleted => 'Jogo completo!';

  @override
  String gameFinalScore(int score) {
    return 'Pontuação final: $score';
  }

  @override
  String get dataTitle => 'Gerenciar dados';

  @override
  String get dataTooltip => 'Menu de dados';

  @override
  String get dataExport => 'Exportar vocabulário';

  @override
  String get dataImport => 'Importar vocabulário';

  @override
  String get dataClear => 'Limpar todos os dados';

  @override
  String get dataClearConfirm =>
      'Isso excluirá todos os seus dados. Esta ação não pode ser desfeita.';

  @override
  String get newWordTitle => 'Adicionar nova palavra';

  @override
  String get newWordInputLabel => 'Palavra em idioma de aprendizagem';

  @override
  String get newWordTranslationLabel => 'Tradução em seu idioma';

  @override
  String get newWordExamplesLabel => 'Exemplos (opcional)';

  @override
  String get newWordWord => 'Palavra';

  @override
  String get newWordTranslation => 'Tradução';

  @override
  String get newWordExample => 'Exemplo (opcional)';

  @override
  String get newWordSave => 'Salvar';

  @override
  String get fluencyLevel => 'Nível de fluência';

  @override
  String get fluencyLevelHelper =>
      'Palavras com níveis de fluência mais baixos aparecerão com mais frequência nos jogos.';

  @override
  String validationCharacterRange(int minLength, int maxLength) {
    return 'Deve ter entre $minLength e $maxLength caracteres.';
  }

  @override
  String get errorTitle => 'Erro';

  @override
  String get errorLoadingData => 'Erro ao carregar dados';

  @override
  String get errorSavingData => 'Erro ao guardar dados';

  @override
  String get successTitle => 'Sucesso';

  @override
  String get successWordAdded => 'Palavra adicionada com sucesso';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonDelete => 'Excluir';

  @override
  String get commonSave => 'Salvar';

  @override
  String get commonNext => 'Próximo';

  @override
  String get commonPlayAgain => 'Jogar novamente';

  @override
  String get commonRestore => 'Restaurar';

  @override
  String get allLanguages => 'Todos os idiomas';

  @override
  String get nameLabel => 'Nome';

  @override
  String get deleteLanguageTitle => 'Excluir idioma';

  @override
  String get deleteWordTitle => 'Excluir palavra';

  @override
  String get incorrectMatch => 'Correspondência incorreta! Tente novamente.';

  @override
  String get vocabularyEmptyMessage => 'Nenhuma palavra neste vocabulário.';

  @override
  String get saveLanguage => 'Salvar idioma';

  @override
  String get restoreDefaults => 'Restaurar padrões';

  @override
  String get confirmRestore => 'Confirmar restauração';

  @override
  String get gameWriteInstruction => 'Escreva a tradução da palavra:';

  @override
  String get gameAnswerLabel => 'Sua resposta';

  @override
  String get gameSubmit => 'Enviar';

  @override
  String get gameCompleteMessage => 'Parabéns! Você completou o jogo!';

  @override
  String deleteLanguageConfirm(String language) {
    return 'Tem certeza que deseja excluir $language e seu vocabulário? Esta ação não pode ser desfeita.';
  }

  @override
  String deleteWordConfirm(String word) {
    return 'Tem certeza que deseja excluir a palavra $word? Esta ação não pode ser desfeita.';
  }

  @override
  String get noWordsInVocabulary => 'Nenhuma palavra neste vocabulário.';

  @override
  String get dataManageTitle => 'Gerencie seus dados de vocabulário';

  @override
  String get dataSaveBackupTitle => 'Salvar backup';

  @override
  String get dataSaveBackupSubtitle => 'Salve seu vocabulário e idiomas atuais';

  @override
  String get dataRestoreBackupTitle => 'Restaurar backup';

  @override
  String get dataRestoreBackupSubtitle =>
      'Restaurar a partir de um backup salvo anteriormente';

  @override
  String get dataRestoreDefaultsTitle => 'Restaurar padrões';

  @override
  String get dataRestoreDefaultsSubtitle =>
      'Redefina para os padrões e limpe todos os dados';

  @override
  String get dataSaveFileDialogTitle => 'Salvar backup de vocabulário';

  @override
  String dataSaveSuccessMessage(String filename) {
    return 'Backup salvo com sucesso em: $filename';
  }

  @override
  String dataSaveErrorMessage(String error) {
    return 'Falha ao salvar o backup: $error';
  }

  @override
  String get dataRestoreFileDialogTitle =>
      'Selecione o arquivo de backup para restaurar';

  @override
  String dataRestoreErrorMessage(String error) {
    return 'Falha ao restaurar o backup: $error';
  }

  @override
  String get dataRestoreDefaultsConfirmMessage =>
      'Isso excluirá todos os seus dados de vocabulário e idiomas, retornando o aplicativo ao seu estado inicial. Você pode criar um backup primeiro se desejar salvar seus dados atuais. Esta ação não pode ser desfeita.\n\nTem certeza de que deseja continuar?';

  @override
  String get dataRestoreDefaultsSuccessMessage =>
      'Padrões restaurados com sucesso';

  @override
  String dataRestoreDefaultsErrorMessage(String error) {
    return 'Falha ao restaurar os padrões: $error';
  }

  @override
  String get dataConfirmRestoreTitle => 'Confirmar restauração';

  @override
  String get dataConfirmRestoreMessage =>
      'Isso substituirá todos os seus dados atuais pelos dados do backup. Esta ação não pode ser desfeita.\n\nTem certeza de que deseja continuar?';

  @override
  String get dataRestoreSuccessMessage => 'Backup restaurado com sucesso';

  @override
  String get dataRestoreDefaultsButton => 'Restaurar padrões';

  @override
  String get dataRestoreButton => 'Restaurar';
}
