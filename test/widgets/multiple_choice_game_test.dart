import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocabulary_game/games/multiple_choice_game.dart';
import 'package:vocabulary_game/models/word.dart';
import 'package:vocabulary_game/widgets/multiple_choice_question.dart';
import 'package:vocabulary_game/widgets/game_completed.dart';
import 'package:vocabulary_game/widgets/word_card.dart';

void main() {
  group('MultipleChoiceGame Widget Tests', () {
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

    // Helper function to create test widget
    Widget createTestWidget({
      List<Word>? vocabulary,
      List<Word>? words,
      bool playWithTranslations = false,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: MultipleChoiceGame(
            words ?? createTestWords(5),
            vocabulary: vocabulary,
            playWithTranslations: playWithTranslations,
          ),
        ),
      );
    }

    // Helper function to find the Next button (ElevatedButton.icon)
    Finder findNextButton() {
      return find.ancestor(
        of: find.text('Next'),
        matching: find.byWidgetPredicate((widget) => widget is ElevatedButton),
      );
    }

    group('Initialization Tests', () {
      testWidgets('should initialize with correct components', (
        WidgetTester tester,
      ) async {
        // Arrange & Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(MultipleChoiceGame), findsOneWidget);
        expect(find.byType(MultipleChoiceQuestion), findsOneWidget);
        expect(find.byType(WordCard), findsNWidgets(5));
        expect(find.text('Next'), findsOneWidget);

        // Find the button using the helper function
        final nextButton = tester.widget<ElevatedButton>(findNextButton());
        expect(nextButton.onPressed, isNull);
        expect(find.byType(GameCompleted), findsNothing);
      });

      testWidgets('should display question and answer options', (
        WidgetTester tester,
      ) async {
        // Arrange
        final words = [
          Word(language: 'English', input: 'Hello', translation: 'Olá'),
          Word(language: 'English', input: 'World', translation: 'Mundo'),
          Word(language: 'English', input: 'Good', translation: 'Bom'),
          Word(language: 'English', input: 'Bad', translation: 'Mau'),
        ];

        // Act
        await tester.pumpWidget(createTestWidget(words: words));

        // Assert
        expect(find.byType(MultipleChoiceQuestion), findsOneWidget);
        // Should find at least one of the words displayed
        final hasVocabWord = words.any(
          (word) =>
              find.text(word.input).evaluate().isNotEmpty &&
              find.text(word.translation).evaluate().isNotEmpty,
        );
        expect(hasVocabWord, isTrue);
      });

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
        await tester.pumpWidget(createTestWidget(words: words));

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

        // Arrange & Act
        await tester.pumpWidget(createTestWidget(words: words));
        await tester.pumpAndSettle();

        final question = words.firstWhere(
          (word) =>
              find.text(word.input).evaluate().isNotEmpty &&
              find.text(word.translation).evaluate().isNotEmpty,
        );
        await tester.tap(find.text(question.translation).first);
        await tester.pumpAndSettle();

        // Assert
        expect(
          find.text('Example sentence for word${words.indexOf(question)}'),
          findsOneWidget,
        );
        final nextButton = tester.widget<ElevatedButton>(findNextButton());
        expect(nextButton.onPressed, isNotNull);
      });

      testWidgets('should show snackbar for incorrect answers', (
        WidgetTester tester,
      ) async {
        // Arrange
        final words = createTestWords(5);

        // Act
        await tester.pumpWidget(createTestWidget(words: words));
        await tester.pumpAndSettle();

        final wrongQuestion = words.firstWhere(
          (word) =>
              find.text(word.input).evaluate().isEmpty &&
              find.text(word.translation).evaluate().isNotEmpty,
        );
        await tester.tap(find.text(wrongQuestion.translation).first);
        await tester.pumpAndSettle();
        final nextButton = tester.widget<ElevatedButton>(findNextButton());
        expect(nextButton.onPressed, isNull);

        // Assert
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Incorrect match! Try again.'), findsOneWidget);
        expect(find.textContaining('Example sentence'), findsNothing);
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
          (word) =>
              find.text(word.input).evaluate().isNotEmpty &&
              find.text(word.translation).evaluate().isNotEmpty,
        );
        final wrongQuestion = words.firstWhere(
          (word) =>
              find.text(word.input).evaluate().isEmpty &&
              find.text(word.translation).evaluate().isNotEmpty,
        );
        await tester.tap(find.text(wrongQuestion.translation).first);
        await tester.pumpAndSettle();
        await tester.tap(find.text(rightQuestion.translation).first);
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(SnackBar), findsNothing);
        expect(find.text('Incorrect match! Try again.'), findsNothing);
        expect(
          find.text('Example sentence for word${words.indexOf(rightQuestion)}'),
          findsOneWidget,
        );
        final nextButton = tester.widget<ElevatedButton>(findNextButton());
        expect(nextButton.onPressed, isNotNull);
      });

      testWidgets('should complete the game', (WidgetTester tester) async {
        // Arrange
        final words = createTestWords(5);

        // Act
        await tester.pumpWidget(createTestWidget(words: words));
        await tester.pumpAndSettle();

        for (var i = 0; i < words.length; i++) {
          final question = words.firstWhere(
            (word) =>
                find.text(word.input).evaluate().isNotEmpty &&
                find.text(word.translation).evaluate().isNotEmpty,
          );
          await tester.tap(find.text(question.translation).first);
          await tester.pumpAndSettle();
          if (i < words.length - 1) {
            await tester.tap(find.text('Next'));
            await tester.pumpAndSettle();
          }
        }

        // Assert
        expect(find.byType(GameCompleted), findsOneWidget);
      });

      testWidgets('should complete the game with translations', (
        WidgetTester tester,
      ) async {
        // Arrange
        final words = createTestWords(5);

        // Act
        await tester.pumpWidget(
          createTestWidget(words: words, playWithTranslations: true),
        );
        await tester.pumpAndSettle();

        for (var i = 0; i < words.length; i++) {
          final question = words.firstWhere(
            (word) =>
                find.text(word.input).evaluate().isNotEmpty &&
                find.text(word.translation).evaluate().isNotEmpty,
          );
          await tester.tap(find.text(question.input).first);
          await tester.pumpAndSettle();
          if (i < words.length - 1) {
            await tester.tap(find.text('Next'));
            await tester.pumpAndSettle();
          }
        }

        // Assert - Widget should render without errors
        expect(find.byType(GameCompleted), findsOneWidget);
      });
    });

    group('Edge Cases Tests', () {
      testWidgets('should handle different word levels', (
        WidgetTester tester,
      ) async {
        // Arrange
        final words = [
          Word(
            language: 'English',
            input: 'Cat',
            translation: 'Gato',
            level: WordLevel.beginner,
          ),
          Word(
            language: 'English',
            input: 'Elephant',
            translation: 'Elefante',
            level: WordLevel.intermediate,
          ),
          Word(
            language: 'English',
            input: 'Hippopotamus',
            translation: 'Hipopótamo',
            level: WordLevel.advanced,
          ),
          Word(
            language: 'English',
            input: 'Dog',
            translation: 'Cão',
            level: WordLevel.beginner,
          ),
        ];

        // Act & Assert - Should handle mixed levels without error
        await tester.pumpWidget(createTestWidget(words: words));
        expect(find.byType(MultipleChoiceGame), findsOneWidget);
        expect(find.byType(MultipleChoiceQuestion), findsOneWidget);
      });
    });
  });
}
