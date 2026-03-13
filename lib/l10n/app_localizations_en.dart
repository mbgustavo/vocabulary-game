// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Vocabulary Game';

  @override
  String get appLoading => 'Loading...';

  @override
  String get homeWelcome => 'Welcome to Vocabulary Game!';

  @override
  String homeYouAreLearning(String language) {
    return 'You are learning $language';
  }

  @override
  String get homeStartGame => 'Start game';

  @override
  String get homeVocabularyTooSmall =>
      'You need at least 5 words to start a game';

  @override
  String get homeLanguages => 'Learning Languages';

  @override
  String get homeVocabulary => 'Vocabulary';

  @override
  String get languagesTitle => 'Learning languages';

  @override
  String get languagesAdd => 'Add Language';

  @override
  String get languagesSelect => 'Select learning language';

  @override
  String languagesCurrent(String language) {
    return 'Current: $language';
  }

  @override
  String get vocabularyTitle => 'Vocabulary';

  @override
  String get vocabularyAddWord => 'Add Word';

  @override
  String get vocabularyNoWords => 'No words yet. Add some to get started!';

  @override
  String get vocabularyDeleteConfirm =>
      'Are you sure you want to delete this word?';

  @override
  String get vocabularyDelete => 'Delete';

  @override
  String get vocabularyCancel => 'Cancel';

  @override
  String get gameSelectTitle => 'Select Game';

  @override
  String get gameSelectGameMode => 'Select a game mode:';

  @override
  String get gameDifficultyEasy => 'Easy';

  @override
  String get gameDifficultyMedium => 'Medium';

  @override
  String get gameDifficultyHard => 'Hard';

  @override
  String get gameDifficultyRandom => 'Random';

  @override
  String get gameConnectWords => 'Connect Words';

  @override
  String get gameMultipleChoice => 'Multiple Choice';

  @override
  String get gameWriteWords => 'Write Words';

  @override
  String get connectionGameTitle => 'Connection Game';

  @override
  String get multipleChoiceGameTitle => 'Multiple Choice Game';

  @override
  String get writeGameTitle => 'Write Game';

  @override
  String get gameFromTranslations => 'from translations';

  @override
  String get gameAnyGameMode => 'Any Game Mode';

  @override
  String get gameFlashcards => 'Flashcards';

  @override
  String get gameTyping => 'Typing';

  @override
  String get gamePlayButton => 'Play';

  @override
  String get gameBack => 'Back';

  @override
  String gameScore(int score) {
    return 'Score: $score';
  }

  @override
  String get gameCompleted => 'Game Completed!';

  @override
  String gameFinalScore(int score) {
    return 'Final Score: $score';
  }

  @override
  String get dataTitle => 'Data Management';

  @override
  String get dataTooltip => 'Data Menu';

  @override
  String get dataExport => 'Export Vocabulary';

  @override
  String get dataImport => 'Import Vocabulary';

  @override
  String get dataClear => 'Clear All Data';

  @override
  String get dataClearConfirm =>
      'This will delete all your data. This action cannot be undone.';

  @override
  String get newWordTitle => 'Add New Word';

  @override
  String get newWordInputLabel => 'Word in learning language';

  @override
  String get newWordTranslationLabel => 'Translation in your language';

  @override
  String get newWordExamplesLabel => 'Examples (optional)';

  @override
  String get newWordWord => 'Word';

  @override
  String get newWordTranslation => 'Translation';

  @override
  String get newWordExample => 'Example (optional)';

  @override
  String get newWordSave => 'Save';

  @override
  String get fluencyLevel => 'Fluency level';

  @override
  String get fluencyLevelHelper =>
      'Words with lower fluency levels will appear more often in games.';

  @override
  String validationCharacterRange(int minLength, int maxLength) {
    return 'Must be between $minLength and $maxLength characters.';
  }

  @override
  String get errorTitle => 'Error';

  @override
  String get errorLoadingData => 'Error loading data';

  @override
  String get errorSavingData => 'Error saving data';

  @override
  String get successTitle => 'Success';

  @override
  String get successWordAdded => 'Word added successfully';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonSave => 'Save';

  @override
  String get commonNext => 'Next';

  @override
  String get commonPlayAgain => 'Play again';

  @override
  String get commonRestore => 'Restore';

  @override
  String get allLanguages => 'All Languages';

  @override
  String get nameLabel => 'Name';

  @override
  String get deleteLanguageTitle => 'Delete Language';

  @override
  String get deleteWordTitle => 'Delete Word';

  @override
  String get incorrectMatch => 'Incorrect match! Try again.';

  @override
  String get vocabularyEmptyMessage => 'No words in this vocabulary.';

  @override
  String get saveLanguage => 'Save language';

  @override
  String get restoreDefaults => 'Restore Defaults';

  @override
  String get confirmRestore => 'Confirm Restore';

  @override
  String get gameWriteInstruction => 'Write the translation for the word:';

  @override
  String get gameAnswerLabel => 'Your answer';

  @override
  String get gameSubmit => 'Submit';

  @override
  String get gameCompleteMessage => 'Congratulations! You completed the game!';

  @override
  String deleteLanguageConfirm(String language) {
    return 'Are you sure you want to delete $language and its vocabulary? This action can\'t be undone.';
  }

  @override
  String deleteWordConfirm(String word) {
    return 'Are you sure you want to delete the word $word? This action can\'t be undone.';
  }

  @override
  String get noWordsInVocabulary => 'No words in this vocabulary.';

  @override
  String get dataManageTitle => 'Manage your vocabulary data';

  @override
  String get dataSaveBackupTitle => 'Save Backup';

  @override
  String get dataSaveBackupSubtitle =>
      'Save your current vocabulary and languages';

  @override
  String get dataRestoreBackupTitle => 'Restore Backup';

  @override
  String get dataRestoreBackupSubtitle =>
      'Restore from a previously saved backup';

  @override
  String get dataRestoreDefaultsTitle => 'Restore Defaults';

  @override
  String get dataRestoreDefaultsSubtitle =>
      'Reset to default settings and clear all data';

  @override
  String get dataSaveFileDialogTitle => 'Save vocabulary backup';

  @override
  String dataSaveSuccessMessage(String filename) {
    return 'Backup saved successfully to: $filename';
  }

  @override
  String dataSaveErrorMessage(String error) {
    return 'Failed to save backup: $error';
  }

  @override
  String get dataRestoreFileDialogTitle => 'Select backup file to restore';

  @override
  String dataRestoreErrorMessage(String error) {
    return 'Failed to restore backup: $error';
  }

  @override
  String get dataRestoreDefaultsConfirmMessage =>
      'This will delete all your vocabulary data and languages, returning the app to its initial state.\n\nYou can create a backup first if you want to save your current data. This action cannot be undone.\n\nAre you sure you want to continue?';

  @override
  String get dataRestoreDefaultsSuccessMessage =>
      'Successfully restored to defaults';

  @override
  String dataRestoreDefaultsErrorMessage(String error) {
    return 'Failed to restore defaults: $error';
  }

  @override
  String get dataConfirmRestoreTitle => 'Confirm Restore';

  @override
  String get dataConfirmRestoreMessage =>
      'This will replace all your current data with the backup data. This action cannot be undone.\n\nAre you sure you want to continue?';

  @override
  String get dataRestoreSuccessMessage => 'Backup restored successfully';

  @override
  String get dataRestoreDefaultsButton => 'Restore Defaults';

  @override
  String get dataRestoreButton => 'Restore';
}
