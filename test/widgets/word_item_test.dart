import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vocabulary_game/widgets/word_item.dart';
import 'package:vocabulary_game/models/word.dart';
import 'package:vocabulary_game/models/language.dart';
import 'package:vocabulary_game/providers/settings_provider.dart';
import 'package:vocabulary_game/providers/vocabulary_provider.dart';
import 'package:vocabulary_game/providers/notifications_provider.dart';
import 'package:vocabulary_game/storage/storage_interface.dart';

class MockSettingsNotifier extends Mock implements SettingsNotifier {
  final Language mockLanguage = Language('English', '🇬🇧');
  
  final List<Language> mockLanguages = [
    Language('English', '🇬🇧'),
    Language('Portuguese', '🇧🇷'),
  ];

  @override
  Language getLanguage(String languageCode) => mockLanguages.firstWhere(
        (lang) => lang.value == languageCode,
        orElse: () => mockLanguage,
      );
  
  @override
  List<Language> getLanguages() => mockLanguages;
}

class MockVocabularyNotifier extends Mock implements VocabularyNotifier {}
class MockNotificationsNotifier extends Mock implements NotificationsNotifier {}
class MockStorage extends Mock implements StorageInterface {}

void main() {
  late MockSettingsNotifier mockSettingsNotifier;
  late MockVocabularyNotifier mockVocabularyNotifier;
  late MockNotificationsNotifier mockNotificationsNotifier;
  late MockStorage mockStorage;

  setUpAll(() {
    registerFallbackValue(Word(language: 'English', input: 'test', translation: 'teste'));
    registerFallbackValue(CustomNotification('Test notification'));
  });

  setUp(() {
    mockSettingsNotifier = MockSettingsNotifier();
    mockVocabularyNotifier = MockVocabularyNotifier();
    mockNotificationsNotifier = MockNotificationsNotifier();
    mockStorage = MockStorage();
  });

  Word createTestWord({
    String language = 'English',
    String input = 'test',
    String translation = 'teste',
  }) {
    return Word(
      language: language,
      input: input,
      translation: translation,
    );
  }

  Widget createTestWidget({
    Word? word,
    List<Override>? overrides,
  }) {
    final testWord = word ?? createTestWord();
    
    return ProviderScope(
      overrides: overrides ?? [
        settingsProvider.overrideWith((ref) => mockSettingsNotifier),
        vocabularyProvider.overrideWith((ref) => mockVocabularyNotifier),
        notificationsProvider.overrideWith((ref) => mockNotificationsNotifier),
        settingsStorageProvider.overrideWithValue(mockStorage),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: WordItem(word: testWord),
        ),
      ),
    );
  }

  group('WordItem Widget Tests', () {
    group('Display Tests', () {
      testWidgets('should display word information correctly', (WidgetTester tester) async {
        // Arrange
        final word = createTestWord(input: 'Hello', translation: 'Olá');

        // Act
        await tester.pumpWidget(createTestWidget(word: word));

        // Assert
        expect(find.byType(ListTile), findsOneWidget);
        expect(find.text('Hello (Olá)'), findsOneWidget);
        expect(find.byType(WordItem), findsOneWidget);
      });

      testWidgets('should display language icon', (WidgetTester tester) async {
        // Arrange
        final word = createTestWord(language: 'portuguese');

        // Act
        await tester.pumpWidget(createTestWidget(word: word));

        // Assert
        expect(find.byType(WordItem), findsOneWidget);
        // Find the specific RichText that contains the icon
        final richTexts = tester.widgetList<RichText>(find.byType(RichText)).toList();
        final iconRichText = richTexts.firstWhere(
          (richText) => richText.text.toPlainText().contains('🇧🇷'),
        );
        expect(iconRichText.text.toPlainText(), equals('🇧🇷'));
      });

      testWidgets('should display edit and delete buttons', (WidgetTester tester) async {
        // Arrange
        final word = createTestWord();

        // Act
        await tester.pumpWidget(createTestWidget(word: word));

        // Assert
        expect(find.byIcon(Icons.edit), findsOneWidget);
        expect(find.byIcon(Icons.delete), findsOneWidget);
        expect(find.byType(IconButton), findsNWidgets(2));
      });
    });

    group('Delete Dialog Tests', () {
      testWidgets('should cancel delete when cancel is pressed', (WidgetTester tester) async {
        // Arrange
        final word = createTestWord();

        // Act
        await tester.pumpWidget(createTestWidget(word: word));
        await tester.tap(find.byIcon(Icons.delete));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Delete Word'), findsOneWidget);

        // Act
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(AlertDialog), findsNothing);
        verifyNever(() => mockVocabularyNotifier.deleteWord(any()));
      });

      testWidgets('should confirm delete when delete is pressed', (WidgetTester tester) async {
        // Arrange
        final word = createTestWord();
        when(() => mockVocabularyNotifier.deleteWord(word))
            .thenAnswer((_) async => 'Word deleted successfully');
        when(() => mockNotificationsNotifier.pushNotification(any()))
            .thenReturn(1);

        // Act
        await tester.pumpWidget(createTestWidget(word: word));
        await tester.tap(find.byIcon(Icons.delete));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Delete Word'), findsOneWidget);

        // Act
        await tester.tap(find.text('Delete'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(AlertDialog), findsNothing);
        verify(() => mockVocabularyNotifier.deleteWord(word)).called(1);
      });
    });
  });
}