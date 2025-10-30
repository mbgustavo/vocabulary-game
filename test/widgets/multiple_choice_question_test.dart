import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocabulary_game/widgets/multiple_choice_question.dart';
import 'package:vocabulary_game/widgets/word_card.dart';
import 'package:vocabulary_game/models/word.dart';

void main() {
  group('MultipleChoiceQuestion Widget Tests', () {
    late Word testQuestion;
    late List<WordInGame> testAnswers;

    setUp(() {
      // Create test question
      testQuestion = Word(
        input: 'casa',
        translation: 'house',
        language: 'spanish',
      );

      // Create test answers that don't conflict with the question
      testAnswers = [
        WordInGame(
          input: 'gato',
          translation: 'cat',
          language: 'spanish',
          level: WordLevel.beginner,
          examples: [],
          id: '1',
        ),
        WordInGame(
          input: 'perro',
          translation: 'dog',
          language: 'spanish',
          level: WordLevel.beginner,
          examples: [],
          id: '2',
        ),
        WordInGame(
          input: 'pájaro',
          translation: 'bird',
          language: 'spanish',
          level: WordLevel.beginner,
          examples: [],
          id: '3',
        ),
        WordInGame(
          input: 'casa',
          translation: 'house',
          language: 'spanish',
          level: WordLevel.beginner,
          examples: [],
          id: '4',
        ),
      ];
    });

    Widget createTestWidget({
      required Word question,
      required List<WordInGame> answers,
      bool playWithTranslations = false,
      void Function(WordInGame)? onAnswerSelected,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: MultipleChoiceQuestion(
            question: question,
            answers: answers,
            playWithTranslations: playWithTranslations,
            onAnswerSelected: onAnswerSelected,
          ),
        ),
      );
    }

    group('Display Tests', () {
      testWidgets(
        'should display question input and all answer translations when playWithTranslations is false',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            createTestWidget(
              question: testQuestion,
              answers: testAnswers,
              playWithTranslations: false,
            ),
          );

          // Should display the input (original word)
          expect(find.text(testQuestion.input), findsOneWidget);

          // Should find all WordCard widgets
          expect(find.byType(WordCard), findsNWidgets(testAnswers.length));
          for (final answer in testAnswers) {
            expect(find.text(answer.translation), findsOneWidget);
          }
        },
      );

      testWidgets(
        'should display question translation and all answer inputs when playWithTranslations is true',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            createTestWidget(
              question: testQuestion,
              answers: testAnswers,
              playWithTranslations: true,
            ),
          );

          // Should display the input (original word)
          expect(find.text(testQuestion.translation), findsOneWidget);

          // Should find all WordCard widgets
          expect(find.byType(WordCard), findsNWidgets(testAnswers.length));
          for (final answer in testAnswers) {
            expect(find.text(answer.input), findsOneWidget);
          }
        },
      );
    });

    group('Interaction Tests', () {
      testWidgets('should call onAnswerSelected when answer is tapped', (
        WidgetTester tester,
      ) async {
        WordInGame? selectedAnswer;

        await tester.pumpWidget(
          createTestWidget(
            question: testQuestion,
            answers: testAnswers,
            onAnswerSelected: (answer) {
              selectedAnswer = answer;
            },
          ),
        );

        // Tap on the first answer
        await tester.tap(find.byType(WordCard).first);
        await tester.pumpAndSettle();

        expect(selectedAnswer, equals(testAnswers.first));
      });
    });

    group('Edge Cases Tests', () {
      testWidgets('should handle empty answers list', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(question: testQuestion, answers: []),
        );

        expect(
          find.text('casa'),
          findsOneWidget,
        ); // Question should still display
        expect(find.byType(WordCard), findsNothing); // No answer cards
      });

      testWidgets('should handle very long question text', (
        WidgetTester tester,
      ) async {
        final longQuestion = Word(
          input:
              'This is a very long question that might cause layout issues in the widget',
          translation:
              'Esta es una pregunta muy larga que podría causar problemas de diseño',
          language: 'spanish',
        );

        await tester.pumpWidget(
          createTestWidget(question: longQuestion, answers: testAnswers),
        );

        expect(
          find.text(
            'This is a very long question that might cause layout issues in the widget',
          ),
          findsOneWidget,
        );
        expect(find.byType(WordCard), findsNWidgets(testAnswers.length));
      });

      testWidgets('should handle answers with special characters', (
        WidgetTester tester,
      ) async {
        final specialAnswers = [
          WordInGame(
            input: '¿Cómo estás?',
            translation: 'How are you?',
            language: 'spanish',
            level: WordLevel.beginner,
            examples: [],
            id: '1',
          ),
        ];

        await tester.pumpWidget(
          createTestWidget(
            question: specialAnswers.first,
            answers: specialAnswers,
            playWithTranslations: true,
          ),
        );

        expect(find.text('¿Cómo estás?'), findsOneWidget);
      });
    });
  });
}
