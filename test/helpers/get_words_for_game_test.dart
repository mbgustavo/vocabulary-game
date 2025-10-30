import 'package:flutter_test/flutter_test.dart';
import 'package:vocabulary_game/models/word.dart';
import 'package:vocabulary_game/games/get_words_for_game.dart';

void main() {
  group('getWordsForGame', () {
    final beginnerWord1 = Word(
      language: 'en',
      input: 'cat',
      translation: 'gato',
      level: WordLevel.beginner,
    );
    final beginnerWord2 = Word(
      language: 'en',
      input: 'dog',
      translation: 'cachorro',
      level: WordLevel.beginner,
    );
    final intermediateWord1 = Word(
      language: 'en',
      input: 'elephant',
      translation: 'elefante',
      level: WordLevel.intermediate,
    );
    final advancedWord1 = Word(
      language: 'en',
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
}
