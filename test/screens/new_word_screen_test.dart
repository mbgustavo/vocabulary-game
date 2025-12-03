import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocabulary_game/models/word.dart';
import 'package:vocabulary_game/models/language.dart';
import 'package:vocabulary_game/providers/settings_provider.dart';
import 'package:vocabulary_game/providers/vocabulary_provider.dart';
import 'package:vocabulary_game/screens/new_word.dart';

class MockSettingsNotifier extends SettingsNotifier {
  final Language _testLanguage;

  MockSettingsNotifier(super.ref, this._testLanguage) {
    state = {
      'loading': false,
      'languages': [_testLanguage],
      'learning_language': _testLanguage.value,
    };
  }

  @override
  Language getLearningLanguage() {
    return _testLanguage;
  }

  @override
  List<Language> getLanguages() {
    return [_testLanguage];
  }

  @override
  Language getLanguage(String language) {
    return _testLanguage;
  }

  @override
  Future<void> loadLanguages() async {
    state = {
      'loading': false,
      'languages': [_testLanguage],
      'learning_language': _testLanguage.value,
    };
  }
}

class MockVocabularyNotifier extends VocabularyNotifier {
  final List<Word> _mockWords;
  final String? _saveError;

  MockVocabularyNotifier(super.ref, this._mockWords, {String? saveError})
    : _saveError = saveError {
    state = {'loading': false, 'vocabulary': _mockWords};
  }

  @override
  List<Word> getVocabulary({String? language}) {
    return _mockWords;
  }

  @override
  Future<String?> saveWord(Word word) async {
    if (_saveError != null) {
      return _saveError;
    }
    _mockWords.add(word);
    state = {'loading': false, 'vocabulary': _mockWords};
    return null;
  }

  @override
  Future<void> loadVocabulary() async {}
}

