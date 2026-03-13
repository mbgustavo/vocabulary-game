// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Vokabel-Spiel';

  @override
  String get appLoading => 'Wird geladen...';

  @override
  String get homeWelcome => 'Willkommen zum Vokabel-Spiel!';

  @override
  String homeYouAreLearning(String language) {
    return 'Du lernst $language';
  }

  @override
  String get homeStartGame => 'Spiel starten';

  @override
  String get homeVocabularyTooSmall =>
      'Du brauchst mindestens 5 Wörter, um ein Spiel zu starten';

  @override
  String get homeLanguages => 'Lernsprachen';

  @override
  String get homeVocabulary => 'Vokabeln';

  @override
  String get languagesTitle => 'Lernsprachen';

  @override
  String get languagesAdd => 'Sprache hinzufügen';

  @override
  String get languagesSelect => 'Lernsprache auswählen';

  @override
  String languagesCurrent(String language) {
    return 'Aktuell: $language';
  }

  @override
  String get vocabularyTitle => 'Vokabeln';

  @override
  String get vocabularyAddWord => 'Wort hinzufügen';

  @override
  String get vocabularyNoWords =>
      'Noch keine Wörter. Fügen Sie welche hinzu, um zu beginnen!';

  @override
  String get vocabularyDeleteConfirm =>
      'Bist du sicher, dass du dieses Wort löschen möchtest?';

  @override
  String get vocabularyDelete => 'Löschen';

  @override
  String get vocabularyCancel => 'Abbrechen';

  @override
  String get gameSelectTitle => 'Spiel auswählen';

  @override
  String get gameSelectGameMode => 'Wählen Sie einen Spielmodus:';

  @override
  String get gameDifficultyEasy => 'Leicht';

  @override
  String get gameDifficultyMedium => 'Mittel';

  @override
  String get gameDifficultyHard => 'Schwer';

  @override
  String get gameDifficultyRandom => 'Zufällig';

  @override
  String get gameConnectWords => 'Wörter verbinden';

  @override
  String get gameMultipleChoice => 'Multiple-Choice';

  @override
  String get gameWriteWords => 'Wörter schreiben';

  @override
  String get connectionGameTitle => 'Verbindungsspiel';

  @override
  String get multipleChoiceGameTitle => 'Multiple-Choice-Spiel';

  @override
  String get writeGameTitle => 'Schreibspiel';

  @override
  String get gameFromTranslations => 'von Übersetzungen';

  @override
  String get gameAnyGameMode => 'Beliebiger Spielmodus';

  @override
  String get gameFlashcards => 'Karteikarten';

  @override
  String get gameTyping => 'Tippen';

  @override
  String get gamePlayButton => 'Spielen';

  @override
  String get gameBack => 'Zurück';

  @override
  String gameScore(int score) {
    return 'Punktzahl: $score';
  }

  @override
  String get gameCompleted => 'Spiel abgeschlossen!';

  @override
  String gameFinalScore(int score) {
    return 'Endsumme: $score';
  }

  @override
  String get dataTitle => 'Daten verwalten';

  @override
  String get dataTooltip => 'Datenmenu';

  @override
  String get dataExport => 'Vokabeln exportieren';

  @override
  String get dataImport => 'Vokabeln importieren';

  @override
  String get dataClear => 'Alle Daten löschen';

  @override
  String get dataClearConfirm =>
      'Dadurch werden alle Ihre Daten gelöscht. Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get newWordTitle => 'Neues Wort hinzufügen';

  @override
  String get newWordInputLabel => 'Wort in Lernsprache';

  @override
  String get newWordTranslationLabel => 'Übersetzung in Ihre Sprache';

  @override
  String get newWordExamplesLabel => 'Beispiele (optional)';

  @override
  String get newWordWord => 'Wort';

  @override
  String get newWordTranslation => 'Übersetzung';

  @override
  String get newWordExample => 'Beispiel (optional)';

  @override
  String get newWordSave => 'Speichern';

  @override
  String get fluencyLevel => 'Sprachniveau';

  @override
  String get fluencyLevelHelper =>
      'Wörter mit niedrigeren Sprachniveaus werden in Spielen häufiger angezeigt.';

  @override
  String validationCharacterRange(int minLength, int maxLength) {
    return 'Muss zwischen $minLength und $maxLength Zeichen liegen.';
  }

  @override
  String get errorTitle => 'Fehler';

  @override
  String get errorLoadingData => 'Fehler beim Laden der Daten';

  @override
  String get errorSavingData => 'Fehler beim Speichern der Daten';

  @override
  String get successTitle => 'Erfolg';

  @override
  String get successWordAdded => 'Wort erfolgreich hinzugefügt';

  @override
  String get commonCancel => 'Abbrechen';

  @override
  String get commonDelete => 'Löschen';

  @override
  String get commonSave => 'Speichern';

  @override
  String get commonNext => 'Weiter';

  @override
  String get commonPlayAgain => 'Nochmal spielen';

  @override
  String get commonRestore => 'Wiederherstellen';

  @override
  String get allLanguages => 'Alle Sprachen';

  @override
  String get nameLabel => 'Name';

  @override
  String get deleteLanguageTitle => 'Sprache löschen';

  @override
  String get deleteWordTitle => 'Wort löschen';

  @override
  String get incorrectMatch =>
      'Falsche Übereinstimmung! Versuchen Sie es erneut.';

  @override
  String get vocabularyEmptyMessage => 'Keine Wörter in diesem Vokabular.';

  @override
  String get saveLanguage => 'Sprache speichern';

  @override
  String get restoreDefaults => 'Auf Standardwerte zurücksetzen';

  @override
  String get confirmRestore => 'Wiederherstellung bestätigen';

  @override
  String get gameWriteInstruction =>
      'Schreiben Sie die Übersetzung des Wortes:';

  @override
  String get gameAnswerLabel => 'Ihre Antwort';

  @override
  String get gameSubmit => 'Absenden';

  @override
  String get gameCompleteMessage =>
      'Glückwunsch! Sie haben das Spiel abgeschlossen!';

  @override
  String deleteLanguageConfirm(String language) {
    return 'Bist du sicher, dass du $language und sein Vokabular löschen möchtest? Diese Aktion kann nicht rückgängig gemacht werden.';
  }

  @override
  String deleteWordConfirm(String word) {
    return 'Bist du sicher, dass du das Wort $word löschen möchtest? Diese Aktion kann nicht rückgängig gemacht werden.';
  }

  @override
  String get noWordsInVocabulary => 'Keine Wörter in diesem Vokabular.';

  @override
  String get dataManageTitle => 'Verwalten Sie Ihre Vokabulardaten';

  @override
  String get dataSaveBackupTitle => 'Sicherung speichern';

  @override
  String get dataSaveBackupSubtitle =>
      'Speichern Sie Ihr aktuelles Vokabular und Ihre Sprachen';

  @override
  String get dataRestoreBackupTitle => 'Sicherung wiederherstellen';

  @override
  String get dataRestoreBackupSubtitle =>
      'Stellen Sie eine zuvor gespeicherte Sicherung wieder her';

  @override
  String get dataRestoreDefaultsTitle =>
      'Standardeinstellungen wiederherstellen';

  @override
  String get dataRestoreDefaultsSubtitle =>
      'Auf Standardeinstellungen zurücksetzen und alle Daten löschen';

  @override
  String get dataSaveFileDialogTitle => 'Vokabularsicherung speichern';

  @override
  String dataSaveSuccessMessage(String filename) {
    return 'Sicherung erfolgreich gespeichert in: $filename';
  }

  @override
  String dataSaveErrorMessage(String error) {
    return 'Fehler beim Speichern der Sicherung: $error';
  }

  @override
  String get dataRestoreFileDialogTitle =>
      'Wählen Sie die wiederherzustellende Sicherungsdatei aus';

  @override
  String dataRestoreErrorMessage(String error) {
    return 'Fehler beim Wiederherstellen der Sicherung: $error';
  }

  @override
  String get dataRestoreDefaultsConfirmMessage =>
      'Dies löscht alle Ihre Vokabulardaten und Sprachen und setzt die App auf ihren ursprünglichen Zustand zurück. Sie können zuerst eine Sicherung erstellen, wenn Sie Ihre aktuellen Daten speichern möchten. Diese Aktion kann nicht rückgängig gemacht werden.\n\nSind Sie sicher, dass Sie fortfahren möchten?';

  @override
  String get dataRestoreDefaultsSuccessMessage =>
      'Standardeinstellungen erfolgreich wiederhergestellt';

  @override
  String dataRestoreDefaultsErrorMessage(String error) {
    return 'Fehler beim Wiederherstellen der Standardeinstellungen: $error';
  }

  @override
  String get dataConfirmRestoreTitle => 'Wiederherstellung bestätigen';

  @override
  String get dataConfirmRestoreMessage =>
      'Dies ersetzt alle Ihre aktuellen Daten durch die Sicherungsdaten. Diese Aktion kann nicht rückgängig gemacht werden.\n\nSind Sie sicher, dass Sie fortfahren möchten?';

  @override
  String get dataRestoreSuccessMessage =>
      'Sicherung erfolgreich wiederhergestellt';

  @override
  String get dataRestoreDefaultsButton =>
      'Standardeinstellungen wiederherstellen';

  @override
  String get dataRestoreButton => 'Wiederherstellen';
}
