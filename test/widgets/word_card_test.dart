import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocabulary_game/widgets/word_card.dart';
import 'package:vocabulary_game/models/word.dart';

void main() {
  group('WordCard Widget Tests', () {
    // Helper function to create test words
    WordInGame createTestWord({
      String input = 'teste',
      String translation = 'test',
      WordStatus status = WordStatus.notSelected,
      WordLevel level = WordLevel.beginner,
    }) {
      final word = WordInGame(
        id: 'test-id',
        input: input,
        translation: translation,
        level: level,
        language: 'Portuguese',
        examples: [],
      );
      word.status = status;
      return word;
    }

    // Helper function to create test widget
    Widget createTestWidget({
      required WordInGame word,
      String Function(WordInGame)? getText,
      void Function(WordInGame)? onTap,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: WordCard(
            word: word,
            getText: getText ?? (w) => w.input,
            onTap: onTap,
          ),
        ),
      );
    }

    group('Display Tests', () {
      testWidgets('should display word text correctly', (
        WidgetTester tester,
      ) async {
        final word = createTestWord(input: 'olá');

        await tester.pumpWidget(createTestWidget(word: word));

        expect(find.text('olá'), findsOneWidget);
      });

      testWidgets('should display translation when getText returns it', (
        WidgetTester tester,
      ) async {
        final word = createTestWord(input: 'olá', translation: 'hello');

        await tester.pumpWidget(
          createTestWidget(word: word, getText: (w) => w.translation),
        );

        expect(find.text('hello'), findsOneWidget);
        expect(find.text('olá'), findsNothing);
      });
    });

    group('Status Color Tests', () {
      testWidgets('should show primary color for selected status', (
        WidgetTester tester,
      ) async {
        final word = createTestWord(status: WordStatus.selected);

        await tester.pumpWidget(createTestWidget(word: word));

        final textWidget = tester.widget<Text>(find.byType(Text));
        final context = tester.element(find.byType(Text));
        final theme = Theme.of(context);

        expect(textWidget.style?.color, equals(theme.colorScheme.primary));
      });

      testWidgets('should show error color for error status', (
        WidgetTester tester,
      ) async {
        final word = createTestWord(status: WordStatus.error);

        await tester.pumpWidget(createTestWidget(word: word));

        final textWidget = tester.widget<Text>(find.byType(Text));
        final context = tester.element(find.byType(Text));
        final theme = Theme.of(context);

        expect(
          textWidget.style?.color,
          equals(theme.colorScheme.errorContainer),
        );
      });

      testWidgets('should show default color for not selected status', (
        WidgetTester tester,
      ) async {
        final word = createTestWord(status: WordStatus.notSelected);

        await tester.pumpWidget(createTestWidget(word: word));

        final textWidget = tester.widget<Text>(find.byType(Text));
        final context = tester.element(find.byType(Text));
        final theme = Theme.of(context);

        expect(textWidget.style?.color, equals(theme.colorScheme.onSurface));
      });
    });

    group('Card Background Tests', () {
      testWidgets('should show disabled background for completed status', (
        WidgetTester tester,
      ) async {
        final word = createTestWord(status: WordStatus.completed);

        await tester.pumpWidget(createTestWidget(word: word));

        final cardWidget = tester.widget<Card>(find.byType(Card));
        final context = tester.element(find.byType(Card));
        final theme = Theme.of(context);

        expect(cardWidget.color, equals(theme.colorScheme.surfaceContainer));
      });

      testWidgets('should show disabled background for disabled status', (
        WidgetTester tester,
      ) async {
        final word = createTestWord(status: WordStatus.disabled);

        await tester.pumpWidget(createTestWidget(word: word));

        final cardWidget = tester.widget<Card>(find.byType(Card));
        final context = tester.element(find.byType(Card));
        final theme = Theme.of(context);

        expect(cardWidget.color, equals(theme.colorScheme.surfaceContainer));
      });

      testWidgets('should show active background for selectable status', (
        WidgetTester tester,
      ) async {
        final word = createTestWord(status: WordStatus.notSelected);

        await tester.pumpWidget(createTestWidget(word: word, onTap: (_) {}));

        final cardWidget = tester.widget<Card>(find.byType(Card));
        final context = tester.element(find.byType(Card));
        final theme = Theme.of(context);

        expect(cardWidget.color, equals(theme.colorScheme.onPrimaryFixed));
      });
    });

    group('Interaction Tests', () {
      testWidgets('should call onTap when tapped and not disabled', (
        WidgetTester tester,
      ) async {
        final word = createTestWord(status: WordStatus.notSelected);
        WordInGame? tappedWord;

        await tester.pumpWidget(
          createTestWidget(word: word, onTap: (w) => tappedWord = w),
        );

        await tester.tap(find.byType(InkWell));
        await tester.pumpAndSettle();

        expect(tappedWord, equals(word));
      });

      testWidgets('should not call onTap when completed', (
        WidgetTester tester,
      ) async {
        final word = createTestWord(status: WordStatus.completed);
        WordInGame? tappedWord;

        await tester.pumpWidget(
          createTestWidget(word: word, onTap: (w) => tappedWord = w),
        );

        await tester.tap(find.byType(InkWell));
        await tester.pumpAndSettle();

        expect(tappedWord, isNull);
      });

      testWidgets('should not call onTap when disabled', (
        WidgetTester tester,
      ) async {
        final word = createTestWord(status: WordStatus.disabled);
        WordInGame? tappedWord;

        await tester.pumpWidget(
          createTestWidget(word: word, onTap: (w) => tappedWord = w),
        );

        await tester.tap(find.byType(InkWell));
        await tester.pumpAndSettle();

        expect(tappedWord, isNull);
      });

      testWidgets('should not call onTap when onTap is null', (
        WidgetTester tester,
      ) async {
        final word = createTestWord(status: WordStatus.notSelected);

        await tester.pumpWidget(createTestWidget(word: word, onTap: null));

        // Should not throw error when tapping
        await tester.tap(find.byType(InkWell));
        await tester.pumpAndSettle();

        // Test passes if no exception is thrown
      });

      testWidgets('should disable InkWell for disabled statuses', (
        WidgetTester tester,
      ) async {
        final word = createTestWord(status: WordStatus.disabled);

        await tester.pumpWidget(createTestWidget(word: word, onTap: (_) {}));

        final inkWell = tester.widget<InkWell>(find.byType(InkWell));
        expect(inkWell.onTap, isNull);
      });
    });

    group('Edge Cases Tests', () {
      testWidgets('should handle all word statuses', (
        WidgetTester tester,
      ) async {
        for (final status in WordStatus.values) {
          final word = createTestWord(status: status);

          await tester.pumpWidget(createTestWidget(word: word));

          // Should render without errors for all statuses
          expect(find.byType(WordCard), findsOneWidget);
          expect(find.byType(Text), findsOneWidget);
        }
      });
    });
  });
}
