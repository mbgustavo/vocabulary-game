import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vocabulary_game/widgets/language_list.dart';
import 'package:vocabulary_game/widgets/language_item.dart';
import 'package:vocabulary_game/models/language.dart';
import 'package:vocabulary_game/providers/settings_provider.dart';
import 'package:vocabulary_game/providers/notifications_provider.dart';
import 'package:vocabulary_game/storage/storage_interface.dart';

class MockStorage extends Mock implements StorageInterface {}

void main() {
  setUpAll(() {
    // Register fallback values for mocktail
    registerFallbackValue(Language('Test', '🏳️'));
    registerFallbackValue(CustomNotification('test'));
  });

  group('LanguageList Widget Tests', () {
    late MockStorage mockStorage;
    late List<Language> testLanguages;

    setUp(() {
      mockStorage = MockStorage();
      
      // Set up default mock responses
      when(() => mockStorage.getVocabulary()).thenAnswer((_) async => []);
      when(() => mockStorage.getLanguages()).thenAnswer((_) async => []);
      when(() => mockStorage.getLearningLanguage()).thenAnswer((_) async => null);
      when(() => mockStorage.setLearningLanguage(any())).thenAnswer((_) async => {});
      when(() => mockStorage.deleteLanguage(any())).thenAnswer((_) async => []);
      
      testLanguages = [
        Language('English', '🇺🇸'),
        Language('Spanish', '🇪🇸'),
        Language('French', '🇫🇷'),
        Language('German', '🇩🇪'),
      ];
    });

    Widget createTestWidget({
      required List<Language> languages,
      required String learningLanguage,
    }) {
      return ProviderScope(
        overrides: [
          settingsStorageProvider.overrideWithValue(mockStorage),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: LanguageList(
              languages: languages,
              learningLanguage: learningLanguage,
            ),
          ),
        ),
      );
    }

    group('Display Tests', () {
      testWidgets('should display all provided languages', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(
          languages: testLanguages,
          learningLanguage: 'spanish',
        ));

        // Should find all language names (Spanish will have multiple due to highlighting)
        expect(find.text('English'), findsOneWidget);
        expect(find.text('Spanish'), findsAtLeastNWidgets(1)); // Selected, so highlighted
        expect(find.text('French'), findsOneWidget);
        expect(find.text('German'), findsOneWidget);
        expect(find.byType(LanguageItem), findsNWidgets(testLanguages.length));
      });

      testWidgets('should mark the correct language as selected', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(
          languages: testLanguages,
          learningLanguage: 'spanish',
        ));

        // Find all LanguageItem widgets
        final languageItems = tester.widgetList<LanguageItem>(find.byType(LanguageItem));
        
        // Check that only the Spanish language is marked as selected
        var selectedCount = 0;
        for (final item in languageItems) {
          if (item.isSelected) {
            selectedCount++;
            expect(item.language.value, equals('spanish'));
          }
        }
        expect(selectedCount, equals(1));
      });

      testWidgets('should handle case when no language matches learningLanguage', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(
          languages: testLanguages,
          learningLanguage: 'nonexistent',
        ));

        // Find all LanguageItem widgets
        final languageItems = tester.widgetList<LanguageItem>(find.byType(LanguageItem));
        
        // Check that no language is marked as selected
        for (final item in languageItems) {
          expect(item.isSelected, isFalse);
        }
      });
    });

    group('ListView Tests', () {
      testWidgets('should use ListView.builder for rendering', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(
          languages: testLanguages,
          learningLanguage: 'spanish',
        ));

        expect(find.byType(ListView), findsOneWidget);
        
        final listView = tester.widget<ListView>(find.byType(ListView));
        expect(listView.itemExtent, isNull); // Should not have fixed item extent
      });

      testWidgets('should be scrollable with many languages', (WidgetTester tester) async {
        // Create many languages to test scrolling
        final manyLanguages = List.generate(20, (index) => 
          Language('Language $index', '🏳️')
        );

        await tester.pumpWidget(createTestWidget(
          languages: manyLanguages,
          learningLanguage: 'language-0',
        ));

        expect(find.byType(ListView), findsOneWidget);
        expect(find.byType(LanguageItem), findsWidgets);
        
        // Test scrolling
        await tester.drag(find.byType(ListView), const Offset(0, -300));
        await tester.pumpAndSettle();
        
        // Should still find LanguageItem widgets after scrolling
        expect(find.byType(LanguageItem), findsWidgets);
      });
    });

    group('Edge Cases Tests', () {
      testWidgets('should handle languages with special characters', (WidgetTester tester) async {
        final specialLanguages = [
          Language('Français', '🇫🇷'),
          Language('Español', '🇪🇸'),
          Language('Português', '🇧🇷'),
        ];
        
        await tester.pumpWidget(createTestWidget(
          languages: specialLanguages,
          learningLanguage: 'français',
        ));

        expect(find.text('Français'), findsAtLeastNWidgets(1)); // Selected, so highlighted
        expect(find.text('Español'), findsOneWidget);
        expect(find.text('Português'), findsOneWidget);
        
        final languageItems = tester.widgetList<LanguageItem>(find.byType(LanguageItem));
        expect(languageItems.first.isSelected, isTrue); // Français should be selected
      });

      testWidgets('should handle very long language names', (WidgetTester tester) async {
        final longNameLanguages = [
          Language('This is a very long language name that might cause layout issues', '🏳️'),
          Language('Short', '🏴'),
        ];
        
        await tester.pumpWidget(createTestWidget(
          languages: longNameLanguages,
          learningLanguage: 'short',
        ));

        expect(find.byType(LanguageItem), findsNWidgets(2));
        expect(find.text('This is a very long language name that might cause layout issues'), findsOneWidget);
        expect(find.text('Short'), findsAtLeastNWidgets(1)); // Selected, so highlighted
      });
    });

    group('Performance Tests', () {
      testWidgets('should efficiently render large number of languages', (WidgetTester tester) async {
        // Create a large number of languages
        final manyLanguages = List.generate(100, (index) => 
          Language('Language $index', '🏳️')
        );

        final stopwatch = Stopwatch()..start();
        
        await tester.pumpWidget(createTestWidget(
          languages: manyLanguages,
          learningLanguage: 'language-50',
        ));
        
        stopwatch.stop();
        
        // Should render without significant delay
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
        expect(find.byType(LanguageItem), findsWidgets);
        expect(find.byType(ListView), findsOneWidget);
      });
    });
  });
}