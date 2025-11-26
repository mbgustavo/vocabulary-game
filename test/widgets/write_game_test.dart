import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocabulary_game/games/write_game.dart';
import 'package:vocabulary_game/models/word.dart';
import 'package:vocabulary_game/widgets/game_completed.dart';

void main() {
  group('WriteGame Widget Tests', () {
    // Helper function to create test words
    List<Word> createTestWords(int count) {
      return List.generate(
        count,
        (index) => Word(
          language: 'English',
          input: 'word$index',
          translation: 'translation$index',
          level: WordLevel.beginner,
          examples: ['Example sentence for word$index'],
        ),
      );
    }

    // Helper function to create test widget that avoids overflow issues
    Widget createTestWidget({
      List<Word>? words,
      bool playWithTranslations = false,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: WriteGame(
            words ?? createTestWords(5),
            playWithTranslations: playWithTranslations,
          ),
        ),
      );
    }

    group('Widget Initialization', () {
      testWidgets('should initialize with correct components', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.byType(WriteGame), findsOneWidget);
        expect(
          find.text('Write the translation for the word:'),
          findsOneWidget,
        );

        final textField = find.byType(TextField);
        expect(textField, findsOneWidget);
        final textFieldWidget = tester.widget<TextField>(textField);
        expect(textFieldWidget.decoration?.labelText, equals('Your answer'));
        expect(textFieldWidget.style?.color, isNull);

        expect(find.text('Submit'), findsOneWidget);
        expect(find.byType(GameCompleted), findsNothing);
      });

      testWidgets('should show first word', (
        WidgetTester tester,
      ) async {
        final words = [
          Word(language: 'English', input: 'Hello', translation: 'Olá'),
        ];

        await tester.pumpWidget(
          createTestWidget(words: words),
        );

        // Should show one of the words (since getWordsForGame may shuffle)
        expect(
          find.text('Hello').evaluate().isNotEmpty ||
              find.text('World').evaluate().isNotEmpty,
          isTrue,
        );
      });

      testWidgets(
        'should show first word when playing with translations',
        (WidgetTester tester) async {
          final words = [
            Word(language: 'English', input: 'Hello', translation: 'Olá'),
          ];

          await tester.pumpWidget(
            createTestWidget(
              words: words,
              playWithTranslations: true,
            ),
          );

          expect(
            find.text('Olá').evaluate().isNotEmpty,
            isTrue,
          );
        },
      );

      testWidgets('should not show examples initially', (
        WidgetTester tester,
      ) async {
        // Arrange
        final words = [
          Word(
            language: 'English',
            input: 'Hello',
            translation: 'Olá',
            examples: ['Hello, world!'],
          ),
        ];

        // Act
        await tester.pumpWidget(
          createTestWidget(words: words),
        );

        // Assert
        expect(find.text('Hello, world!'), findsNothing);
      });
    });

    group('Game Play Tests', () {
      testWidgets('should handle answer selection', (
        WidgetTester tester,
      ) async {
        // Arrange
        final words = createTestWords(5);

        // Act
        await tester.pumpWidget(createTestWidget(words: words));
        await tester.pumpAndSettle();

        final question = words.firstWhere(
          (word) => find.text(word.input).evaluate().isNotEmpty,
        );
        final textField = find.byType(TextField);
        await tester.enterText(textField, question.translation);
        await tester.tap(find.text('Submit'));
        await tester.pumpAndSettle();

        // Assert
        final textFieldWidget = tester.widget<TextField>(textField);
        expect(
          textFieldWidget.style?.color,
          Color.fromARGB(255, 104, 235, 111),
        );
        expect(textFieldWidget.readOnly, isTrue);
        expect(
          find.text('Example sentence for word${words.indexOf(question)}'),
          findsOneWidget,
        );
        expect(find.text('Next'), findsOneWidget);
      });

      testWidgets('should show snackbar for incorrect answers', (
        WidgetTester tester,
      ) async {
        // Arrange
        final words = createTestWords(5);

        // Act
        await tester.pumpWidget(createTestWidget(words: words));
        await tester.pumpAndSettle();

        final textField = find.byType(TextField);
        await tester.enterText(textField, 'wrong answer');
        await tester.tap(find.text('Submit'));
        await tester.pumpAndSettle();

        // Assert
        final context = tester.element(find.byType(TextField));
        final theme = Theme.of(context);
        final textFieldWidget = tester.widget<TextField>(textField);
        expect(textFieldWidget.style?.color, theme.colorScheme.error);
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Incorrect match! Try again.'), findsOneWidget);
        expect(find.textContaining('Example sentence'), findsNothing);
        expect(find.text('Next'), findsNothing);
      });

      testWidgets('should be able to select correct answer after mistake', (
        WidgetTester tester,
      ) async {
        // Arrange
        final words = createTestWords(5);

        // Act
        await tester.pumpWidget(createTestWidget(words: words));
        await tester.pumpAndSettle();

        final rightQuestion = words.firstWhere(
          (word) => find.text(word.input).evaluate().isNotEmpty,
        );
        final wrongQuestion = words.firstWhere(
          (word) => find.text(word.input).evaluate().isEmpty,
        );
        final textField = find.byType(TextField);
        final submitButton = find.text('Submit');
        await tester.enterText(textField, wrongQuestion.translation);
        await tester.tap(submitButton);
        await tester.pumpAndSettle();
        await tester.enterText(textField, "any other thing to reset error color");
        await tester.pumpAndSettle();
        final textFieldWidget = tester.widget<TextField>(textField);
        expect(textFieldWidget.style?.color, isNull);
        await tester.enterText(textField, rightQuestion.translation);
        await tester.tap(submitButton);
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(SnackBar), findsNothing);
        expect(find.text('Next'), findsOneWidget);
      });

      testWidgets('should be case insensitive', (WidgetTester tester) async {
        final words = [
          Word(language: 'English', input: 'Hello', translation: 'Olá'),
        ];

        await tester.pumpWidget(
          createTestWidget(words: words),
        );
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), 'OLÁ');
        await tester.tap(find.text('Submit'));
        await tester.pumpAndSettle();

        // Should not show error for correct case-insensitive answer
        expect(find.byType(SnackBar), findsNothing);
      });

      testWidgets('should complete the game', (WidgetTester tester) async {
        // Arrange
        final words = createTestWords(5);

        // Act
        await tester.pumpWidget(createTestWidget(words: words));
        await tester.pumpAndSettle();

        for (var i = 0; i < words.length; i++) {
          final question = words.firstWhere(
            (word) => find.text(word.input).evaluate().isNotEmpty,
          );
          final textField = find.byType(TextField);
          await tester.enterText(textField, question.translation);
          await tester.tap(find.text('Submit'));
          await tester.pumpAndSettle();
          if (i < words.length - 1) {
            await tester.tap(find.text('Next'));
            await tester.pumpAndSettle();
          }
        }

        // Assert
        expect(find.byType(GameCompleted), findsOneWidget);
      });

      testWidgets('should complete the game with translations', (WidgetTester tester) async {
        // Arrange
        final words = createTestWords(5);

        // Act
        await tester.pumpWidget(createTestWidget(words: words, playWithTranslations: true));
        await tester.pumpAndSettle();

        for (var i = 0; i < words.length; i++) {
          final question = words.firstWhere(
            (word) => find.text(word.translation).evaluate().isNotEmpty,
          );
          final textField = find.byType(TextField);
          await tester.enterText(textField, question.input);
          await tester.tap(find.text('Submit'));
          await tester.pumpAndSettle();
          if (i < words.length - 1) {
            await tester.tap(find.text('Next'));
            await tester.pumpAndSettle();
          }
        }

        // Assert
        expect(find.byType(GameCompleted), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle long text input gracefully', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());

        const longText =
            'This is a very long text input that should be handled properly';
        await tester.enterText(find.byType(TextField), longText);
        await tester.pump();

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.controller?.text, equals(longText));
      });

      testWidgets('should handle rapid button taps without crashing', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());

        final submitButton = find.text("Submit");

        // Rapid taps should not crash the widget
        for (int i = 0; i < 3; i++) {
          await tester.tap(submitButton);
          await tester.pump(const Duration(milliseconds: 10));
        }

        expect(find.byType(WriteGame), findsOneWidget);
      });
    });
  });
}
