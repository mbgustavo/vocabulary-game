# Vocabulary Game - Architecture Overview

## Project Description

Vocabulary Game is a Flutter mobile application designed to help users learn and practice vocabulary in multiple languages. The app features interactive game modes, personalized vocabulary management, and daily word notifications to enhance language learning.

**Key Technologies:**
- **Framework:** Flutter (Dart)
- **State Management:** Flutter Riverpod 2.6.1
- **Persistent Storage:** Shared Preferences
- **Localization:** Intl package (i18n support)
- **Notifications:** Flutter Local Notifications

**Supported Languages:** English, Spanish, French, German, Italian, Portuguese

---

## Project Structure

```
vocabulary-game/
├── lib/                          # Main application source code
├── test/                         # Unit and widget tests
├── integration_test/             # Integration and end-to-end tests
├── test_driver/                  # Test driver for integration testing
├── .github/                      # CI/CD workflows and GitHub Actions
└── docs/                         # Project documentation
```

---

## Core Architecture Layers

### 1. **Presentation Layer** (`lib/screens/` & `lib/widgets/`)
Handles all UI components and user interactions.

**Screens:** Complete pages shown in the application
- `home.dart` - Main dashboard/entry point
- `game.dart` - Game play screen
- `game_select.dart` - Game mode selection
- `vocabulary.dart` - Vocabulary list/management
- `language.dart` - Language settings and management
- `new_word.dart` - Add new word form
- `data.dart` - Backup save/restore and reset defaults
- `word_of_the_moment.dart` - Periodical (daily or hourly) word feature

**Widgets:** Reusable UI components
- `word_card.dart` - Display individual words
- `word_list.dart` - List of words with scrolling
- `word_item.dart` - Single word list item
- `game_completed.dart` - Game completion screen
- `language_dropdown.dart` - Language selection dropdown
- `language_item.dart` - Language list item
- `language_list.dart` - List of available languages
- `flag_selector.dart` - Country flag selector
- `multiple_choice_question.dart` - Multiple choice questoin widget
- `new_language.dart` - Add language form
- `highlighted_text.dart` - Text highlighted, currently used for selected language
- `notification_banners.dart` - Toast/banner notifications
- `word_of_the_moment/` - Widgets for periodical word feature

### 2. **State Management Layer** (`lib/providers/`)
Implements application state using Riverpod for reactive state management.

**Providers:**
- `languages_provider.dart` - Manages available languages, selection state and CRUD operations
- `vocabulary_provider.dart` - Manages words database and CRUD operations
- `settings_provider.dart` - User preferences and app configuration
- `notifications_provider.dart` - Notification state management
- `word_of_the_moment_notification_service_provider.dart` - Periodical word notification service

### 3. **Domain Layer** (`lib/models/`)
Defines core business entities and logic.

**Models:**
- `word.dart` - Word entity with metadata (id, language, level, status, examples)
  - `Word` - Base word class
  - `WordInGame` - Extended word with game-specific status tracking
  - `WordLevel` - Enum: beginner, intermediate, advanced
  - `WordStatus` - Enum: notSelected, selected, completed, error, disabled

- `language.dart` - Language entity with metadata
- `settings.dart` - User settings configuration

### 4. **Data/Storage Layer** (`lib/storage/`)
Abstracts persistent storage operations using the Repository/Interface pattern.

**Components:**
- `storage_interface.dart` - Abstract interface defining storage contracts
- `pref_storage.dart` - Concrete implementation using Shared Preferences

**Responsibilities:**
- Language CRUD operations
- Word vocabulary management
- User preferences persistence

### 5. **Business Logic Layer** (`lib/games/`)
Encapsulates game-specific rules and mechanics.

**Game Modes:**
- `connection_game.dart` - Match words with translations
- `multiple_choice_game.dart` - Select correct translation from options
- `write_game.dart` - Type the translation for given words

### 6. **Utilities Layer** (`lib/utils/`)
Shared utility functions and helpers.

**Utilities:**
- `platform_info.dart` - Platform detection and capabilities
- `words.dart` - Word processing and filtering utilities

### 7. **Localization Layer** (`lib/l10n/`)
Multi-language UI text and translations.
- Generated localization files for supported languages
- Delegate system for switching locales at runtime

---

## Data Flow Architecture

```
┌─────────────────────────────────────────────┐
│         User Interaction (Screens)          │
└────────────────────┬────────────────────────┘
                     │
┌────────────────────▼────────────────────────┐
│     State Management (Riverpod Providers)   │
│  - Handles reactive state updates           │
│  - Notifies listeners of changes            │
└────────────────────┬────────────────────────┘
                     │
┌────────────────────▼────────────────────────┐
│     Storage Interface (Abstract Pattern)    │
│  - Defines contract for data operations     │
└────────────────────┬────────────────────────┘
                     │
┌────────────────────▼────────────────────────┐
│     Persistent Storage (Shared Prefs)       │
│  - Device local storage                     │
└─────────────────────────────────────────────┘
```

