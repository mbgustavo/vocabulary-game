import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vocabulary_game/screens/data.dart';
import 'package:vocabulary_game/storage/pref_storage.dart';
import 'package:vocabulary_game/storage/storage_interface.dart';
import 'package:vocabulary_game/providers/languages_provider.dart';
import 'package:vocabulary_game/providers/vocabulary_provider.dart';
import 'package:vocabulary_game/models/language.dart';
import 'package:vocabulary_game/models/word.dart';

// Mock classes
class MockStorage extends Mock implements StorageInterface {}

class MockLanguagesNotifier extends LanguagesNotifier {
  MockLanguagesNotifier(super.ref) {
    state = {
      'loading': false,
      'languages': [Language('Spanish', '🇪🇸')],
      'learning_language': 'spanish',
    };
  }

  @override
  List<Language> getLanguages() => [Language('Spanish', '🇪🇸')];

  @override
  Language getLearningLanguage() => Language('Spanish', '🇪🇸');

  @override
  Language getLanguage(String language) => Language('Spanish', '🇪🇸');
}

class MockVocabularyNotifier extends VocabularyNotifier {
  MockVocabularyNotifier(super.ref) {
    state = {'loading': false, 'vocabulary': []};
  }

  @override
  List<Word> getVocabulary({String? language}) => [];
}

void main() {
  late MockStorage mockStorage;

  setUpAll(() {
    // Register fallback values for mocktail
    registerFallbackValue(Language('Test', '🔤'));
    registerFallbackValue(Word(language: 'test', input: 'test', translation: 'test'));
  });

  setUp(() {
    mockStorage = MockStorage();
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        storageProvider.overrideWithValue(mockStorage),
        languagesProvider.overrideWith((ref) => MockLanguagesNotifier(ref)),
        vocabularyProvider.overrideWith((ref) => MockVocabularyNotifier(ref)),
      ],
      child: const MaterialApp(home: DataScreen()),
    );
  }

  group('DataScreen Widget Tests', () {
    group('Widget Display Tests', () {
      testWidgets('renders correctly with all UI elements', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verify main UI elements
        expect(find.byType(DataScreen), findsOneWidget);
        expect(find.text('Data Management'), findsOneWidget);
        expect(find.text('Manage your vocabulary data'), findsOneWidget);
        
        // Verify all three main options are present
        expect(find.text('Save Backup'), findsOneWidget);
        expect(find.text('Restore Backup'), findsOneWidget);
        expect(find.text('Restore Defaults'), findsOneWidget);
        
        // Verify subtitles
        expect(find.text('Save your current vocabulary and languages'), findsOneWidget);
        expect(find.text('Restore from a previously saved backup'), findsOneWidget);
        expect(find.text('Reset to default settings and clear all data'), findsOneWidget);

        // Verify icons
        expect(find.byIcon(Icons.save), findsOneWidget);
        expect(find.byIcon(Icons.restore), findsOneWidget);
        expect(find.byIcon(Icons.refresh), findsOneWidget);

        // Verify cards and list tiles
        expect(find.byType(Card), findsNWidgets(3));
        expect(find.byType(ListTile), findsNWidgets(3));
      });
    });

    group('Restore Defaults Functionality', () {
      testWidgets('restore defaults shows confirmation dialog', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Restore Defaults'));
        await tester.pumpAndSettle();

        // Verify confirmation dialog appears
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.textContaining('This will delete all your vocabulary data'), findsOneWidget);
        expect(find.textContaining('This action cannot be undone'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
        
        // Find the restore defaults button in the dialog (not in the list)
        final dialogButtons = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(TextButton),
        );
        expect(dialogButtons, findsNWidgets(2)); // Cancel and Restore Defaults buttons
      });

      testWidgets('restore defaults performs action when confirmed', (WidgetTester tester) async {
        when(() => mockStorage.restoreDefaults()).thenAnswer((_) async {});

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Restore Defaults'));
        await tester.pumpAndSettle();

        // Find the restore defaults button in dialog by finding the TextButton with the specific styling
        final dialogRestoreButton = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byWidgetPredicate(
            (widget) => widget is TextButton && widget.child is Text && (widget.child as Text).data == 'Restore Defaults',
          ),
        );
        expect(dialogRestoreButton, findsOneWidget);
        
        await tester.tap(dialogRestoreButton);
        await tester.pumpAndSettle();

        // Verify restore defaults was called
        verify(() => mockStorage.restoreDefaults()).called(1);

        // Verify success message
        expect(find.textContaining('Successfully restored to defaults'), findsOneWidget);
      });

      testWidgets('restore defaults handles cancellation', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Restore Defaults'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        // Verify restore defaults was NOT called
        verifyNever(() => mockStorage.restoreDefaults());
      });

      testWidgets('restore defaults handles errors gracefully', (WidgetTester tester) async {
        when(() => mockStorage.restoreDefaults()).thenThrow(Exception('Storage error'));

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Restore Defaults'));
        await tester.pumpAndSettle();

        // Find the restore defaults button in dialog by finding the TextButton with the specific styling
        final dialogRestoreButton = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byWidgetPredicate(
            (widget) => widget is TextButton && widget.child is Text && (widget.child as Text).data == 'Restore Defaults',
          ),
        );
        await tester.tap(dialogRestoreButton);
        await tester.pumpAndSettle();

        // Verify error message
        expect(find.textContaining('Failed to restore defaults'), findsOneWidget);
      });
    });
  });
}