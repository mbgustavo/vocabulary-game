import 'package:flutter_test/flutter_test.dart';
import 'package:vocabulary_game/models/language.dart';
import 'package:vocabulary_game/models/word.dart';
import 'package:vocabulary_game/utils/words.dart';

void main() {
  group('getWordsForGame', () {
    final beginnerWord1 = Word(
      language: 'english',
      input: 'cat',
      translation: 'gato',
      level: WordLevel.beginner,
    );
    final beginnerWord2 = Word(
      language: 'english',
      input: 'dog',
      translation: 'cachorro',
      level: WordLevel.beginner,
    );
    final intermediateWord1 = Word(
      language: 'english',
      input: 'elephant',
      translation: 'elefante',
      level: WordLevel.intermediate,
    );
    final advancedWord1 = Word(
      language: 'english',
      input: 'hippopotamus',
      translation: 'hipopótamo',
      level: WordLevel.advanced,
    );

    test('should return only beginners words when they are sufficient', () {
      final words = [beginnerWord1, beginnerWord2, intermediateWord1];
      final result = getWordsForGame(words, 2);

      expect(result.length, 2);
      expect(result.every((w) => w.level == WordLevel.beginner), true);
    });

    test(
      'should complete with intermediate words when there are not enough beginners',
      () {
        final words = [beginnerWord1, intermediateWord1, advancedWord1];
        final result = getWordsForGame(words, 2);

        expect(result.length, 2);
        expect(result.any((w) => w.level == WordLevel.intermediate), true);
      },
    );

    test(
      'should complete with advanced words when there are not enough beginners and intermediates',
      () {
        final words = [beginnerWord1, advancedWord1];
        final result = getWordsForGame(words, 2);

        expect(result.length, 2);
        expect(result.any((w) => w.level == WordLevel.advanced), true);
      },
    );

    test('should throw exception where there are not enough words', () {
      final words = [beginnerWord1];
      expect(
        () => getWordsForGame(words, 5),
        throwsA(
          allOf(isA<String>(), equals('Not enough words to play the game')),
        ),
      );
    });

    test('should shuffle the results', () {
      final words = [
        beginnerWord1,
        beginnerWord2,
        intermediateWord1,
        advancedWord1,
      ];

      final result1 = getWordsForGame(words, 3);
      final result2 = getWordsForGame(words, 3);

      // verify that the two results have the same elements, although possibly in different order
      expect(result1.length, 3);
      expect(result2.length, 3);
      expect(result1.toSet(), equals(result2.toSet()));
    });
  });

  group('getRandomWord', () {
    late Word beginnerWord;
    late Word intermediateWord;
    late Word advancedWord;

    setUp(() {
      beginnerWord = Word(
        language: 'english',
        input: 'cat',
        translation: 'gato',
        level: WordLevel.beginner,
      );
      intermediateWord = Word(
        language: 'english',
        input: 'elephant',
        translation: 'elefante',
        level: WordLevel.intermediate,
      );
      advancedWord = Word(
        language: 'english',
        input: 'hippopotamus',
        translation: 'hipopótamo',
        level: WordLevel.advanced,
      );
    });

    test('returns null when vocabulary is empty', () {
      final result = getRandomWord([]);
      expect(result, isNull);
    });

    test('returns null when no words match the language filter', () {
      final vocabulary = [beginnerWord, intermediateWord, advancedWord];

      final result = getRandomWord(
        vocabulary,
        language: Language('spanish', '🇪🇸'),
      );

      expect(result, isNull);
    });

    test('returns a word from the vocabulary when no filter is applied', () {
      final vocabulary = [beginnerWord, intermediateWord, advancedWord];

      final result = getRandomWord(vocabulary);

      expect(vocabulary.contains(result), isTrue);
    });

    test('filters by language correctly', () {
      final englishWord = beginnerWord;

      final spanishWord = Word(
        input: 'hola',
        translation: 'olá',
        language: 'spanish',
        level: WordLevel.beginner,
      );

      final vocabulary = [englishWord, spanishWord];

      final result = getRandomWord(
        vocabulary,
        language: Language('english', '🇬🇧'),
      );

      expect(result, equals(englishWord));
    });

    test('respects weights (probabilistic test)', () {
      final vocabulary = [beginnerWord, advancedWord];

      final weights = {WordLevel.beginner: 10, WordLevel.advanced: 1};

      int beginnerCount = 0;
      int advancedCount = 0;

      // Run multiple times to observe bias
      for (int i = 0; i < 1000; i++) {
        final result = getRandomWord(vocabulary, weights: weights);

        if (result == beginnerWord) beginnerCount++;
        if (result == advancedWord) advancedCount++;
      }

      expect(beginnerCount, greaterThan(advancedCount));
    });

    test('handles null weights (uniform distribution)', () {
      final vocabulary = [beginnerWord, advancedWord];

      int beginnerCount = 0;
      int advancedCount = 0;

      for (int i = 0; i < 1000; i++) {
        final result = getRandomWord(vocabulary, weights: null);

        if (result == beginnerWord) beginnerCount++;
        if (result == advancedWord) advancedCount++;
      }

      // Should be roughly similar (not strict equality)
      final ratio = beginnerCount / (advancedCount == 0 ? 1 : advancedCount);

      expect(ratio, inInclusiveRange(0.5, 2.0));
    });

    test('never select 0 weight word', () {
      final vocabulary = [beginnerWord, advancedWord];

      final weights = {WordLevel.beginner: 1, WordLevel.advanced: 0};

      // Run multiple times to observe bias
      for (int i = 0; i < 1000; i++) {
        final result = getRandomWord(vocabulary, weights: weights);

        expect(result, equals(beginnerWord));
      }
    });
  });
}
