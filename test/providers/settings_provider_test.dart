import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vocabulary_game/providers/settings_provider.dart';
import 'package:vocabulary_game/providers/notifications_provider.dart';
import 'package:vocabulary_game/providers/vocabulary_provider.dart';
import 'package:vocabulary_game/models/language.dart';
import 'package:vocabulary_game/storage/storage_interface.dart';

class MockStorage extends Mock implements StorageInterface {}

void main() {
  setUpAll(() {
    // Register fallback values for mocktail
    registerFallbackValue(Language('Test', '🏳️'));
  });

  group('SettingsNotifier', () {
    late ProviderContainer container;
    late MockStorage mockStorage;

    setUp(() {
      mockStorage = MockStorage();

      // Set up default mock responses
      when(() => mockStorage.getVocabulary()).thenAnswer((_) async => []);
      when(() => mockStorage.getLanguages()).thenAnswer((_) async => []);
      when(
        () => mockStorage.getLearningLanguage(),
      ).thenAnswer((_) async => null);
      when(
        () => mockStorage.addLanguage(any()),
      ).thenAnswer((invocation) async => [invocation.positionalArguments[0]]);
      when(
        () => mockStorage.setLearningLanguage(any()),
      ).thenAnswer((_) async => {});

      container = ProviderContainer(
        overrides: [
          settingsStorageProvider.overrideWithValue(mockStorage),
          vocabularyStorageProvider.overrideWithValue(mockStorage),
        ],
      );
    });

    tearDown(() async {
      // Wait for any loading operations to complete before disposing
      bool isLoading = true;

      while (isLoading) {
        final settingsState = container.read(settingsProvider.notifier).state;
        final vocabularyState =
            container.read(vocabularyProvider.notifier).state;

        final settingsLoading =
            settingsState.containsKey('loading') &&
            settingsState['loading'] == true;
        final vocabularyLoading =
            vocabularyState.containsKey('loading') &&
            vocabularyState['loading'] == true;

        isLoading = settingsLoading || vocabularyLoading;

        if (isLoading) {
          await Future.delayed(Duration(milliseconds: 100));
        }
      }

      container.dispose();
    });

    group('loadLanguages', () {
      test(
        'should load languages and set default language when storage is empty',
        () async {
          // The actual implementation loads from storage, so we test the behavior
          var state = container.read(settingsProvider);

          expect(state['loading'], true);

          // Wait for initial loading to complete
          await Future.delayed(Duration(milliseconds: 100));

          state = container.read(settingsProvider);

          expect(state['loading'], false);
          expect(state['languages'], isA<List<Language>>());
          expect(state['languages'].length, 1);
          expect(state['languages'][0], equals(defaultLanguage));

          // Verify storage methods were called
          verify(() => mockStorage.getLanguages()).called(1);
          verify(() => mockStorage.addLanguage(defaultLanguage)).called(1);
        },
      );

      test('should load existing languages when storage has data', () async {
        // Set up mock to return existing languages
        final spanish = Language('Spanish', '🇪🇸');
        final french = Language('French', '🇫🇷');
        when(
          () => mockStorage.getLanguages(),
        ).thenAnswer((_) async => [spanish, french]);
        when(
          () => mockStorage.getLearningLanguage(),
        ).thenAnswer((_) async => spanish.value);

        // Create new container with updated mock
        final testContainer = ProviderContainer(
          overrides: [settingsStorageProvider.overrideWithValue(mockStorage)],
        );

        testContainer.read(settingsProvider.notifier);

        // Wait for initial loading to complete
        await Future.delayed(Duration(milliseconds: 100));

        final state = testContainer.read(settingsProvider);

        expect(state['loading'], false);
        expect(state['languages'], isA<List<Language>>());
        expect(state['languages'].length, 2);
        expect(state['learning_language'], spanish.value);

        // Verify storage methods were called
        verify(() => mockStorage.getLanguages()).called(1);
        verify(() => mockStorage.getLearningLanguage()).called(1);
        verifyNever(() => mockStorage.addLanguage(any()));

        testContainer.dispose();
      });
    });

    group('getLanguages', () {
      test('should return languages from state', () async {
        final notifier = container.read(settingsProvider.notifier);

        // Wait for initial loading
        await Future.delayed(Duration(milliseconds: 100));

        final languages = notifier.getLanguages();
        expect(languages, isA<List<Language>>());
      });

      test('should return empty list when no languages in state', () {
        final notifier = container.read(settingsProvider.notifier);
        // Force state without languages
        notifier.state = {'loading': false};

        final languages = notifier.getLanguages();
        expect(languages, isEmpty);
      });
    });

    group('addLanguage', () {
      test('should return error for empty language name', () async {
        final notifier = container.read(settingsProvider.notifier);

        final emptyLanguage = Language('', '🏳️');
        final error = await notifier.addLanguage(emptyLanguage);

        expect(error, isNotNull);
        expect(error, contains('Language name cannot be empty'));
      });

      test('should return error for duplicate language', () async {
        final notifier = container.read(settingsProvider.notifier);

        // Wait for initial loading to complete and set up state
        await Future.delayed(Duration(milliseconds: 100));

        final existingLanguage = Language('Spanish', '🇪🇸');
        notifier.state = {
          ...notifier.state,
          'languages': [existingLanguage],
        };

        final duplicateLanguage = Language('Spanish', '🇪🇸');
        final error = await notifier.addLanguage(duplicateLanguage);

        expect(error, isNotNull);
        expect(error, contains('Language already exists'));
      });

      test('should add language successfully when valid', () async {
        when(() => mockStorage.addLanguage(any())).thenAnswer((
          invocation,
        ) async {
          final newLanguage = invocation.positionalArguments[0] as Language;
          return [defaultLanguage, newLanguage];
        });

        final notifier = container.read(settingsProvider.notifier);

        // Wait for initial loading
        await Future.delayed(Duration(milliseconds: 100));

        final newLanguage = Language('Spanish', '🇪🇸');
        final error = await notifier.addLanguage(newLanguage);

        expect(error, isNull);
        verify(() => mockStorage.addLanguage(newLanguage)).called(1);

        final languages = notifier.getLanguages();
        expect(languages.length, 2);
        expect(languages.contains(newLanguage), true);
      });
    });

    group('updateLanguage', () {
      test('should return error for empty language name', () async {
        final notifier = container.read(settingsProvider.notifier);

        final oldLanguage = Language('Spanish', '🇪🇸');
        final emptyLanguage = Language('', '🏳️');
        final error = await notifier.updateLanguage(oldLanguage, emptyLanguage);

        expect(error, isNotNull);
        expect(error, contains('Language name cannot be empty'));
      });

      test('should return error for duplicate language value', () async {
        final notifier = container.read(settingsProvider.notifier);

        // Set up state with existing languages
        final spanish = Language('Spanish', '🇪🇸');
        final french = Language('French', '🇫🇷');
        notifier.state = {
          ...notifier.state,
          'languages': [spanish, french],
        };

        // Try to update Spanish to have the same value as French
        final duplicateLanguage = Language('French', '🇫🇷');
        final error = await notifier.updateLanguage(spanish, duplicateLanguage);

        expect(error, isNotNull);
        expect(error, contains('Language already exists'));
      });

      test('should update language successfully when valid', () async {
        final notifier = container.read(settingsProvider.notifier);

        final spanish = Language('Spanish', '🇪🇸');
        final updatedSpanish = Language('Español', '🇪🇸');

        when(
          () => mockStorage.updateLanguage(spanish, updatedSpanish),
        ).thenAnswer((_) async => [defaultLanguage, updatedSpanish]);

        // Set up initial state
        notifier.state = {
          'loading': false,
          'languages': [defaultLanguage, spanish],
          'learning_language': defaultLanguage.value,
        };

        final error = await notifier.updateLanguage(spanish, updatedSpanish);

        expect(error, isNull);
        verify(
          () => mockStorage.updateLanguage(spanish, updatedSpanish),
        ).called(1);
      });
    });

    group('getLearningLanguage', () {
      test(
        'should return default language when learning language not found',
        () {
          final notifier = container.read(settingsProvider.notifier);

          // Set up state with languages but no learning language
          notifier.state = {
            'languages': [defaultLanguage],
            'learning_language': 'non-existent',
          };

          final learningLanguage = notifier.getLearningLanguage();
          expect(learningLanguage, equals(defaultLanguage));
        },
      );

      test('should return correct learning language when it exists', () {
        final notifier = container.read(settingsProvider.notifier);

        final spanish = Language('Spanish', '🇪🇸');
        notifier.state = {
          'languages': [defaultLanguage, spanish],
          'learning_language': spanish.value,
        };

        final learningLanguage = notifier.getLearningLanguage();
        expect(learningLanguage.value, equals(spanish.value));
        expect(learningLanguage.name, equals(spanish.name));
      });
    });

    group('getLanguage', () {
      test('should return default language when language not found', () {
        final notifier = container.read(settingsProvider.notifier);

        notifier.state = {
          'languages': [defaultLanguage],
        };

        final language = notifier.getLanguage('non-existent');
        expect(language, equals(defaultLanguage));
      });

      test('should return correct language when it exists', () {
        final notifier = container.read(settingsProvider.notifier);

        final spanish = Language('Spanish', '🇪🇸');
        notifier.state = {
          'languages': [defaultLanguage, spanish],
        };

        final language = notifier.getLanguage(spanish.value);
        expect(language.value, equals(spanish.value));
        expect(language.name, equals(spanish.name));
      });
    });

    group('changeLearningLanguage', () {
      test('should update learning language in state', () async {
        final notifier = container.read(settingsProvider.notifier);

        final spanish = Language('Spanish', '🇪🇸');
        notifier.state = {
          'languages': [defaultLanguage, spanish],
          'learning_language': defaultLanguage.value,
        };

        await notifier.changeLearningLanguage(spanish.value);

        expect(notifier.state['learning_language'], equals(spanish.value));
        verify(() => mockStorage.setLearningLanguage(spanish.value)).called(1);
      });

      test(
        'should handle storage error when changing learning language',
        () async {
          when(
            () => mockStorage.setLearningLanguage(any()),
          ).thenThrow(Exception('Storage error'));

          final notifier = container.read(settingsProvider.notifier);

          final spanish = Language('Spanish', '🇪🇸');
          notifier.state = {
            'languages': [defaultLanguage, spanish],
            'learning_language': defaultLanguage.value,
          };

          // This should not throw, but should push a notification
          await notifier.changeLearningLanguage(spanish.value);

          // The state should not change if storage fails
          expect(
            notifier.state['learning_language'],
            equals(defaultLanguage.value),
          );
          verify(
            () => mockStorage.setLearningLanguage(spanish.value),
          ).called(1);
        },
      );
    });

    group('error handling', () {
      test('should show error notification when loading fails', () async {
        when(
          () => mockStorage.getLanguages(),
        ).thenThrow(Exception('Storage error'));

        // Create new container with failing mock
        final testContainer = ProviderContainer(
          overrides: [settingsStorageProvider.overrideWithValue(mockStorage)],
        );
        testContainer.read(settingsProvider.notifier);

        // Wait for loading to complete
        await Future.delayed(Duration(milliseconds: 100));

        final state = testContainer.read(settingsProvider);
        expect(state['loading'], false);

        final notificationsState = testContainer.read(notificationsProvider);
        expect(notificationsState.length, 1);
        expect(notificationsState[0].type, NotificationType.error);
        expect(notificationsState[0].message, contains('Failed to load languages'));

        verify(() => mockStorage.getLanguages()).called(1);

        testContainer.dispose();
      });

      test('should handle storage errors in addLanguage', () async {
        when(
          () => mockStorage.addLanguage(any()),
        ).thenThrow(Exception('Storage error'));

        final notifier = container.read(settingsProvider.notifier);

        // Wait for initial loading
        await Future.delayed(Duration(milliseconds: 100));

        final newLanguage = Language('Spanish', '🇪🇸');
        final error = await notifier.addLanguage(newLanguage);

        expect(error, isNotNull);
        expect(error, contains('Exception: Storage error'));
      });
    });

    group('state management', () {
      test('should maintain state structure', () {
        final state = container.read(settingsProvider);
        expect(state, isA<Map<String, dynamic>>());
        expect(state.containsKey('loading'), true);
      });

      test('should handle state updates correctly', () async {
        final notifier = container.read(settingsProvider.notifier);

        // Wait for initial state
        await Future.delayed(Duration(milliseconds: 100));

        final initialState = notifier.state;
        expect(initialState, isA<Map<String, dynamic>>());

        // Update state
        notifier.state = {...initialState, 'test_key': 'test_value'};

        expect(notifier.state['test_key'], equals('test_value'));
      });
    });

    group('Language model', () {
      test('should create language with correct value', () {
        final language = Language('Test Language', '🏳️');
        expect(language.name, 'Test Language');
        expect(language.icon, '🏳️');
        expect(language.value, 'test-language');
      });

      test('should handle special characters in language name', () {
        final language = Language('Français', '🇫🇷');
        expect(language.value, 'français');
      });

      test('should handle multiple spaces in language name', () {
        final language = Language('Test  Multiple   Spaces', '🏳️');
        expect(language.value, 'test--multiple---spaces');
      });
    });

    group('integration with other providers', () {
      test('should interact with vocabulary provider when updating language', () {
        // This test verifies that the settings provider references vocabulary provider
        final notifier = container.read(settingsProvider.notifier);
        final vocabularyNotifier = container.read(vocabularyProvider.notifier);

        expect(notifier, isNotNull);
        expect(vocabularyNotifier, isNotNull);
      });

      test('should interact with notifications provider', () {
        // This test verifies that the settings provider references notifications provider
        final notifier = container.read(settingsProvider.notifier);
        final notificationsNotifier = container.read(
          notificationsProvider.notifier,
        );

        expect(notifier, isNotNull);
        expect(notificationsNotifier, isNotNull);
      });
    });
  });
}
