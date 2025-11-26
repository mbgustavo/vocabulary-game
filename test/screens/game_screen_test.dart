import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocabulary_game/games/connection_game.dart';
import 'package:vocabulary_game/games/multiple_choice_game.dart';
import 'package:vocabulary_game/games/write_game.dart';
import 'package:vocabulary_game/models/word.dart';
import 'package:vocabulary_game/models/language.dart';
import 'package:vocabulary_game/providers/settings_provider.dart';
import 'package:vocabulary_game/providers/vocabulary_provider.dart';
import 'package:vocabulary_game/screens/game.dart';
import 'package:vocabulary_game/widgets/game_completed.dart';

void main() {
  group('GameScreen Widget Tests', () {
    // Mock data for testing
    final testLanguage = Language('Spanish', '🇪🇸');
    final mockWords = [
      Word(language: testLanguage.value, input: 'Hello', translation: 'Hola'),
      Word(language: testLanguage.value, input: 'World', translation: 'Mundo'),
      Word(language: testLanguage.value, input: 'Cat', translation: 'Gato'),
      Word(language: testLanguage.value, input: 'Dog', translation: 'Perro'),
      Word(language: testLanguage.value, input: 'House', translation: 'Casa'),
    ];

    Widget createTestWidget(Game game, {int? wordsQty}) {
      return ProviderScope(
        overrides: [
          settingsProvider.overrideWith(
            (ref) => MockSettingsNotifier(ref, testLanguage),
          ),
          vocabularyProvider.overrideWith(
            (ref) => MockVocabularyNotifier(ref, mockWords),
          ),
        ],
        child: MaterialApp(
          home: GameScreen(game: game, wordsQty: wordsQty ?? defaultQty),
        ),
      );
    }

    Future<void> completeConnectionGame(WidgetTester tester) async {
      for (final word in mockWords) {
        await tester.tap(find.text(word.input).first);
        await tester.pumpAndSettle();
        await tester.tap(find.text(word.translation).first);
        await tester.pumpAndSettle();
      }
    }

    testWidgets('GameScreen handles different game types correctly', (
      WidgetTester tester,
    ) async {
      // Test each game type
      final gameTests = {
        Game.connection: ConnectionGame,
        Game.multipleChoice: MultipleChoiceGame,
        Game.multipleChoiceReversed: MultipleChoiceGame,
        Game.write: WriteGame,
        Game.writeReversed: WriteGame,
      };
      final gameTestsTitle = {
        Game.connection: 'Connection Game',
        Game.multipleChoice: 'Multiple Choice Game',
        Game.multipleChoiceReversed: 'Multiple Choice Game',
        Game.write: 'Write Game',
        Game.writeReversed: 'Write Game',
      };

      for (final entry in gameTests.entries) {
        await tester.pumpWidget(createTestWidget(entry.key));
        await tester.pumpAndSettle();

        expect(find.byType(GameScreen), findsOneWidget);
        expect(find.byType(entry.value), findsOneWidget);
        expect(find.text(gameTestsTitle[entry.key]!), findsOneWidget);
      }
    });

    testWidgets('Game can be reset after completed', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget(Game.connection));
      await tester.pumpAndSettle();

      await completeConnectionGame(tester);

      expect(find.byType(GameCompleted), findsOneWidget);

      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Play again'));
      await tester.pumpAndSettle();

      expect(find.byType(GameCompleted), findsNothing);
      expect(find.byType(GameScreen), findsOneWidget);
      expect(find.byType(ConnectionGame), findsOneWidget);
    });
  });
}

// Mock classes for testing
class MockSettingsNotifier extends SettingsNotifier {
  final Language _testLanguage;

  MockSettingsNotifier(super.ref, this._testLanguage);

  @override
  Language getLearningLanguage() {
    return _testLanguage;
  }

  @override
  List<Language> getLanguages() {
    return [_testLanguage];
  }
}

class MockVocabularyNotifier extends VocabularyNotifier {
  final List<Word> _mockWords;

  MockVocabularyNotifier(super.ref, this._mockWords);

  @override
  List<Word> getVocabulary({String? language}) {
    return _mockWords;
  }
}
