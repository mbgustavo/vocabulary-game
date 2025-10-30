import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vocabulary_game/widgets/language_item.dart';
import 'package:vocabulary_game/widgets/highlighted_text.dart';
import 'package:vocabulary_game/widgets/new_language.dart';
import 'package:vocabulary_game/models/language.dart';
import 'package:vocabulary_game/providers/settings_provider.dart';
import 'package:vocabulary_game/providers/notifications_provider.dart';
import 'package:vocabulary_game/storage/storage_interface.dart';

class MockStorage extends Mock implements StorageInterface {}

class MockSettingsNotifier extends Mock implements SettingsNotifier {}

class MockNotificationsNotifier extends Mock implements NotificationsNotifier {}

void main() {
  setUpAll(() {
    // Register fallback values for mocktail
    registerFallbackValue(Language('Test', '🏳️'));
    registerFallbackValue(CustomNotification('test'));
  });

  group('LanguageItem Widget Tests', () {
    late MockStorage mockStorage;
    late MockSettingsNotifier mockSettingsNotifier;
    late MockNotificationsNotifier mockNotificationsNotifier;
    late Language testLanguage;

    setUp(() {
      mockStorage = MockStorage();
      mockSettingsNotifier = MockSettingsNotifier();
      mockNotificationsNotifier = MockNotificationsNotifier();
      testLanguage = Language('Spanish', '🇪🇸');

      // Set up default mock responses
      when(() => mockStorage.getVocabulary()).thenAnswer((_) async => []);
      when(() => mockStorage.getLanguages()).thenAnswer((_) async => []);
      when(
        () => mockStorage.getLearningLanguage(),
      ).thenAnswer((_) async => null);
      when(
        () => mockStorage.setLearningLanguage(any()),
      ).thenAnswer((_) async => {});
      when(() => mockStorage.deleteLanguage(any())).thenAnswer((_) async => []);

      when(
        () => mockSettingsNotifier.changeLearningLanguage(any()),
      ).thenAnswer((_) async => {});
      when(
        () => mockSettingsNotifier.deleteLanguage(any()),
      ).thenAnswer((_) async => null);

      when(
        () => mockNotificationsNotifier.pushNotification(any()),
      ).thenReturn(1);
    });

    Widget createTestWidget({
      required Language language,
      required bool isSelected,
      List<Override>? overrides,
    }) {
      return ProviderScope(
        overrides:
            overrides ??
            [settingsStorageProvider.overrideWithValue(mockStorage)],
        child: MaterialApp(
          home: Scaffold(
            body: LanguageItem(language: language, isSelected: isSelected),
          ),
        ),
      );
    }

    group('Display Tests', () {
      testWidgets('should display language name and icon', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(language: testLanguage, isSelected: false),
        );

        expect(find.text('Spanish'), findsOneWidget);

        // Find the specific RichText that contains the icon
        final richTexts = tester.widgetList<RichText>(find.byType(RichText));
        final iconRichText = richTexts.firstWhere(
          (richText) => richText.text.toPlainText().contains('🇪🇸'),
        );
        expect(iconRichText.text.toPlainText(), equals('🇪🇸'));
      });

      testWidgets('should show highlighted text when language is selected', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(language: testLanguage, isSelected: true),
        );

        // Should find the highlighted text widget
        expect(find.byType(HighlightedText), findsOneWidget);
        // Check that there are multiple Text widgets (due to highlighting effect)
        expect(find.text('Spanish'), findsNWidgets(2));
      });

      testWidgets('should show regular text when language is not selected', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(language: testLanguage, isSelected: false),
        );

        // Should find regular Text widget, not HighlightedText
        expect(find.byType(HighlightedText), findsNothing);
        expect(find.text('Spanish'), findsOneWidget);
      });

      testWidgets(
        'should display edit button for both selected and non-selected languages',
        (WidgetTester tester) async {
          // Test for selected language
          await tester.pumpWidget(
            createTestWidget(language: testLanguage, isSelected: true),
          );

          expect(find.byIcon(Icons.edit), findsOneWidget);

          // Test for non-selected language
          await tester.pumpWidget(
            createTestWidget(language: testLanguage, isSelected: false),
          );

          expect(find.byIcon(Icons.edit), findsOneWidget);
        },
      );

      testWidgets('should show check icon when language is selected', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(language: testLanguage, isSelected: true),
        );

        expect(find.byIcon(Icons.check), findsOneWidget);
        expect(find.byIcon(Icons.delete), findsNothing);
      });

      testWidgets('should show delete button when language is not selected', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(language: testLanguage, isSelected: false),
        );

        expect(find.byIcon(Icons.delete), findsOneWidget);
        expect(find.byIcon(Icons.check), findsNothing);
      });
    });

    group('Interaction Tests', () {
      testWidgets(
        'should call changeLearningLanguage when tapping non-selected language',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            createTestWidget(
              language: testLanguage,
              isSelected: false,
              overrides: [
                settingsProvider.overrideWith((ref) => mockSettingsNotifier),
                settingsStorageProvider.overrideWithValue(mockStorage),
              ],
            ),
          );

          await tester.tap(find.byType(ListTile));
          await tester.pumpAndSettle();

          verify(
            () =>
                mockSettingsNotifier.changeLearningLanguage(testLanguage.value),
          ).called(1);
        },
      );

      testWidgets(
        'should not call changeLearningLanguage when tapping selected language',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            createTestWidget(
              language: testLanguage,
              isSelected: true,
              overrides: [
                settingsProvider.overrideWith((ref) => mockSettingsNotifier),
                settingsStorageProvider.overrideWithValue(mockStorage),
              ],
            ),
          );

          final listTile = tester.widget<ListTile>(find.byType(ListTile));
          expect(listTile.onTap, isNull);
          await tester.pumpAndSettle();

          await tester.tap(find.byType(ListTile));

          verifyNever(() => mockSettingsNotifier.changeLearningLanguage(any()));
        },
      );

      testWidgets('should show edit dialog when edit button is tapped', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(language: testLanguage, isSelected: false),
        );

        await tester.tap(find.byIcon(Icons.edit));
        await tester.pumpAndSettle();

        expect(find.byType(Dialog), findsOneWidget);
        expect(find.byType(NewLanguage), findsOneWidget);
      });

      testWidgets(
        'should show delete confirmation dialog when delete button is tapped',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            createTestWidget(language: testLanguage, isSelected: false),
          );

          await tester.tap(find.byIcon(Icons.delete));
          await tester.pumpAndSettle();

          expect(find.byType(AlertDialog), findsOneWidget);
          expect(find.text('Delete Language'), findsOneWidget);
          expect(
            find.text(
              'Are you sure you want to delete Spanish and its vocabulary? This action can\'t be undone.',
            ),
            findsOneWidget,
          );
          expect(find.text('Cancel'), findsOneWidget);
          expect(find.text('Delete'), findsOneWidget);
        },
      );

      testWidgets('should close delete dialog when Cancel is tapped', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(language: testLanguage, isSelected: false),
        );

        await tester.tap(find.byIcon(Icons.delete));
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsOneWidget);

        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsNothing);
      });

      testWidgets('should call deleteLanguage when Delete is confirmed', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            language: testLanguage,
            isSelected: false,
            overrides: [
              settingsProvider.overrideWith((ref) => mockSettingsNotifier),
              notificationsProvider.overrideWith(
                (ref) => mockNotificationsNotifier,
              ),
              settingsStorageProvider.overrideWithValue(mockStorage),
            ],
          ),
        );

        await tester.tap(find.byIcon(Icons.delete));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Delete'));
        await tester.pumpAndSettle();

        verify(
          () => mockSettingsNotifier.deleteLanguage(testLanguage),
        ).called(1);
      });
    });

    group('Error Handling Tests', () {
      testWidgets('should show error notification when delete fails', (
        WidgetTester tester,
      ) async {
        when(
          () => mockSettingsNotifier.deleteLanguage(any()),
        ).thenAnswer((_) async => 'Delete failed');

        await tester.pumpWidget(
          createTestWidget(
            language: testLanguage,
            isSelected: false,
            overrides: [
              settingsProvider.overrideWith((ref) => mockSettingsNotifier),
              notificationsProvider.overrideWith(
                (ref) => mockNotificationsNotifier,
              ),
              settingsStorageProvider.overrideWithValue(mockStorage),
            ],
          ),
        );

        await tester.tap(find.byIcon(Icons.delete));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Delete'));
        await tester.pumpAndSettle();

        verify(
          () => mockNotificationsNotifier.pushNotification(any()),
        ).called(1);
      });

      testWidgets('should not show error notification when delete succeeds', (
        WidgetTester tester,
      ) async {
        when(
          () => mockSettingsNotifier.deleteLanguage(any()),
        ).thenAnswer((_) async => null);

        await tester.pumpWidget(
          createTestWidget(
            language: testLanguage,
            isSelected: false,
            overrides: [
              settingsProvider.overrideWith((ref) => mockSettingsNotifier),
              notificationsProvider.overrideWith(
                (ref) => mockNotificationsNotifier,
              ),
              settingsStorageProvider.overrideWithValue(mockStorage),
            ],
          ),
        );

        await tester.tap(find.byIcon(Icons.delete));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Delete'));
        await tester.pumpAndSettle();

        verifyNever(() => mockNotificationsNotifier.pushNotification(any()));
      });
    });
  });
}
