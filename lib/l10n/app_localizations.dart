import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('pt'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Vocabulary Game'**
  String get appTitle;

  /// No description provided for @appLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get appLoading;

  /// No description provided for @homeWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Vocabulary Game!'**
  String get homeWelcome;

  /// Text showing what language the user is learning
  ///
  /// In en, this message translates to:
  /// **'You are learning {language}'**
  String homeYouAreLearning(String language);

  /// No description provided for @homeStartGame.
  ///
  /// In en, this message translates to:
  /// **'Start game'**
  String get homeStartGame;

  /// No description provided for @homeVocabularyTooSmall.
  ///
  /// In en, this message translates to:
  /// **'You need at least 5 words to start a game'**
  String get homeVocabularyTooSmall;

  /// No description provided for @homeLanguages.
  ///
  /// In en, this message translates to:
  /// **'Learning Languages'**
  String get homeLanguages;

  /// No description provided for @homeVocabulary.
  ///
  /// In en, this message translates to:
  /// **'Vocabulary'**
  String get homeVocabulary;

  /// No description provided for @languagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Learning languages'**
  String get languagesTitle;

  /// No description provided for @languagesAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Language'**
  String get languagesAdd;

  /// No description provided for @languagesSelect.
  ///
  /// In en, this message translates to:
  /// **'Select learning language'**
  String get languagesSelect;

  /// Shows the current learning language
  ///
  /// In en, this message translates to:
  /// **'Current: {language}'**
  String languagesCurrent(String language);

  /// No description provided for @vocabularyTitle.
  ///
  /// In en, this message translates to:
  /// **'Vocabulary'**
  String get vocabularyTitle;

  /// No description provided for @vocabularyAddWord.
  ///
  /// In en, this message translates to:
  /// **'Add Word'**
  String get vocabularyAddWord;

  /// No description provided for @vocabularyNoWords.
  ///
  /// In en, this message translates to:
  /// **'No words yet. Add some to get started!'**
  String get vocabularyNoWords;

  /// No description provided for @vocabularyDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this word?'**
  String get vocabularyDeleteConfirm;

  /// No description provided for @vocabularyDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get vocabularyDelete;

  /// No description provided for @vocabularyCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get vocabularyCancel;

  /// No description provided for @gameSelectTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Game'**
  String get gameSelectTitle;

  /// No description provided for @gameSelectGameMode.
  ///
  /// In en, this message translates to:
  /// **'Select a game mode:'**
  String get gameSelectGameMode;

  /// No description provided for @gameDifficultyEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get gameDifficultyEasy;

  /// No description provided for @gameDifficultyMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get gameDifficultyMedium;

  /// No description provided for @gameDifficultyHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get gameDifficultyHard;

  /// No description provided for @gameDifficultyRandom.
  ///
  /// In en, this message translates to:
  /// **'Random'**
  String get gameDifficultyRandom;

  /// No description provided for @gameConnectWords.
  ///
  /// In en, this message translates to:
  /// **'Connect Words'**
  String get gameConnectWords;

  /// No description provided for @gameMultipleChoice.
  ///
  /// In en, this message translates to:
  /// **'Multiple Choice'**
  String get gameMultipleChoice;

  /// No description provided for @gameWriteWords.
  ///
  /// In en, this message translates to:
  /// **'Write Words'**
  String get gameWriteWords;

  /// No description provided for @connectionGameTitle.
  ///
  /// In en, this message translates to:
  /// **'Connection Game'**
  String get connectionGameTitle;

  /// No description provided for @multipleChoiceGameTitle.
  ///
  /// In en, this message translates to:
  /// **'Multiple Choice Game'**
  String get multipleChoiceGameTitle;

  /// No description provided for @writeGameTitle.
  ///
  /// In en, this message translates to:
  /// **'Write Game'**
  String get writeGameTitle;

  /// No description provided for @gameFromTranslations.
  ///
  /// In en, this message translates to:
  /// **'from translations'**
  String get gameFromTranslations;

  /// No description provided for @gameAnyGameMode.
  ///
  /// In en, this message translates to:
  /// **'Any Game Mode'**
  String get gameAnyGameMode;

  /// No description provided for @gameFlashcards.
  ///
  /// In en, this message translates to:
  /// **'Flashcards'**
  String get gameFlashcards;

  /// No description provided for @gameTyping.
  ///
  /// In en, this message translates to:
  /// **'Typing'**
  String get gameTyping;

  /// No description provided for @gamePlayButton.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get gamePlayButton;

  /// No description provided for @gameBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get gameBack;

  /// Shows the player's current score
  ///
  /// In en, this message translates to:
  /// **'Score: {score}'**
  String gameScore(int score);

  /// No description provided for @gameCompleted.
  ///
  /// In en, this message translates to:
  /// **'Game Completed!'**
  String get gameCompleted;

  /// Shows the final score after game completion
  ///
  /// In en, this message translates to:
  /// **'Final Score: {score}'**
  String gameFinalScore(int score);

  /// No description provided for @dataTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get dataTitle;

  /// No description provided for @dataTooltip.
  ///
  /// In en, this message translates to:
  /// **'Data Menu'**
  String get dataTooltip;

  /// No description provided for @dataExport.
  ///
  /// In en, this message translates to:
  /// **'Export Vocabulary'**
  String get dataExport;

  /// No description provided for @dataImport.
  ///
  /// In en, this message translates to:
  /// **'Import Vocabulary'**
  String get dataImport;

  /// No description provided for @dataClear.
  ///
  /// In en, this message translates to:
  /// **'Clear All Data'**
  String get dataClear;

  /// No description provided for @dataClearConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will delete all your data. This action cannot be undone.'**
  String get dataClearConfirm;

  /// No description provided for @newWordTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New Word'**
  String get newWordTitle;

  /// No description provided for @newWordInputLabel.
  ///
  /// In en, this message translates to:
  /// **'Word in learning language'**
  String get newWordInputLabel;

  /// No description provided for @newWordTranslationLabel.
  ///
  /// In en, this message translates to:
  /// **'Translation in your language'**
  String get newWordTranslationLabel;

  /// No description provided for @newWordExamplesLabel.
  ///
  /// In en, this message translates to:
  /// **'Examples (optional)'**
  String get newWordExamplesLabel;

  /// No description provided for @newWordWord.
  ///
  /// In en, this message translates to:
  /// **'Word'**
  String get newWordWord;

  /// No description provided for @newWordTranslation.
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get newWordTranslation;

  /// No description provided for @newWordExample.
  ///
  /// In en, this message translates to:
  /// **'Example (optional)'**
  String get newWordExample;

  /// No description provided for @newWordSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get newWordSave;

  /// No description provided for @fluencyLevel.
  ///
  /// In en, this message translates to:
  /// **'Fluency level'**
  String get fluencyLevel;

  /// No description provided for @fluencyLevelHelper.
  ///
  /// In en, this message translates to:
  /// **'Words with lower fluency levels will appear more often in games.'**
  String get fluencyLevelHelper;

  /// Validation message for character range
  ///
  /// In en, this message translates to:
  /// **'Must be between {minLength} and {maxLength} characters.'**
  String validationCharacterRange(int minLength, int maxLength);

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorTitle;

  /// No description provided for @errorLoadingData.
  ///
  /// In en, this message translates to:
  /// **'Error loading data'**
  String get errorLoadingData;

  /// No description provided for @errorSavingData.
  ///
  /// In en, this message translates to:
  /// **'Error saving data'**
  String get errorSavingData;

  /// No description provided for @successTitle.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get successTitle;

  /// No description provided for @successWordAdded.
  ///
  /// In en, this message translates to:
  /// **'Word added successfully'**
  String get successWordAdded;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonPlayAgain.
  ///
  /// In en, this message translates to:
  /// **'Play again'**
  String get commonPlayAgain;

  /// No description provided for @commonRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get commonRestore;

  /// No description provided for @allLanguages.
  ///
  /// In en, this message translates to:
  /// **'All Languages'**
  String get allLanguages;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @deleteLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Language'**
  String get deleteLanguageTitle;

  /// No description provided for @deleteWordTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Word'**
  String get deleteWordTitle;

  /// No description provided for @incorrectMatch.
  ///
  /// In en, this message translates to:
  /// **'Incorrect match! Try again.'**
  String get incorrectMatch;

  /// No description provided for @vocabularyEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'No words in this vocabulary.'**
  String get vocabularyEmptyMessage;

  /// No description provided for @saveLanguage.
  ///
  /// In en, this message translates to:
  /// **'Save language'**
  String get saveLanguage;

  /// No description provided for @restoreDefaults.
  ///
  /// In en, this message translates to:
  /// **'Restore Defaults'**
  String get restoreDefaults;

  /// No description provided for @confirmRestore.
  ///
  /// In en, this message translates to:
  /// **'Confirm Restore'**
  String get confirmRestore;

  /// No description provided for @gameWriteInstruction.
  ///
  /// In en, this message translates to:
  /// **'Write the translation for the word:'**
  String get gameWriteInstruction;

  /// No description provided for @gameAnswerLabel.
  ///
  /// In en, this message translates to:
  /// **'Your answer'**
  String get gameAnswerLabel;

  /// No description provided for @gameSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get gameSubmit;

  /// No description provided for @gameCompleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! You completed the game!'**
  String get gameCompleteMessage;

  /// Confirmation message for deleting a language
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {language} and its vocabulary? This action can\'t be undone.'**
  String deleteLanguageConfirm(String language);

  /// Confirmation message for deleting a word
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the word {word}? This action can\'t be undone.'**
  String deleteWordConfirm(String word);

  /// No description provided for @noWordsInVocabulary.
  ///
  /// In en, this message translates to:
  /// **'No words in this vocabulary.'**
  String get noWordsInVocabulary;

  /// No description provided for @dataManageTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your vocabulary data'**
  String get dataManageTitle;

  /// No description provided for @dataSaveBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Save Backup'**
  String get dataSaveBackupTitle;

  /// No description provided for @dataSaveBackupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save your current vocabulary and languages'**
  String get dataSaveBackupSubtitle;

  /// No description provided for @dataRestoreBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore Backup'**
  String get dataRestoreBackupTitle;

  /// No description provided for @dataRestoreBackupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Restore from a previously saved backup'**
  String get dataRestoreBackupSubtitle;

  /// No description provided for @dataRestoreDefaultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore Defaults'**
  String get dataRestoreDefaultsTitle;

  /// No description provided for @dataRestoreDefaultsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reset to default settings and clear all data'**
  String get dataRestoreDefaultsSubtitle;

  /// No description provided for @dataSaveFileDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Save vocabulary backup'**
  String get dataSaveFileDialogTitle;

  /// Success message when backup is saved
  ///
  /// In en, this message translates to:
  /// **'Backup saved successfully to: {filename}'**
  String dataSaveSuccessMessage(String filename);

  /// Error message when backup fails to save
  ///
  /// In en, this message translates to:
  /// **'Failed to save backup: {error}'**
  String dataSaveErrorMessage(String error);

  /// No description provided for @dataRestoreFileDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Select backup file to restore'**
  String get dataRestoreFileDialogTitle;

  /// Error message when backup fails to restore
  ///
  /// In en, this message translates to:
  /// **'Failed to restore backup: {error}'**
  String dataRestoreErrorMessage(String error);

  /// No description provided for @dataRestoreDefaultsConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This will delete all your vocabulary data and languages, returning the app to its initial state.\n\nYou can create a backup first if you want to save your current data. This action cannot be undone.\n\nAre you sure you want to continue?'**
  String get dataRestoreDefaultsConfirmMessage;

  /// No description provided for @dataRestoreDefaultsSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Successfully restored to defaults'**
  String get dataRestoreDefaultsSuccessMessage;

  /// Error message when restore to defaults fails
  ///
  /// In en, this message translates to:
  /// **'Failed to restore defaults: {error}'**
  String dataRestoreDefaultsErrorMessage(String error);

  /// No description provided for @dataConfirmRestoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Restore'**
  String get dataConfirmRestoreTitle;

  /// No description provided for @dataConfirmRestoreMessage.
  ///
  /// In en, this message translates to:
  /// **'This will replace all your current data with the backup data. This action cannot be undone.\n\nAre you sure you want to continue?'**
  String get dataConfirmRestoreMessage;

  /// No description provided for @dataRestoreSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Backup restored successfully'**
  String get dataRestoreSuccessMessage;

  /// No description provided for @dataRestoreDefaultsButton.
  ///
  /// In en, this message translates to:
  /// **'Restore Defaults'**
  String get dataRestoreDefaultsButton;

  /// No description provided for @dataRestoreButton.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get dataRestoreButton;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'it',
    'pt',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
