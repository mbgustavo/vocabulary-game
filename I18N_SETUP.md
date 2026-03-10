# Internationalization (i18n) Setup Guide

## Overview

Your Vocabulary Game app now has full internationalization support! The app currently supports 5 languages:

- **English** (en)
- **Spanish** (es)
- **French** (fr)
- **German** (de)
- **Italian** (it)

## Project Structure

### Key Files
- **[l10n.yaml](l10n.yaml)** - Configuration file for localization generation
- **[lib/l10n/](lib/l10n/)** - Directory containing translation files
  - `app_en.arb` - English translations (template)
  - `app_es.arb` - Spanish translations
  - `app_fr.arb` - French translations
  - `app_de.arb` - German translations
  - `app_it.arb` - Italian translations
  - `app_localizations.dart` - Generated localization class (auto-generated)
  - `app_localizations_*.dart` - Language-specific localization files (auto-generated)

### Modified Files
- **[pubspec.yaml](pubspec.yaml)** - Added localization dependencies
- **[lib/main.dart](lib/main.dart)** - Configured Material app with localization support
- **[lib/screens/home.dart](lib/screens/home.dart)** - Updated with localized strings
- **[lib/screens/language.dart](lib/screens/language.dart)** - Updated with localized strings
- **[lib/screens/vocabulary.dart](lib/screens/vocabulary.dart)** - Updated with localized strings
- **[lib/screens/game_select.dart](lib/screens/game_select.dart)** - Updated with localized strings
- **[lib/screens/game.dart](lib/screens/game.dart)** - Updated with localized strings
- **[lib/screens/data.dart](lib/screens/data.dart)** - Updated with localized strings
- **[lib/screens/new_word.dart](lib/screens/new_word.dart)** - Updated with localized strings

## How It Works

### 1. ARB (App Resource Bundle) Format

Translations are stored in `.arb` files (JSON format):
- `app_en.arb` is the **template** containing all translation keys
- Other `.arb` files (`app_es.arb`, `app_fr.arb`, etc.) contain translations for each language
- Each key must exist in all language files

Example from `app_en.arb`:
```json
{
  "@@locale": "en",
  "appTitle": "Vocabulary Game",
  "homeWelcome": "Welcome to Vocabulary Game!",
  "homeYouAreLearning": "You are learning {language}",
  "@homeYouAreLearning": {
    "description": "Text showing what language the user is learning",
    "placeholders": {
      "language": {
        "type": "String",
        "example": "Spanish"
      }
    }
  }
}
```

### 2. Generated Code

When you run `flutter gen-l10n` or `flutter pub get`, Flutter generates:
- `lib/l10n/app_localizations.dart` - Main localization class
- `lib/l10n/app_localizations_en.dart` - English implementation
- `lib/l10n/app_localizations_es.dart` - Spanish implementation
- ... (one for each language)

These files are **auto-generated** and should NOT be manually edited.

### 3. Using Translations in Code

#### Accessing the localization object:
```dart
final l10n = AppLocalizations.of(context)!;
```

#### Using a simple string:
```dart
Text(l10n.appTitle)  // Returns "Vocabulary Game"
```

#### Using a string with parameters:
```dart
Text(l10n.homeYouAreLearning('Spanish'))  // Returns "You are learning Spanish"
```

#### In a Scaffold AppBar:
```dart
AppBar(
  title: Text(AppLocalizations.of(context)!.appTitle),
)
```

## Adding New Languages

To add a new language (e.g., Portuguese - `pt`):

### Step 1: Create the translation file
Create `/lib/l10n/app_pt.arb` with all keys from `app_en.arb`:
```json
{
  "@@locale": "pt",
  "appTitle": "Jogo de Vocabulário",
  "homeWelcome": "Bem-vindo ao Jogo de Vocabulário!",
  // ... all other keys with Portuguese translations
}
```

### Step 2: Update l10n.yaml (optional)
If you want to specify supported locales explicitly, add to `l10n.yaml`:
```yaml
supported-locales:
  - en
  - es
  - fr
  - de
  - it
  - pt
```

### Step 3: Regenerate localization files
```bash
flutter gen-l10n
```

### Step 4: Update main.dart to include the new locale
```dart
supportedLocales: const [
  Locale('en'),
  Locale('es'),
  Locale('fr'),
  Locale('de'),
  Locale('it'),
  Locale('pt'),  // Add this
],
```