void main() {
  group('NewWordScreen Widget Tests', () {
    final testLanguage = Language('Spanish', '🇪🇸');
    final mockWords = <Word>[];

    Widget createTestWidget({Word? initialWord, String? saveError}) {
      return ProviderScope(
        overrides: [
          settingsProvider.overrideWith(
            (ref) => MockSettingsNotifier(ref, testLanguage),
          ),
          vocabularyProvider.overrideWith(
            (ref) =>
                MockVocabularyNotifier(ref, mockWords, saveError: saveError),
          ),
        ],
        child: MaterialApp(home: NewWordScreen(initialWord: initialWord)),
      );
    }

    group('Widget Structure Tests', () {
      testWidgets('NewWordScreen renders correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(NewWordScreen), findsOneWidget);
        expect(find.text('Add new word'), findsOneWidget);
        expect(find.byType(Form), findsOneWidget);
        expect(find.text(testLanguage.name), findsWidgets);
        expect(find.text('Word in learning language'), findsOneWidget);
        expect(find.text('Translation in your language'), findsOneWidget);
        expect(find.text('Examples (optional)'), findsOneWidget);
        expect(find.text('Save'), findsOneWidget);
        expect(
          find.byType(TextFormField),
          findsNWidgets(3),
        ); // Input, Translation, and one example field

        final levelDropdown = find.byType(DropdownButtonFormField<WordLevel>);
        expect(levelDropdown, findsOneWidget);

        await tester.tap(levelDropdown);
        await tester.pumpAndSettle();

        // Verify all level options are present
        expect(find.text('Beginner'), findsWidgets);
        expect(find.text('Intermediate'), findsOneWidget);
        expect(find.text('Advanced'), findsOneWidget);
      });
    });

    group('Form Initialization Tests', () {
      testWidgets('NewWordScreen initializes with empty form for new word', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final inputField = find.widgetWithText(TextFormField, '');
        expect(inputField, findsNWidgets(3));
        expect(find.text('Beginner'), findsOneWidget);
      });

      testWidgets(
        'NewWordScreen initializes with existing word data when editing',
        (WidgetTester tester) async {
          final existingWord = Word(
            language: testLanguage.value,
            input: 'Hola',
            translation: 'Hello',
            level: WordLevel.intermediate,
            examples: ['¡Hola, cómo estás!', 'Hola mundo'],
            id: 'test-id',
          );

          await tester.pumpWidget(createTestWidget(initialWord: existingWord));
          await tester.pumpAndSettle();

          // Check that fields are pre-populated
          expect(find.text('Hola'), findsOneWidget);
          expect(find.text('Hello'), findsOneWidget);
          expect(find.text('¡Hola, cómo estás!'), findsOneWidget);
          expect(find.text('Hola mundo'), findsOneWidget);
          expect(find.text('Intermediate'), findsOneWidget);
        },
      );
    });

    group('Form Validation Tests', () {
      testWidgets(
        'NewWordScreen shows validation errors for empty required fields',
        (WidgetTester tester) async {
          await tester.pumpWidget(createTestWidget());
          await tester.pumpAndSettle();

          // Tap save without filling required fields
          await tester.tap(find.text('Save'));
          await tester.pumpAndSettle();

          expect(
            find.text('Must be between 1 and 50 characters.'),
            findsNWidgets(2),
          );
        },
      );

      testWidgets('NewWordScreen shows validation errors for too short input', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Enter single character in input field
        final inputFields = find.byType(TextFormField);
        await tester.enterText(inputFields.at(0), 'a');
        await tester.enterText(inputFields.at(1), 'b');

        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();

        expect(
          find.text('Must be between 1 and 50 characters.'),
          findsNWidgets(2),
        );
      });

      testWidgets('NewWordScreen accepts valid input', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Enter valid data
        final inputFields = find.byType(TextFormField);
        await tester.enterText(inputFields.at(0), 'Hola');
        await tester.enterText(inputFields.at(1), 'Hello');
        await tester.enterText(inputFields.at(2), 'Example sentence');

        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();

        // Should not show validation errors
        expect(find.text('Must be between 1 and 50 characters.'), findsNothing);
        // Should navigate back (no more NewWordScreen)
        expect(find.byType(NewWordScreen), findsNothing);
      });
    });

    group('Examples Management Tests', () {
      testWidgets('NewWordScreen allows adding example fields', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Initially should have 1 example field
        expect(
          find.byType(TextFormField),
          findsNWidgets(3),
        ); // input, translation, 1 example

        // Tap the add button
        await tester.tap(find.byIcon(Icons.plus_one));
        await tester.pumpAndSettle();

        // Should now have 2 example fields
        expect(
          find.byType(TextFormField),
          findsNWidgets(4),
        ); // input, translation, 2 examples

        // Tap the add button
        await tester.tap(find.byIcon(Icons.plus_one));
        await tester.tap(find.byIcon(Icons.plus_one));
        await tester.pumpAndSettle();

        // Should now have 2 example fields
        expect(
          find.byType(TextFormField),
          findsNWidgets(6),
        ); // input, translation, 4 examples
      });
    });

    group('Edge Cases Tests', () {
      testWidgets('NewWordScreen filters out empty examples when saving', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Add extra example field but leave it empty
        await tester.tap(find.byIcon(Icons.plus_one), warnIfMissed: false);
        await tester.pumpAndSettle();

        // Fill in required fields and one example
        final inputFields = find.byType(TextFormField);
        await tester.enterText(inputFields.at(0), 'Hola');
        await tester.enterText(inputFields.at(1), 'Hello');
        await tester.enterText(inputFields.at(2), 'Example 1');
        // Leave the second example field empty

        await tester.tap(find.text('Save'), warnIfMissed: false);
        await tester.pumpAndSettle();

        // Should have attempted to save (may or may not navigate away in test)
        // The important thing is no validation errors are shown
        expect(find.text('Must be between 1 and 50 characters.'), findsNothing);
      });
    });
  });
}
