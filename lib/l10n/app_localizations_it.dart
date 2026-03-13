// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Gioco di vocabolario';

  @override
  String get appLoading => 'Caricamento...';

  @override
  String get homeWelcome => 'Benvenuto nel gioco di vocabolario!';

  @override
  String homeYouAreLearning(String language) {
    return 'Stai imparando $language';
  }

  @override
  String get homeStartGame => 'Inizia il gioco';

  @override
  String get homeVocabularyTooSmall =>
      'Hai bisogno di almeno 5 parole per iniziare un gioco';

  @override
  String get homeLanguages => 'Lingue di apprendimento';

  @override
  String get homeVocabulary => 'Vocabolario';

  @override
  String get languagesTitle => 'Lingue di apprendimento';

  @override
  String get languagesAdd => 'Aggiungi lingua';

  @override
  String get languagesSelect => 'Seleziona lingua di apprendimento';

  @override
  String languagesCurrent(String language) {
    return 'Attuale: $language';
  }

  @override
  String get vocabularyTitle => 'Vocabolario';

  @override
  String get vocabularyAddWord => 'Aggiungi parola';

  @override
  String get vocabularyNoWords =>
      'Nessuna parola ancora. Aggiungine alcune per iniziare!';

  @override
  String get vocabularyDeleteConfirm =>
      'Sei sicuro di voler eliminare questa parola?';

  @override
  String get vocabularyDelete => 'Elimina';

  @override
  String get vocabularyCancel => 'Annulla';

  @override
  String get gameSelectTitle => 'Seleziona gioco';

  @override
  String get gameSelectGameMode => 'Seleziona una modalità di gioco:';

  @override
  String get gameDifficultyEasy => 'Facile';

  @override
  String get gameDifficultyMedium => 'Medio';

  @override
  String get gameDifficultyHard => 'Difficile';

  @override
  String get gameDifficultyRandom => 'Casuale';

  @override
  String get gameConnectWords => 'Collega parole';

  @override
  String get gameMultipleChoice => 'Scelta multipla';

  @override
  String get gameWriteWords => 'Scrivi parole';

  @override
  String get connectionGameTitle => 'Gioco di Connessione';

  @override
  String get multipleChoiceGameTitle => 'Gioco di Scelta Multipla';

  @override
  String get writeGameTitle => 'Gioco di Scrittura';

  @override
  String get gameFromTranslations => 'dalle traduzioni';

  @override
  String get gameAnyGameMode => 'Qualsiasi modalità di gioco';

  @override
  String get gameFlashcards => 'Flashcard';

  @override
  String get gameTyping => 'Digitazione';

  @override
  String get gamePlayButton => 'Gioca';

  @override
  String get gameBack => 'Indietro';

  @override
  String gameScore(int score) {
    return 'Punteggio: $score';
  }

  @override
  String get gameCompleted => 'Gioco completato!';

  @override
  String gameFinalScore(int score) {
    return 'Punteggio finale: $score';
  }

  @override
  String get dataTitle => 'Gestisci dati';

  @override
  String get dataTooltip => 'Menu dati';

  @override
  String get dataExport => 'Esporta vocabolario';

  @override
  String get dataImport => 'Importa vocabolario';

  @override
  String get dataClear => 'Cancella tutti i dati';

  @override
  String get dataClearConfirm =>
      'Questo eliminerà tutti i tuoi dati. Questa azione non può essere annullata.';

  @override
  String get newWordTitle => 'Aggiungi nuova parola';

  @override
  String get newWordInputLabel => 'Parola nella lingua di apprendimento';

  @override
  String get newWordTranslationLabel => 'Traduzione nella tua lingua';

  @override
  String get newWordExamplesLabel => 'Esempi (facoltativo)';

  @override
  String get newWordWord => 'Parola';

  @override
  String get newWordTranslation => 'Traduzione';

  @override
  String get newWordExample => 'Esempio (facoltativo)';

  @override
  String get newWordSave => 'Salva';

  @override
  String get fluencyLevel => 'Livello di scioltezza';

  @override
  String get fluencyLevelHelper =>
      'Le parole con livelli di scioltezza più bassi appariranno più spesso nei giochi.';

  @override
  String validationCharacterRange(int minLength, int maxLength) {
    return 'Deve essere tra $minLength e $maxLength caratteri.';
  }

  @override
  String get errorTitle => 'Errore';

  @override
  String get errorLoadingData => 'Errore nel caricamento dei dati';

  @override
  String get errorSavingData => 'Errore nel salvataggio dei dati';

  @override
  String get successTitle => 'Successo';

  @override
  String get successWordAdded => 'Parola aggiunta con successo';

  @override
  String get commonCancel => 'Annulla';

  @override
  String get commonDelete => 'Elimina';

  @override
  String get commonSave => 'Salva';

  @override
  String get commonNext => 'Successivo';

  @override
  String get commonPlayAgain => 'Gioca di nuovo';

  @override
  String get commonRestore => 'Ripristina';

  @override
  String get allLanguages => 'Tutte le lingue';

  @override
  String get nameLabel => 'Nome';

  @override
  String get deleteLanguageTitle => 'Elimina lingua';

  @override
  String get deleteWordTitle => 'Elimina parola';

  @override
  String get incorrectMatch => 'Abbinamento errato! Riprova.';

  @override
  String get vocabularyEmptyMessage => 'Nessuna parola in questo vocabolario.';

  @override
  String get saveLanguage => 'Salva lingua';

  @override
  String get restoreDefaults => 'Ripristina valori predefiniti';

  @override
  String get confirmRestore => 'Conferma ripristino';

  @override
  String get gameWriteInstruction => 'Scrivi la traduzione della parola:';

  @override
  String get gameAnswerLabel => 'La tua risposta';

  @override
  String get gameSubmit => 'Invia';

  @override
  String get gameCompleteMessage => 'Congratulazioni! Hai completato il gioco!';

  @override
  String deleteLanguageConfirm(String language) {
    return 'Sei sicuro di voler eliminare $language e il suo vocabolario? Questa azione non può essere annullata.';
  }

  @override
  String deleteWordConfirm(String word) {
    return 'Sei sicuro di voler eliminare la parola $word? Questa azione non può essere annullata.';
  }

  @override
  String get noWordsInVocabulary => 'Nessuna parola in questo vocabolario.';

  @override
  String get dataManageTitle => 'Gestisci i tuoi dati di vocabolario';

  @override
  String get dataSaveBackupTitle => 'Salva backup';

  @override
  String get dataSaveBackupSubtitle =>
      'Salva il tuo vocabolario e le tue lingue attuali';

  @override
  String get dataRestoreBackupTitle => 'Ripristina backup';

  @override
  String get dataRestoreBackupSubtitle =>
      'Ripristina da un backup salvato in precedenza';

  @override
  String get dataRestoreDefaultsTitle => 'Ripristina impostazioni predefinite';

  @override
  String get dataRestoreDefaultsSubtitle =>
      'Ripristina le impostazioni predefinite e cancella tutti i dati';

  @override
  String get dataSaveFileDialogTitle => 'Salva backup del vocabolario';

  @override
  String dataSaveSuccessMessage(String filename) {
    return 'Backup salvato con successo in: $filename';
  }

  @override
  String dataSaveErrorMessage(String error) {
    return 'Errore nel salvataggio del backup: $error';
  }

  @override
  String get dataRestoreFileDialogTitle =>
      'Seleziona il file di backup da ripristinare';

  @override
  String dataRestoreErrorMessage(String error) {
    return 'Errore nel ripristino del backup: $error';
  }

  @override
  String get dataRestoreDefaultsConfirmMessage =>
      'Ciò eliminerà tutti i tuoi dati di vocabolario e le tue lingue, riportando l\'app al suo stato iniziale. Puoi creare prima un backup se vuoi salvare i tuoi dati attuali. Questa azione non può essere annullata.\n\nSei sicuro di voler continuar?';

  @override
  String get dataRestoreDefaultsSuccessMessage =>
      'Impostazioni predefinite ripristinate con successo';

  @override
  String dataRestoreDefaultsErrorMessage(String error) {
    return 'Errore nel ripristino delle impostazioni predefinite: $error';
  }

  @override
  String get dataConfirmRestoreTitle => 'Conferma ripristino';

  @override
  String get dataConfirmRestoreMessage =>
      'Ciò sostituirà tutti i tuoi dati attuali con i dati del backup. Questa azione non può essere annullata.\n\nSei sicuro di voler continuare?';

  @override
  String get dataRestoreSuccessMessage => 'Backup ripristinato con successo';

  @override
  String get dataRestoreDefaultsButton => 'Ripristina impostazioni predefinite';

  @override
  String get dataRestoreButton => 'Ripristina';
}