## Adding New Strings

When you need to add a new UI string:

### Step 1: Add to English template (`app_en.arb`)
```json
{
  "newFeatureTitle": "My New Feature",
  "@newFeatureTitle": {
    "description": "Title for the new feature"
  }
}
```

### Step 2: Add to all language files
Add the same key to `app_es.arb`, `app_fr.arb`, `app_de.arb`, `app_it.arb`:
```json
{
  "newFeatureTitle": "Mi Nueva Función"  // In Spanish
}
```

### Step 3: Regenerate
```bash
flutter gen-l10n
```

### Step 4: Use in code
```dart
Text(AppLocalizations.of(context)!.newFeatureTitle)
```

## Translation Keys Reference

All available translation keys are organized by screen/feature:

- **App-level**: `appTitle`, `appLoading`
- **Home**: `homeWelcome`, `homeYouAreLearning`, `homeStartGame`, `homeVocabularyTooSmall`, `homeLanguages`, `homeVocabulary`
- **Languages**: `languagesTitle`, `languagesAdd`, `languagesSelect`, `languagesCurrent`
- **Vocabulary**: `vocabularyTitle`, `vocabularyAddWord`, `vocabularyNoWords`, `vocabularyDeleteConfirm`, `vocabularyDelete`, `vocabularyCancel`
- **Games**: `gameSelectTitle`, `gameFlashcards`, `gameMultipleChoice`, `gameTyping`, `gamePlayButton`, `gameBack`, `gameScore`, `gameCompleted`, `gameFinalScore`
- **Data Management**: `dataTitle`, `dataExport`, `dataImport`, `dataClear`, `dataClearConfirm`
- **New Word**: `newWordTitle`, `newWordWord`, `newWordTranslation`, `newWordExample`, `newWordSave`
- **Error/Success**: `errorTitle`, `errorLoadingData`, `errorSavingData`, `successTitle`, `successWordAdded`

## Current Locale Selection

Currently, the app defaults to English (`Locale('en')`). To implement dynamic language switching:

1. Create a locale provider using `flutter_riverpod`:
```dart
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en'));

  void setLocale(Locale locale) {
    state = locale;
  }
}
```

2. Update `main.dart` to use the provider:
```dart
locale: ref.watch(localeProvider),
```

3. Add a language selector to your settings/languages screen.

## Building and Testing

### Regenerate localizations (do this after modifying any .arb files)
```bash
flutter gen-l10n
```

### Build for all platforms
```bash
flutter pub get
flutter build apk    # Android
flutter build ios    # iOS
flutter build web    # Web (if configured)
flutter build windows
flutter build linux
flutter build macos
```

### Test a specific locale
```bash
flutter run --dart-define=APP_LOCALE=es
```

## Translation Guidelines

When translating strings:

1. **Consistency**: Use the same terminology throughout your translations
2. **Context**: Provide descriptions in the `@key` metadata to help translators understand context
3. **Parameters**: Use placeholders `{paramName}` for dynamic content
4. **Length**: Keep translations reasonably close to original length (UI layout might break with very long strings)
5. **Cultural Sensitivity**: Consider cultural differences when translating UI text

## Dependencies Added

- **flutter_localizations**: Provides localization support for Material/Cupertino widgets
- **intl**: Provides internationalization utilities (version ^0.20.0)

## Troubleshooting

### Generated files not found
- Run `flutter clean`
- Run `flutter pub get`
- Run `flutter gen-l10n`

### Locale object not found
- Ensure `flutter_localizations` is in `pubspec.yaml`
- Ensure `flutter: generate: true` is set in `pubspec.yaml`
- Run `flutter pub get` again

### Text not translating
- Check that the key exists in all `.arb` files
- Verify the correct import: `import 'package:flutter_gen/gen_l10n/app_localizations.dart';`
- Use `AppLocalizations.of(context)!.keyName` pattern

## Next Steps

1. **Implement Dynamic Language Switching**: Allow users to change the app language from settings
2. **Add More Languages**: Follow the guide above to support additional languages
3. **Translation Review**: Have native speakers review translations for accuracy
4. **Continuous Integration**: Set up automated checks to ensure all keys exist in all language files
5. **Community Translations**: Consider using platforms like Crowdin for community translations
