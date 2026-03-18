import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vocabulary_game/models/word.dart';
import 'package:vocabulary_game/models/language.dart';
import 'package:vocabulary_game/providers/languages_provider.dart';
import 'package:vocabulary_game/providers/vocabulary_provider.dart';
import 'package:vocabulary_game/screens/home.dart';
import 'package:vocabulary_game/screens/game_select.dart';
import 'package:vocabulary_game/screens/vocabulary.dart';
import 'package:vocabulary_game/screens/language.dart';
import 'package:vocabulary_game/storage/pref_storage.dart';
import 'package:vocabulary_game/storage/storage_interface.dart';

import '../helpers/test_app_wrapper.dart';

class MockLanguagesNotifier extends LanguagesNotifier {
  final Language _testLanguage;

  MockLanguagesNotifier(super.ref, this._testLanguage) {
    // Initialize the state properly
    state = {
      'loading': false,
      'languages': [_testLanguage],
      'learning_language': _testLanguage.value,
      'app_language': 'en',
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
}

class MockVocabularyNotifier extends VocabularyNotifier {
  final List<Word> _mockWords;

  MockVocabularyNotifier(super.ref, this._mockWords) {
    // Initialize the state properly
    state = {'loading': false, 'vocabulary': _mockWords};
  }

  @override
  List<Word> getVocabulary({String? language}) {
    return _mockWords;
  }
}

class MockStorage extends Mock implements StorageInterface {}

void main() {
  late MockStorage mockStorage;

  setUpAll(() {
    // Register fallback values for mocktail
    registerFallbackValue(Language('Test', '🔤'));
    registerFallbackValue(
      Word(language: 'test', input: 'test', translation: 'test'),
    );
    mockStorage = MockStorage();
  });

  group('HomeScreen Widget Tests', () {
    final testLanguage = Language('Spanish', '🇪🇸');

    // Mock words - less than 5 for testing disabled state
    final mockWordsInsufficient = [
      Word(language: testLanguage.value, input: 'Hello', translation: 'Hola'),
      Word(language: testLanguage.value, input: 'World', translation: 'Mundo'),
      Word(language: testLanguage.value, input: 'Cat', translation: 'Gato'),
    ];

    // Mock words - 5 or more for testing enabled state
    final mockWordsSufficient = [
      Word(language: testLanguage.value, input: 'Hello', translation: 'Hola'),
      Word(language: testLanguage.value, input: 'World', translation: 'Mundo'),
      Word(language: testLanguage.value, input: 'Cat', translation: 'Gato'),
      Word(language: testLanguage.value, input: 'Dog', translation: 'Perro'),
      Word(language: testLanguage.value, input: 'House', translation: 'Casa'),
      Word(language: testLanguage.value, input: 'Car', translation: 'Carro'),
    ];

    Widget createTestWidget(List<Word> mockWords) {
      when(() => mockStorage.getLanguages()).thenAnswer((_) async => []);
      return ProviderScope(
        overrides: [
          storageProvider.overrideWithValue(mockStorage),
          languagesProvider.overrideWith(
            (ref) => MockLanguagesNotifier(ref, testLanguage),
          ),
          vocabularyProvider.overrideWith(
            (ref) => MockVocabularyNotifier(ref, mockWords),
          ),
        ],
        child: createTestAppWrapper(child: const HomeScreen()),
      );
    }

    group('Widget Display Tests', () {
      testWidgets('HomeScreen renders correctly', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(mockWordsSufficient));
        await tester.pumpAndSettle();

        // Verify main UI elements
        expect(find.byType(HomeScreen), findsOneWidget);
        expect(find.text('Vocabulary Game'), findsOneWidget);
        expect(find.text('Welcome to Vocabulary Game!'), findsOneWidget);
        expect(
          find.text('You are learning ${testLanguage.name}'),
          findsOneWidget,
        );
        expect(find.text('Start game'), findsOneWidget);
        expect(find.text('Vocabulary'), findsOneWidget);
        expect(find.text('Learning Languages'), findsOneWidget);
        expect(find.byType(ElevatedButton), findsNWidgets(3));
        expect(find.byType(DropdownButton<String>), findsOneWidget);
        expect(find.text('🇬🇧  EN'), findsOneWidget);
      });
    });

    group('Buttons Tests', () {
      testWidgets(
        'Start game button is enabled when vocabulary has sufficient words',
        (WidgetTester tester) async {
          await tester.pumpWidget(createTestWidget(mockWordsSufficient));
          await tester.pumpAndSettle();

          final startGameButton = find.widgetWithText(
            ElevatedButton,
            'Start game',
          );
          expect(startGameButton, findsOneWidget);

          final elevatedButton = tester.widget<ElevatedButton>(startGameButton);
          expect(elevatedButton.onPressed, isNotNull);

          expect(
            find.text('You need at least 5 words to start a game'),
            findsNothing,
          );

          // Tap the Start game button
          await tester.tap(startGameButton);
          await tester.pumpAndSettle();

          // Verify navigation occurred
          expect(find.byType(GameSelectScreen), findsOneWidget);
        },
      );

      testWidgets(
        'Start game button is disabled when vocabulary has insufficient words',
        (WidgetTester tester) async {
          await tester.pumpWidget(createTestWidget(mockWordsInsufficient));
          await tester.pumpAndSettle();

          final startGameButton = find.widgetWithText(
            ElevatedButton,
            'Start game',
          );
          expect(startGameButton, findsOneWidget);

          final elevatedButton = tester.widget<ElevatedButton>(startGameButton);
          expect(elevatedButton.onPressed, isNull);
          expect(
            find.text('You need at least 5 words to start a game'),
            findsOneWidget,
          );

          await tester.tap(startGameButton);
          await tester.pumpAndSettle();

          // Verify no navigation occurred - still on HomeScreen
          expect(find.byType(HomeScreen), findsOneWidget);
          expect(find.byType(GameSelectScreen), findsNothing);
        },
      );

      testWidgets('Vocabulary button navigates to VocabularyScreen', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget(mockWordsSufficient));
        await tester.pumpAndSettle();

        await tester.tap(find.widgetWithText(ElevatedButton, 'Vocabulary'));
        await tester.pumpAndSettle();

        expect(find.byType(VocabularyScreen), findsOneWidget);
      });

      testWidgets('Learning languages button navigates to LanguageScreen', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget(mockWordsSufficient));
        await tester.pumpAndSettle();

        await tester.tap(
          find.widgetWithText(ElevatedButton, 'Learning Languages'),
        );
        await tester.pumpAndSettle();

        expect(find.byType(LanguageScreen), findsOneWidget);
      });

