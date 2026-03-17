// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Jeu de vocabulaire';

  @override
  String get appLoading => 'Chargement...';

  @override
  String get homeWelcome => 'Bienvenue dans le jeu de vocabulaire!';

  @override
  String homeYouAreLearning(String language) {
    return 'Vous apprenez $language';
  }

  @override
  String get homeStartGame => 'Commencer le jeu';

  @override
  String get homeVocabularyTooSmall =>
      'Vous avez besoin d\'au moins 5 mots pour commencer un jeu';

  @override
  String get homeLanguages => 'Langues d\'apprentissage';

  @override
  String get homeVocabulary => 'Vocabulaire';

  @override
  String get languagesTitle => 'Langues d\'apprentissage';

  @override
  String get languagesAdd => 'Ajouter une langue';

  @override
  String get languagesSelect => 'Sélectionner la langue d\'apprentissage';

  @override
  String languagesCurrent(String language) {
    return 'Actuel: $language';
  }

  @override
  String get vocabularyTitle => 'Vocabulaire';

  @override
  String get vocabularyAddWord => 'Ajouter un mot';

  @override
  String get vocabularyNoWords =>
      'Aucun mot pour le moment. Ajoutez-en pour commencer!';

  @override
  String get vocabularyDeleteConfirm =>
      'Êtes-vous sûr de vouloir supprimer ce mot?';

  @override
  String get vocabularyDelete => 'Supprimer';

  @override
  String get vocabularyCancel => 'Annuler';

  @override
  String get gameSelectTitle => 'Sélectionner un jeu';

  @override
  String get gameSelectGameMode => 'Sélectionnez un mode de jeu:';

  @override
  String get gameDifficultyEasy => 'Facile';

  @override
  String get gameDifficultyMedium => 'Moyen';

  @override
  String get gameDifficultyHard => 'Difficile';

  @override
  String get gameDifficultyRandom => 'Aléatoire';

  @override
  String get gameConnectWords => 'Connecter les mots';

  @override
  String get gameMultipleChoice => 'Choix multiples';

  @override
  String get gameWriteWords => 'Écrire des mots';

  @override
  String get connectionGameTitle => 'Jeu de Connexion';

  @override
  String get multipleChoiceGameTitle => 'Jeu de Choix Multiples';

  @override
  String get writeGameTitle => 'Jeu d\'Écriture';

  @override
  String get gameFromTranslations => 'à partir des traductions';

  @override
  String get gameAnyGameMode => 'N\'importe quel mode de jeu';

  @override
  String get gameFlashcards => 'Cartes mémoire';

  @override
  String get gameTyping => 'Dactylographie';

  @override
  String get gamePlayButton => 'Jouer';

  @override
  String get gameBack => 'Retour';

  @override
  String gameScore(int score) {
    return 'Score: $score';
  }

  @override
  String get gameCompleted => 'Jeu terminé!';

  @override
  String gameFinalScore(int score) {
    return 'Score final: $score';
  }

  @override
  String get dataTitle => 'Gérer les données';

  @override
  String get dataTooltip => 'Menu des données';

  @override
  String get dataExport => 'Exporter le vocabulaire';

  @override
  String get dataImport => 'Importer le vocabulaire';

  @override
  String get dataClear => 'Effacer toutes les données';

  @override
  String get dataClearConfirm =>
      'Cela supprimera toutes vos données. Cette action est irréversible.';

  @override
  String get newWordTitle => 'Ajouter un nouveau mot';

  @override
  String get newWordInputLabel => 'Mot en langue d\'apprentissage';

  @override
  String get newWordTranslationLabel => 'Traduction dans votre langue';

  @override
  String get newWordExamplesLabel => 'Exemples (optionnel)';

  @override
  String get newWordWord => 'Mot';

  @override
  String get newWordTranslation => 'Traduction';

  @override
  String get newWordExample => 'Exemple (optionnel)';

  @override
  String get newWordSave => 'Enregistrer';

  @override
  String get fluencyLevel => 'Niveau de fluidité';

  @override
  String get fluencyLevelHelper =>
      'Les mots avec des niveaux de fluidité plus bas apparaîtront plus souvent dans les jeux.';

  @override
  String validationCharacterRange(int minLength, int maxLength) {
    return 'Doit être entre $minLength et $maxLength caractères.';
  }

  @override
  String get errorTitle => 'Erreur';

  @override
  String get errorLoadingData => 'Erreur lors du chargement des données';

  @override
  String get errorSavingData => 'Erreur lors de l\'enregistrement des données';

  @override
  String get successTitle => 'Succès';

  @override
  String get successWordAdded => 'Mot ajouté avec succès';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonDelete => 'Supprimer';

  @override
  String get commonSave => 'Enregistrer';

  @override
  String get commonNext => 'Suivant';

  @override
  String get commonPlayAgain => 'Rejouer';

  @override
  String get commonRestore => 'Restaurer';

  @override
  String get allLanguages => 'Toutes les langues';

  @override
  String get nameLabel => 'Nom';

  @override
  String get deleteLanguageTitle => 'Supprimer la langue';

  @override
  String get deleteWordTitle => 'Supprimer le mot';

  @override
  String get incorrectMatch => 'Correspondance incorrecte! Réessayez.';

  @override
  String get vocabularyEmptyMessage => 'Aucun mot dans ce vocabulaire.';

  @override
  String get saveLanguage => 'Enregistrer la langue';

  @override
  String get restoreDefaults => 'Restaurer les valeurs par défaut';

  @override
  String get confirmRestore => 'Confirmer la restauration';

  @override
  String get gameWriteInstruction => 'Écrivez la traduction du mot:';

  @override
  String get gameAnswerLabel => 'Votre réponse';

  @override
  String get gameSubmit => 'Soumettre';

  @override
  String get gameCompleteMessage => 'Félicitations! Vous avez terminé le jeu!';

  @override
  String deleteLanguageConfirm(String language) {
    return 'Êtes-vous sûr de vouloir supprimer $language et son vocabulaire? Cette action ne peut pas être annulée.';
  }

  @override
  String deleteWordConfirm(String word) {
    return 'Êtes-vous sûr de vouloir supprimer le mot $word? Cette action ne peut pas être annulée.';
  }

  @override
  String get noWordsInVocabulary => 'Aucun mot dans ce vocabulaire.';

  @override
  String get dataManageTitle => 'Gérez vos données de vocabulaire';

  @override
  String get dataSaveBackupTitle => 'Enregistrer une sauvegarde';

  @override
  String get dataSaveBackupSubtitle =>
      'Enregistrez votre vocabulaire et vos langues actuels';

  @override
  String get dataRestoreBackupTitle => 'Restaurer la sauvegarde';

  @override
  String get dataRestoreBackupSubtitle =>
      'Restaurez à partir d\'une sauvegarde précédemment enregistrée';

  @override
  String get dataRestoreDefaultsTitle => 'Restaurer les paramètres par défaut';

  @override
  String get dataRestoreDefaultsSubtitle =>
      'Réinitialisez les paramètres par défaut et effacez toutes les données';

  @override
  String get dataSaveFileDialogTitle =>
      'Enregistrer la sauvegarde du vocabulaire';

  @override
  String dataSaveSuccessMessage(String filename) {
    return 'Sauvegarde enregistrée avec succès dans : $filename';
  }

  @override
  String dataSaveErrorMessage(String error) {
    return 'Erreur lors de l\'enregistrement de la sauvegarde : $error';
  }

  @override
  String get dataRestoreFileDialogTitle =>
      'Sélectionnez le fichier de sauvegarde à restaurer';

  @override
  String dataRestoreErrorMessage(String error) {
    return 'Erreur lors de la restauration de la sauvegarde : $error';
  }

  @override
  String get dataRestoreDefaultsConfirmMessage =>
      'Cela supprimera toutes vos données de vocabulaire et vos langues, ramenant l\'application à son état initial. Vous pouvez créer une sauvegarde d\'abord si vous souhaitez enregistrer vos données actuelles. Cette action ne peut pas être annulée.\n\nÊtes-vous sûr de vouloir continuer ?';

  @override
  String get dataRestoreDefaultsSuccessMessage =>
      'Les paramètres par défaut ont été restaurés avec succès';

  @override
  String dataRestoreDefaultsErrorMessage(String error) {
    return 'Erreur lors de la restauration des paramètres par défaut : $error';
  }

  @override
  String get dataConfirmRestoreTitle => 'Confirmer la restauration';

  @override
  String get dataConfirmRestoreMessage =>
      'Cela remplacera toutes vos données actuelles par les données de la sauvegarde. Cette action ne peut pas être annulée.\n\nÊtes-vous sûr de vouloir continuer ?';

  @override
  String get dataRestoreSuccessMessage => 'Sauvegarde restaurée avec succès';

  @override
  String get dataRestoreDefaultsButton => 'Restaurer les paramètres par défaut';

  @override
  String get dataRestoreButton => 'Restaurer';
}
