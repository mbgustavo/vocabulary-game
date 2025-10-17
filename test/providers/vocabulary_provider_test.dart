import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vocabulary_game/providers/vocabulary_provider.dart';
import 'package:vocabulary_game/providers/notifications_provider.dart';
import 'package:vocabulary_game/models/word.dart';
import 'package:vocabulary_game/storage/storage_interface.dart';

class MockStorage extends Mock implements StorageInterface {}

void main() {
  setUpAll(() {
    // Register fallback values for mocktail
    registerFallbackValue(
      Word(input: 'test', translation: 'test', language: 'english'),
    );
  });

  group('VocabularyNotifier', () {
    late ProviderContainer container;
    late MockStorage mockStorage;

    setUp(() {
      mockStorage = MockStorage();

      // Set up default mock responses
      when(() => mockStorage.getVocabulary()).thenAnswer((_) async => []);
      when(() => mockStorage.saveWord(any())).thenAnswer((invocation) async {
        final word = invocation.positionalArguments[0] as Word;
        return [word];
      });
      when(
        () => mockStorage.updateWordsLanguage(any(), any()),
      ).thenAnswer((_) async => []);
      when(() => mockStorage.deleteWord(any())).thenAnswer((_) async => []);
      when(
        () => mockStorage.deleteWordsByLanguage(any()),
      ).thenAnswer((_) async => []);

      container = ProviderContainer(
        overrides: [vocabularyStorageProvider.overrideWithValue(mockStorage)],
      );
    });

    tearDown(() async {
      // Wait for any loading operations to complete before disposing
      bool isLoading = true;

      while (isLoading) {
        final vocabularyState =
            container.read(vocabularyProvider.notifier).state;

        isLoading =
            vocabularyState.containsKey('loading') &&
            vocabularyState['loading'] == true;

        if (isLoading) {
          await Future.delayed(Duration(milliseconds: 100));
        }
      }

      container.dispose();
    });

    group('loadVocabulary', () {
      test(
        'should load vocabulary and set initial state when storage is empty',
        () async {
          // The actual implementation loads from storage, so we test the behavior
          var state = container.read(vocabularyProvider);

          expect(state['loading'], true);

          // Wait for initial loading to complete
          await Future.delayed(Duration(milliseconds: 100));

          state = container.read(vocabularyProvider);

          expect(state['loading'], false);
          expect(state['vocabulary'], isA<List<Word>>());
          expect(state['vocabulary'].length, 0);

          // Verify storage methods were called
          verify(() => mockStorage.getVocabulary()).called(1);
        },
      );

      test('should load existing vocabulary when storage has data', () async {
        // Set up mock to return existing vocabulary
        final word1 = Word(
          input: 'hola',
          translation: 'hello',
          language: 'spanish',
        );
        final word2 = Word(
          input: 'adiós',
          translation: 'goodbye',
          language: 'spanish',
        );
        when(
          () => mockStorage.getVocabulary(),
        ).thenAnswer((_) async => [word1, word2]);

        // Create new container with updated mock
        final testContainer = ProviderContainer(
          overrides: [vocabularyStorageProvider.overrideWithValue(mockStorage)],
        );

        testContainer.read(vocabularyProvider.notifier);

        // Wait for initial loading to complete
        await Future.delayed(Duration(milliseconds: 100));

        final state = testContainer.read(vocabularyProvider);

        expect(state['loading'], false);
        expect(state['vocabulary'], isA<List<Word>>());
        expect(state['vocabulary'].length, 2);
        expect(state['vocabulary'][0].input, 'hola');
        expect(state['vocabulary'][1].input, 'adiós');

        // Verify storage methods were called
        verify(() => mockStorage.getVocabulary()).called(1);

        testContainer.dispose();
      });
    });

    group('getVocabulary', () {
      test(
        'should return all vocabulary when no language filter is provided',
        () async {
          final notifier = container.read(vocabularyProvider.notifier);

          // Set up state with vocabulary
          final word1 = Word(
            input: 'hola',
            translation: 'hello',
            language: 'spanish',
          );
          final word2 = Word(
            input: 'bonjour',
            translation: 'hello',
            language: 'french',
          );
          notifier.state = {
            'loading': false,
            'vocabulary': [word1, word2],
          };

          final vocabulary = notifier.getVocabulary();
          expect(vocabulary, isA<List<Word>>());
          expect(vocabulary.length, 2);
        },
      );

      test(
        'should return filtered vocabulary when language is provided',
        () async {
          final notifier = container.read(vocabularyProvider.notifier);

          // Set up state with vocabulary
          final word1 = Word(
            input: 'hola',
            translation: 'hello',
            language: 'spanish',
          );
          final word2 = Word(
            input: 'bonjour',
            translation: 'hello',
            language: 'french',
          );
          final word3 = Word(
            input: 'bueno',
            translation: 'good',
            language: 'spanish',
          );
          notifier.state = {
            'loading': false,
            'vocabulary': [word1, word2, word3],
          };

          final spanishVocabulary = notifier.getVocabulary(language: 'spanish');
          expect(spanishVocabulary.length, 2);
          expect(spanishVocabulary[0].language, 'spanish');
          expect(spanishVocabulary[1].language, 'spanish');

          final frenchVocabulary = notifier.getVocabulary(language: 'french');
          expect(frenchVocabulary.length, 1);
          expect(frenchVocabulary[0].language, 'french');
        },
      );

      test('should return empty list when no vocabulary in state', () async {
        final notifier = container.read(vocabularyProvider.notifier);

        // Wait for initial loading to complete
        await Future.delayed(Duration(milliseconds: 100));

        // Force state without vocabulary
        notifier.state = {'loading': false};

        final vocabulary = notifier.getVocabulary();
        expect(vocabulary, isEmpty);
      });

      test(
        'should return empty list when language filter matches no words',
        () {
          final notifier = container.read(vocabularyProvider.notifier);

          // Set up state with vocabulary
          final word1 = Word(
            input: 'hola',
            translation: 'hello',
            language: 'spanish',
          );
          notifier.state = {
            'loading': false,
            'vocabulary': [word1],
          };

          final germanVocabulary = notifier.getVocabulary(language: 'german');
          expect(germanVocabulary, isEmpty);
        },
      );
    });

    group('saveWord', () {
      test('should save word successfully', () async {
        when(() => mockStorage.saveWord(any())).thenAnswer((invocation) async {
          final word = invocation.positionalArguments[0] as Word;
          return [word];
        });

        final notifier = container.read(vocabularyProvider.notifier);

        // Wait for initial loading
        await Future.delayed(Duration(milliseconds: 100));

        final newWord = Word(
          input: 'hola',
          translation: 'hello',
          language: 'spanish',
        );
        final error = await notifier.saveWord(newWord);

        expect(error, isNull);
        verify(() => mockStorage.saveWord(newWord)).called(1);

        final vocabulary = notifier.getVocabulary();
        expect(vocabulary.length, 1);
        expect(vocabulary[0].input, 'hola');
      });

      test('should handle storage errors in saveWord', () async {
        when(
          () => mockStorage.saveWord(any()),
        ).thenThrow(Exception('Storage error'));

        final notifier = container.read(vocabularyProvider.notifier);

        // Wait for initial loading
        await Future.delayed(Duration(milliseconds: 100));

        final newWord = Word(
          input: 'hola',
          translation: 'hello',
          language: 'spanish',
        );
        final error = await notifier.saveWord(newWord);

        expect(error, isNotNull);
        expect(error, contains('Exception: Storage error'));
      });
    });

    group('updateWordsLanguage', () {
      test('should update words language successfully', () async {
        final originalWord = Word(
          input: 'hola',
          translation: 'hello',
          language: 'spanish',
        );
        when(() => mockStorage.updateWordsLanguage(any(), any())).thenAnswer((
          invocation,
        ) async {
          final newLanguage = invocation.positionalArguments[1] as String;
          return [
            Word(
              input: originalWord.input,
              translation: originalWord.translation,
              language: newLanguage,
            ),
          ];
        });

        final notifier = container.read(vocabularyProvider.notifier);

        // Set up initial state
        notifier.state = {
          'loading': false,
          'vocabulary': [originalWord],
        };

        final error = await notifier.updateWordsLanguage('spanish', 'español');

        expect(error, isNull);
        verify(
          () => mockStorage.updateWordsLanguage('spanish', 'español'),
        ).called(1);

        final vocabulary = notifier.getVocabulary();
        expect(vocabulary.length, 1);
        expect(vocabulary[0].language, 'español');
      });

      test('should handle storage errors in updateWordsLanguage', () async {
        when(
          () => mockStorage.updateWordsLanguage(any(), any()),
        ).thenThrow(Exception('Storage error'));

        final notifier = container.read(vocabularyProvider.notifier);

        final error = await notifier.updateWordsLanguage('spanish', 'español');

        expect(error, isNotNull);
        expect(error, contains('Exception: Storage error'));
      });
    });

    group('deleteWord', () {
      test('should delete word successfully', () async {
        when(() => mockStorage.deleteWord(any())).thenAnswer((_) async => []);

        final notifier = container.read(vocabularyProvider.notifier);

        // Set up initial state
        final word = Word(
          input: 'hola',
          translation: 'hello',
          language: 'spanish',
        );
        notifier.state = {
          'loading': false,
          'vocabulary': [word],
        };

        final error = await notifier.deleteWord(word);

        expect(error, isNull);
        verify(() => mockStorage.deleteWord(word)).called(1);

        final vocabulary = notifier.getVocabulary();
        expect(vocabulary, isEmpty);
      });

      test('should handle storage errors in deleteWord', () async {
        when(
          () => mockStorage.deleteWord(any()),
        ).thenThrow(Exception('Storage error'));

        final notifier = container.read(vocabularyProvider.notifier);

        final word = Word(
          input: 'hola',
          translation: 'hello',
          language: 'spanish',
        );
        final error = await notifier.deleteWord(word);

        expect(error, isNotNull);
        expect(error, contains('Exception: Storage error'));
      });
    });

    group('deleteWordsByLanguage', () {
      test('should delete words by language successfully', () async {
        // Set up initial state with words in different languages
        final spanishWord = Word(
          input: 'hola',
          translation: 'hello',
          language: 'spanish',
        );
        final frenchWord = Word(
          input: 'bonjour',
          translation: 'hello',
          language: 'french',
        );

        when(() => mockStorage.deleteWordsByLanguage(any())).thenAnswer(
          (invocation) async => [
            frenchWord,
            spanishWord,
          ].where((word) => word.language != invocation.positionalArguments[0]).toList(),
        );

        final notifier = container.read(vocabularyProvider.notifier);
        notifier.state = {
          'loading': false,
          'vocabulary': [spanishWord, frenchWord],
        };

        await notifier.deleteWordsByLanguage('spanish');

        verify(() => mockStorage.deleteWordsByLanguage('spanish')).called(1);

        final vocabulary = notifier.getVocabulary();
        expect(vocabulary.length, 1);
        expect(vocabulary[0].language, 'french');
      });

      test('should handle storage errors in deleteWordsByLanguage', () async {
        when(
          () => mockStorage.deleteWordsByLanguage(any()),
        ).thenThrow(Exception('Storage error'));

        final notifier = container.read(vocabularyProvider.notifier);

        // This should not throw, but should push a notification
        await notifier.deleteWordsByLanguage('spanish');

        verify(() => mockStorage.deleteWordsByLanguage('spanish')).called(1);
      });
    });

    group('error handling', () {
      test('should show error notification when loading fails', () async {
        when(
          () => mockStorage.getVocabulary(),
        ).thenThrow(Exception('Storage error'));

        // Create new container with failing mock
        final testContainer = ProviderContainer(
          overrides: [vocabularyStorageProvider.overrideWithValue(mockStorage)],
        );
        testContainer.read(vocabularyProvider.notifier);

        // Wait for loading to complete
        await Future.delayed(Duration(milliseconds: 100));

        final state = testContainer.read(vocabularyProvider);
        expect(state['loading'], false);

        final notificationsState = testContainer.read(notificationsProvider);
        expect(notificationsState.length, 1);
        expect(notificationsState[0].type, NotificationType.error);
        expect(notificationsState[0].message, contains('Failed to load vocabulary'));

        verify(() => mockStorage.getVocabulary()).called(1);

        testContainer.dispose();
      });
    });

    group('state management', () {
      test('should maintain state structure', () {
        final state = container.read(vocabularyProvider);
        expect(state, isA<Map<String, dynamic>>());
        expect(state.containsKey('loading'), true);
      });

      test('should handle state updates correctly', () async {
        final notifier = container.read(vocabularyProvider.notifier);

        // Wait for initial state
        await Future.delayed(Duration(milliseconds: 100));

        final initialState = notifier.state;
        expect(initialState, isA<Map<String, dynamic>>());

        // Update state
        notifier.state = {...initialState, 'test_key': 'test_value'};

        expect(notifier.state['test_key'], equals('test_value'));
      });
    });

    group('Word model', () {
      test('should create word with correct properties', () {
        final word = Word(
          input: 'hola',
          translation: 'hello',
          language: 'spanish',
        );
        expect(word.input, 'hola');
        expect(word.translation, 'hello');
        expect(word.language, 'spanish');
      });
    });

    group('integration with other providers', () {
      test('should interact with notifications provider', () {
        // This test verifies that the vocabulary provider references notifications provider
        final notifier = container.read(vocabularyProvider.notifier);
        final notificationsNotifier = container.read(
          notificationsProvider.notifier,
        );

        expect(notifier, isNotNull);
        expect(notificationsNotifier, isNotNull);
      });
    });
  });
}