      group('App Language Dropdown Tests', () {
        testWidgets(
          'App language dropdown is displayed with all language options',
          (WidgetTester tester) async {
            await tester.pumpWidget(createTestWidget(mockWordsSufficient));
            await tester.pumpAndSettle();

            // Tap dropdown to open menu
            await tester.tap(find.byType(DropdownButton<String>));
            await tester.pumpAndSettle();

            // Verify all language options are available
            expect(find.text('🇩🇪  DE'), findsWidgets);
            expect(find.text('🇬🇧  EN'), findsWidgets);
            expect(find.text('🇪🇸  ES'), findsWidgets);
            expect(find.text('🇫🇷  FR'), findsWidgets);
            expect(find.text('🇮🇹  IT'), findsWidgets);
            expect(find.text('🇧🇷  PT'), findsWidgets);
          },
        );

        testWidgets(
          'App language dropdown calls setAppLanguage and updates UI',
          (WidgetTester tester) async {
            when(
              () => mockStorage.setAppLanguage(any()),
            ).thenAnswer((_) async {});

            await tester.pumpWidget(createTestWidget(mockWordsSufficient));
            await tester.pumpAndSettle();

            // Verify English UI is displayed
            expect(find.text('Vocabulary Game'), findsOneWidget);
            expect(find.text('Welcome to Vocabulary Game!'), findsOneWidget);

            // Tap dropdown to open menu
            await tester.tap(find.byType(DropdownButton<String>));
            await tester.pumpAndSettle();

            // Tap on Spanish language option
            await tester.tap(
              find.widgetWithText(DropdownMenuItem<String>, '🇪🇸  ES'),
            );
            await tester.pumpAndSettle();

            // Verify setAppLanguage was called with 'es'
            verify(() => mockStorage.setAppLanguage('es')).called(1);

            // Verify Spanish UI text is now displayed
            expect(find.text('Juego de Vocabulario'), findsOneWidget);
            expect(
              find.text('¡Bienvenido a Juego de Vocabulario!'),
              findsOneWidget,
            );
          },
        );

        testWidgets('App language can return to previous language', (
          WidgetTester tester,
        ) async {
          when(
            () => mockStorage.setAppLanguage(any()),
          ).thenAnswer((_) async {});

          await tester.pumpWidget(createTestWidget(mockWordsSufficient));
          await tester.pumpAndSettle();

          // Verify English UI is displayed
          expect(find.text('Vocabulary Game'), findsOneWidget);

          // Tap dropdown to open menu
          await tester.tap(find.byType(DropdownButton<String>));
          await tester.pumpAndSettle();

          // Tap on Spanish language option
          await tester.tap(
            find.widgetWithText(DropdownMenuItem<String>, '🇪🇸  ES'),
          );
          await tester.pumpAndSettle();

          // Verify setAppLanguage was called with 'es'
          verify(() => mockStorage.setAppLanguage('es')).called(1);

          // Verify Spanish UI text is now displayed
          expect(find.text('Juego de Vocabulario'), findsOneWidget);

          // Tap dropdown to open menu
          await tester.tap(find.byType(DropdownButton<String>));
          await tester.pumpAndSettle();

          // Tap on English language option
          await tester.tap(
            find.widgetWithText(DropdownMenuItem<String>, '🇬🇧  EN'),
          );
          await tester.pumpAndSettle();

          // Verify English UI is displayed back
          expect(find.text('Vocabulary Game'), findsOneWidget);
        });
      });
    });

    group('Edge Case Tests', () {
      testWidgets('HomeScreen handles exactly 5 words correctly', (
        WidgetTester tester,
      ) async {
        final exactlyFiveWords = mockWordsSufficient.take(5).toList();
        await tester.pumpWidget(createTestWidget(exactlyFiveWords));
        await tester.pumpAndSettle();

        // Start game should be enabled with exactly 5 words
        final startGameButton = find.widgetWithText(
          ElevatedButton,
          'Start game',
        );
        final elevatedButton = tester.widget<ElevatedButton>(startGameButton);
        expect(elevatedButton.onPressed, isNotNull);
        expect(
          find.text('You need at least 5 words to start a game'),
          findsNothing,
        );
      });

      testWidgets('HomeScreen handles empty vocabulary correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget([]));
        await tester.pumpAndSettle();

        // Start game should be disabled with no words
        final startGameButton = find.widgetWithText(
          ElevatedButton,
          'Start game',
        );
        final elevatedButton = tester.widget<ElevatedButton>(startGameButton);
        expect(elevatedButton.onPressed, isNull);
        expect(
          find.text('You need at least 5 words to start a game'),
          findsOneWidget,
        );
      });

      testWidgets('HomeScreen with error banner', (WidgetTester tester) async {
        final mockStorage = MockStorage();
        when(
          () => mockStorage.getVocabulary(),
        ).thenAnswer((_) async => throw Exception('Storage error'));
        when(() => mockStorage.getLanguages()).thenAnswer((_) async => []);
        when(
          () => mockStorage.getLearningLanguage(),
        ).thenAnswer((_) async => null);
        when(
          () => mockStorage.addLanguage(any()),
        ).thenAnswer((invocation) async => [invocation.positionalArguments[0]]);
        when(
          () => mockStorage.setLearningLanguage(any()),
        ).thenAnswer((_) async => {});
        final providerScope = ProviderScope(
          overrides: [
            storageProvider.overrideWithValue(mockStorage),
            languagesProvider.overrideWith(
              (ref) => MockLanguagesNotifier(ref, testLanguage),
            ),
            vocabularyProvider.overrideWith(
              (ref) => MockVocabularyNotifier(ref, mockWordsSufficient),
            ),
          ],
          child: createTestAppWrapper(child: HomeScreen()),
        );
        await tester.pumpWidget(providerScope);
        await tester.pumpAndSettle();
        expect(find.byType(MaterialBanner), findsOneWidget);
        expect(find.textContaining('Failed to load'), findsOneWidget);
      });
    });
  });
}
