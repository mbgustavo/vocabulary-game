import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocabulary_game/games/connection_game.dart';
import 'package:vocabulary_game/models/word.dart';
import 'package:vocabulary_game/widgets/word_card.dart';
import 'package:vocabulary_game/widgets/game_completed.dart';

void main() {
  group('ConnectionGame Widget Tests', () {
    // Helper function to create test words
    List<Word> createTestVocabulary({int count = 5}) {
      return List.generate(
        count,
        (index) => Word(
          language: 'English',
          input: 'Word$index',
          translation: 'Translation$index',
          level: WordLevel.beginner,
          examples: index == 0 ? ['Example sentence for word$index'] : [],
        ),
      );
    }

    // Helper function to create test widget
    Widget createTestWidget({
      List<Word>? vocabulary,
      int wordsQty = 5, // Use smaller number for easier testing
    }) {
      return MaterialApp(
        home: Scaffold(
          body: ConnectionGame(
            vocabulary ?? createTestVocabulary(count: 5),
            wordsQty: wordsQty,
          ),
        ),
      );
    }

    group('Initialization Tests', () {
      testWidgets('should initialize with correct number of word cards', (
        WidgetTester tester,
      ) async {
        // Arrange & Act
        await tester.pumpWidget(createTestWidget(wordsQty: 5));

        // Assert
        expect(
          find.byType(WordCard),
          findsNWidgets(10),
        ); // 5 words + 5 translations
        expect(find.byType(GridView), findsOneWidget);
        expect(find.byType(ConnectionGame), findsOneWidget);
      });

      testWidgets('should display correct word texts', (
        WidgetTester tester,
      ) async {
        // Arrange
        final vocabulary = [
          Word(language: 'English', input: 'Hello', translation: 'Olá'),
          Word(language: 'English', input: 'World', translation: 'Mundo'),
        ];

        // Act
        await tester.pumpWidget(
          createTestWidget(vocabulary: vocabulary, wordsQty: 2),
        );

        // Assert
        expect(find.text('Hello'), findsOneWidget);
        expect(find.text('World'), findsOneWidget);
        expect(find.text('Olá'), findsOneWidget);
        expect(find.text('Mundo'), findsOneWidget);
      });

      testWidgets('should not show game completed initially', (
        WidgetTester tester,
      ) async {
        // Arrange & Act
        await tester.pumpWidget(createTestWidget(wordsQty: 5));

        // Assert
        expect(find.byType(GameCompleted), findsNothing);
      });

      testWidgets('should not show examples initially', (
        WidgetTester tester,
      ) async {
        // Arrange
        final vocabulary = [
          Word(
            language: 'English',
            input: 'Hello',
            translation: 'Olá',
            examples: ['Hello, world!'],
          ),
        ];

        // Act
        await tester.pumpWidget(
          createTestWidget(vocabulary: vocabulary, wordsQty: 1),
        );

        // Assert
        expect(find.text('Hello, world!'), findsNothing);
      });
    });

    group('Word Selection Tests', () {
      testWidgets('should allow selecting words', (WidgetTester tester) async {
        // Arrange
        final vocabulary = [
          Word(language: 'English', input: 'Hello', translation: 'Olá'),
          Word(language: 'English', input: 'World', translation: 'Mundo'),
        ];

        // Act
        await tester.pumpWidget(
          createTestWidget(vocabulary: vocabulary, wordsQty: 2),
        );
        await tester.pumpAndSettle();

        // Tap on first word
        await tester.tap(find.text('Hello').first);
        await tester.pumpAndSettle();

        // Assert - Word should be selectable (no error thrown)
        expect(find.byType(ConnectionGame), findsOneWidget);
      });

      testWidgets('should allow tapping translation words', (
        WidgetTester tester,
      ) async {
        // Arrange
        final vocabulary = [
          Word(language: 'English', input: 'Hello', translation: 'Olá'),
          Word(language: 'English', input: 'World', translation: 'Mundo'),
        ];

        // Act
        await tester.pumpWidget(
          createTestWidget(vocabulary: vocabulary, wordsQty: 2),
        );
        await tester.pumpAndSettle();

        // Tap on translation
        await tester.tap(find.text('Olá').first);
        await tester.pumpAndSettle();

        // Assert - Translation should be selectable (no error thrown)
        expect(find.byType(ConnectionGame), findsOneWidget);
      });

      testWidgets('should handle multiple word selections', (
        WidgetTester tester,
      ) async {
        // Arrange
        final vocabulary = [
          Word(language: 'English', input: 'Cat', translation: 'Gato'),
          Word(language: 'English', input: 'Dog', translation: 'Cão'),
          Word(language: 'English', input: 'Bird', translation: 'Pássaro'),
        ];

        // Act
        await tester.pumpWidget(
          createTestWidget(vocabulary: vocabulary, wordsQty: 3),
        );
        await tester.pumpAndSettle();

        // Select multiple words
        await tester.tap(find.text('Cat').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Dog').first);
        await tester.pumpAndSettle();

        // Assert - Should handle multiple selections without error
        expect(find.byType(ConnectionGame), findsOneWidget);
      });
    });

    group('Game Logic Tests', () {
      testWidgets('should show snackbar for incorrect matches', (
        WidgetTester tester,
      ) async {
        // Arrange
        final vocabulary = [
          Word(language: 'English', input: 'Hello', translation: 'Olá'),
          Word(language: 'English', input: 'World', translation: 'Mundo'),
        ];

        // Act
        await tester.pumpWidget(
          createTestWidget(vocabulary: vocabulary, wordsQty: 2),
        );
        await tester.pumpAndSettle();

        // Select mismatched pair
        await tester.tap(find.text('Hello').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Mundo').first);
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Incorrect match! Try again.'), findsOneWidget);
      });

      testWidgets('should show examples after correct match', (
        WidgetTester tester,
      ) async {
        // Arrange
        final vocabulary = [
          Word(
            language: 'English',
            input: 'Hello',
            translation: 'Olá',
            examples: ['Hello, world!', 'Hello there!'],
          ),
          Word(language: 'English', input: 'World', translation: 'Mundo'),
        ];

        // Act
        await tester.pumpWidget(
          createTestWidget(vocabulary: vocabulary, wordsQty: 2),
        );
        await tester.pumpAndSettle();

        // Make correct match
        await tester.tap(find.text('Hello').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Olá').first);
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Incorrect match! Try again.'), findsNothing);
        expect(find.text('Hello, world!\nHello there!'), findsOneWidget);
      });

      testWidgets('should complete game when all pairs matched', (
        WidgetTester tester,
      ) async {
        // Arrange
        final vocabulary = [
          Word(language: 'English', input: 'Hello', translation: 'Olá'),
          Word(language: 'English', input: 'World', translation: 'Mundo'),
        ];

        // Act
        await tester.pumpWidget(
          createTestWidget(vocabulary: vocabulary, wordsQty: 2),
        );
        await tester.pumpAndSettle();

        // Verify no game completed widget initially
        expect(find.byType(GameCompleted), findsNothing);

        // Select correct pairs
        await tester.tap(find.text('Hello').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Olá').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('World').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Mundo').first);
        await tester.pumpAndSettle();

        expect(find.byType(GameCompleted), findsOneWidget);

        // Scroll to find button and tap to restart
        await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -100));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Play again'));
        await tester.pumpAndSettle();

        expect(find.byType(GameCompleted), findsNothing);
      });
    });

    group('Edge Cases Tests', () {
      testWidgets('should handle rapid consecutive taps', (
        WidgetTester tester,
      ) async {
        // Arrange
        final vocabulary = [
          Word(language: 'English', input: 'Cat', translation: 'Gato'),
          Word(language: 'English', input: 'Dog', translation: 'Cão'),
        ];

        // Act
        await tester.pumpWidget(
          createTestWidget(vocabulary: vocabulary, wordsQty: 2),
        );
        await tester.pumpAndSettle();

        // Rapid taps
        await tester.tap(find.text('Cat').first);
        await tester.tap(find.text('Dog').first);
        await tester.tap(find.text('Gato').first);
        await tester.pump();

        // Assert - Should not crash
        expect(find.byType(ConnectionGame), findsOneWidget);
      });

      testWidgets('should handle different word levels', (
        WidgetTester tester,
      ) async {
        // Arrange
        final vocabulary = [
          Word(
            language: 'English',
            input: 'cat',
            translation: 'gato',
            level: WordLevel.beginner,
          ),
          Word(
            language: 'English',
            input: 'elephant',
            translation: 'elefante',
            level: WordLevel.intermediate,
          ),
          Word(
            language: 'English',
            input: 'hippopotamus',
            translation: 'hipopótamo',
            level: WordLevel.advanced,
          ),
        ];

        // Act & Assert - Should handle mixed levels without error
        await tester.pumpWidget(
          createTestWidget(vocabulary: vocabulary, wordsQty: 3),
        );
        expect(find.byType(ConnectionGame), findsOneWidget);
        expect(
          find.byType(WordCard),
          findsNWidgets(6),
        ); // 3 words + 3 translations
      });
    });
  });
}
