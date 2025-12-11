import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:vocabulary_game/games/connection_game.dart';
import 'package:vocabulary_game/games/multiple_choice_game.dart';
import 'package:vocabulary_game/games/write_game.dart';
import 'package:vocabulary_game/main.dart' as app;
import 'package:vocabulary_game/models/word.dart';
import 'package:vocabulary_game/screens/game.dart';
import 'package:vocabulary_game/screens/game_select.dart';
import 'package:vocabulary_game/screens/home.dart';
import 'package:vocabulary_game/screens/language.dart';
import 'package:vocabulary_game/screens/new_word.dart';
import 'package:vocabulary_game/screens/vocabulary.dart';
import 'test_prefs_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Vocabulary Game Integration Tests', () {
    setUp(() async {
      await TestPrefsHelper.setupTestData();
    });
    tearDown(() async {
      await TestPrefsHelper.clearAll();
    });
    testWidgets('Navigate through main app flow', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.byType(HomeScreen), findsOneWidget);

      // Navigate to vocabulary section
      await tester.tap(find.text('Vocabulary'));
      await tester.pumpAndSettle();

      // Verify we're in the vocabulary screen
      expect(find.byType(VocabularyScreen), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);

      // Go to add new word
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Verify we're in the new word screen
      expect(find.byType(NewWordScreen), findsOneWidget);

      // // Go back to home
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);

      // Navigate to Languages section
      await tester.tap(find.text('Learning languages'));
      await tester.pumpAndSettle();

      // Verify we're in the languages screen
      expect(find.byType(LanguageScreen), findsOneWidget);
    });

    testWidgets('Navigate thourgh different game modes sequentially', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Go to games
      await tester.tap(find.text('Start game'));
      await tester.pumpAndSettle();
      expect(find.byType(GameSelectScreen), findsOneWidget);

      // Test Connection Game
      await tester.tap(find.text('Connect Words'));
      await tester.pumpAndSettle();
      expect(find.byType(ConnectionGame), findsOneWidget);

      // Navigate back to game selection
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Test Multiple Choice
      await tester.tap(find.text('Multiple Choice'));
      await tester.pumpAndSettle();
      expect(find.byType(MultipleChoiceGame), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Multiple Choice\n(from translations)'));
      await tester.pumpAndSettle();
      expect(find.byType(MultipleChoiceGame), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Test Write Words
      await tester.tap(find.text('Write Words'));
      await tester.pumpAndSettle();
      expect(find.byType(WriteGame), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Write Words\n(from translations)'));
      await tester.pumpAndSettle();
      expect(find.byType(WriteGame), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Test Random Game
      await tester.tap(find.text('Any Game Mode'));
      await tester.pumpAndSettle();
      expect(find.byType(GameScreen), findsOneWidget);
    });

    testWidgets('Add word end-to-end flow', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to add word
      await tester.tap(find.text('Vocabulary'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Fill out the form
      await tester.enterText(
        find.widgetWithText(TextFormField, '').first,
        'Integration test word',
      );
      await tester.pump();

      await tester.enterText(
        find.widgetWithText(TextFormField, '').first,
        'Test translation',
      );
      await tester.pump();

      // Select a fluency level
      await tester.tap(find.byType(DropdownButtonFormField<WordLevel>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Intermediate').last);
      await tester.pumpAndSettle();

      // Add examples
      await tester.enterText(
        find.widgetWithText(TextFormField, '').last,
        'This is an example sentence.',
      );
      await tester.pump();

      await tester.tap(find.byIcon(Icons.plus_one));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextFormField, '').last,
        'This is another example sentence.',
      );
      await tester.pump();

      // // Save the word
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // // Should navigate back to vocabulary screen
      expect(find.byType(VocabularyScreen), findsOneWidget);
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();
      expect(
        find.text('Integration test word (Test translation)'),
        findsOneWidget,
      );
    });

    testWidgets('Large vocabulary performance', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Add multiple words to test performance
      await tester.tap(find.text('Vocabulary'));
      await tester.pumpAndSettle();

      // Add several words
      for (int i = 1; i <= 5; i++) {
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.widgetWithText(TextFormField, '').first,
          'Word $i',
        );
        await tester.pump();

        await tester.enterText(
          find.widgetWithText(TextFormField, '').first,
          'Translation $i',
        );
        await tester.pump();

        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();
      }

      // Test scrolling through the list
      await tester.drag(find.byType(ListView), const Offset(0, -200));
      await tester.pumpAndSettle();

      await tester.drag(find.byType(ListView), const Offset(0, 200));
      await tester.pumpAndSettle();

      // Test game performance with multiple words
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Start game'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Any Game Mode'));
      await tester.pumpAndSettle();

      // Game should load efficiently even with multiple words
      expect(find.byType(GameScreen), findsOneWidget);
    });
    testWidgets('Words persist across app restarts', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Add a word
      await tester.tap(find.text('Vocabulary'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      const testWord = 'Persistence Test';
      const testTranslation = 'Test de Persistencia';

      await tester.enterText(
        find.widgetWithText(TextFormField, '').first,
        testWord,
      );
      await tester.pump();

      await tester.enterText(
        find.widgetWithText(TextFormField, '').first,
        testTranslation,
      );
      await tester.pump();

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Verify the word appears in the list
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();
      expect(find.text('$testWord ($testTranslation)'), findsOneWidget);

      // Simulate app restart by rebuilding the widget tree
      await tester.pumpWidget(Container()); // Clear the tree
      await tester.pump();

      // Restart the app
      app.main();
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate back to words
      await tester.tap(find.text('Vocabulary'));
      await tester.pumpAndSettle();

      // Check if the word persisted
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();
      expect(find.text('$testWord ($testTranslation)'), findsOneWidget);
    });
  });
}