---

## Application Initialization

**Entry Point:** `main.dart`

1. **App Root:** `ProviderScope` wraps entire app for Riverpod support
2. **Locale Setup:** Listens to `languagesProvider` to set app language
3. **Provider Initialization:** Core providers initialize on first access:
   - Languages are loaded from storage
   - Vocabulary/words are loaded from storage
   - Settings and preferences are restored
4. **Notification Service:** Word-of-the-moment notification service initializes at app startup
5. **Loading State:** Global loading state displayed while initializing core data

---

## State Management with Riverpod

### State Initialization
- Providers lazily initialize on first access
- Loading states prevent race conditions
- Storage fallback handles missing data gracefully

---

## Testing Strategy

For comprehensive testing details, see [TESTING.md](TESTING.md).

The project includes unit tests, widget tests, and integration tests organized in the `test/` and `integration_test/` directories.

---

## CI/CD Pipeline (`.github/workflows/`)

### Workflows

**1. ci.yml** - Continuous Integration
- Triggered on: Pull requests, commits to main
- Run on Ubuntu container, no iOS builds
- Tasks:
  - Lint code analysis (`dart analyze`)
  - Run unit tests
  - Run integration tests
  - Build artifacts (APK and App Bundle) 

**2. release.yml** - Release Management
- Triggered manually
- Run on MacOS machine
- Tasks:
  - Create GitHub releases
  - Build articats (APK, IPA and App Bundle)
  - Create tag release on GitHub with version extracted from pubspec.yaml

---

## Key Design Patterns

### 1. **Repository Pattern** (`storage/storage_interface.dart`)
Abstract interface for data access, allowing easy swapping of storage implementations. This pattern is used due to future plans to use a remote database.

### 2. **Provider Pattern** (Riverpod)
Injects dependencies and manages state reactively.

### 3. **Enum-Based State**
`WordLevel` and `WordStatus` enums define discrete states, preventing invalid state combinations.

---

## Features & Capabilities

### Core Features
1. **Vocabulary Management**
   - Add custom words in any language
   - Edit and delete entries
   - Categorize by difficulty level

2. **Multiple Languages**
   - Support for multiple app languages
   - Quick language switching
   - Localized UI

3. **Interactive Games**
   - Connection: Match words to translations
   - Multiple Choice: Select correct answer
   - Writing: Type translations from memory

4. **Periodical Word Notifications**
   - Scheduled queue of notifications for word-of-the-moment
   - Timezone-aware scheduling
   - Persistent notification settings

### Non-Functional Features
- **Offline-First:** All data persisted locally, subject to change
- **Platforms:** Focus on Android functionality, functional with Linux although it may be uncompatible with some functionalities like notifications and emojis, attempt to keep compatible with iOS (there are no available tools to validate iOS funcionality).
- **Accessible:** Supports multiple languages and locales

---

## Dependencies Overview

**Core Framework:**
- `flutter` - UI framework
- `flutter_riverpod` - State management
- `flutter_localizations` - Multi-language support

**Storage & Data:**
- `shared_preferences` - Local persistent storage

**Features:**
- `flutter_local_notifications` - Push notifications - use major version 21
- `flutter_timezone` - Timezone support
- `package_info_plus` - App metadata
- `file_picker` - File selection
- `emoji_picker_flutter` - Emoji support

**Development & Testing:**
- `mocktail` - Mocking for tests
- `flutter_test` - Testing framework

**UI & UX:**
- `cupertino_icons` - iOS icons
- `uuid` - Unique ID generation
- `intl` - Internationalization

---

## Development Guidelines

For detailed development guidelines, see [DEVELOPMENT_GUIDELINES.md](DEVELOPMENT_GUIDELINES.md).

This includes guidelines for adding features, state management best practices, storage extension, localization, GitHub workflows, versioning, and testing strategies.

---

## Future Considerations

- Change app name to MO Vocab
- Publish to play store
- Integration tests running on Android emulator, both locally and on CI
- Database migration from Shared Preferences to SQL or NoSQL
- Cloud synchronization for cross-device learning
- Lazy loading if vocabulary gets bigger
- AI-powered word adding with audio command support
- Import external databases to append vocabularies, not overwriting everything like current restore backup feature
- Offline sync when connectivity restored
- Android widget with word of the moment with option to refresh it manually or periodically

---

## Troubleshooting & Common Issues

### Provider Not Updating?
- Ensure using `ref.watch()` not `ref.read()` for reactive updates
- Check provider dependency chain for circular dependencies
- Use `debugPrintRiverpodLifecycle` for debugging

### Storage Not Persisting?
- Verify `StorageInterface` implementation is called
- Check Shared Preferences is initialized in `PrefStorage`
- Ensure async operations complete before app closes

For troubleshooting tests, see [TESTING.md](TESTING.md#troubleshooting-tests).

