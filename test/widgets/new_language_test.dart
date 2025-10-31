import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:vocabulary_game/widgets/new_language.dart';
import 'package:vocabulary_game/widgets/flag_selector.dart';
import 'package:vocabulary_game/models/language.dart';
import 'package:vocabulary_game/providers/settings_provider.dart';
import 'package:vocabulary_game/storage/storage_interface.dart';

class MockStorage extends Mock implements StorageInterface {}

class MockSettingsNotifier extends Mock implements SettingsNotifier {}

void main() {
  setUpAll(() {
    // Register fallback values for mocktail
    registerFallbackValue(Language('Test', '🏳️'));
  });

  group('NewLanguage Widget Tests', () {
    late MockStorage mockStorage;
    late MockSettingsNotifier mockSettingsNotifier;

    setUp(() {
      mockStorage = MockStorage();
      mockSettingsNotifier = MockSettingsNotifier();

      // Set up default mock responses
      when(() => mockStorage.getVocabulary()).thenAnswer((_) async => []);
      when(() => mockStorage.getLanguages()).thenAnswer((_) async => []);
      when(
        () => mockStorage.getLearningLanguage(),
      ).thenAnswer((_) async => null);
      when(() => mockStorage.addLanguage(any())).thenAnswer((_) async => []);
      when(
        () => mockStorage.updateLanguage(any(), any()),
      ).thenAnswer((_) async => []);

      when(
        () => mockSettingsNotifier.addLanguage(any()),
      ).thenAnswer((_) async => null);
      when(
        () => mockSettingsNotifier.updateLanguage(any(), any()),
      ).thenAnswer((_) async => null);
    });

    Widget createTestWidget({
      Language? initialLanguage,
      List<Override>? overrides,
    }) {
      return ProviderScope(
        overrides:
            overrides ??
            [settingsStorageProvider.overrideWithValue(mockStorage)],
        child: MaterialApp(
          home: Scaffold(body: NewLanguage(initialLanguage: initialLanguage)),
        ),
      );
    }

    group('Display Tests', () {
      testWidgets('should display form elements for new language', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());

        // Should find form elements
        expect(find.byType(Form), findsOneWidget);
        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.text('Name'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
        expect(find.text('Save language'), findsOneWidget);
      });

      testWidgets('should display flag icon when no emoji is selected', (
        tester,
      ) async {
        await tester.pumpWidget(createTestWidget());

        // Should show flag icon when no emoji is selected
        expect(find.byIcon(Icons.flag_circle), findsOneWidget);
        expect(find.byType(IconButton), findsOneWidget);
      });

      testWidgets('should display emoji button when emoji is selected', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());

        // Tap flag icon to show emoji picker
        await tester.tap(find.byIcon(Icons.flag_circle));
        await tester.pumpAndSettle();

        // Should show emoji picker
        expect(find.byType(FlagSelector), findsOneWidget);
      });

      testWidgets('should populate fields when initialLanguage is provided', (
        WidgetTester tester,
      ) async {
        final testLanguage = Language('Spanish', '🇪🇸');

        await tester.pumpWidget(
          createTestWidget(initialLanguage: testLanguage),
        );

        // Should show emoji as button
        expect(find.text('🇪🇸'), findsOneWidget);
        expect(
          find.byType(TextButton),
          findsNWidgets(2),
        ); // Emoji button + Cancel button

        // Should populate name field
        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );
        expect(textField.initialValue, equals('Spanish'));
      });

      group('Form Validation Tests', () {
        testWidgets('should reject empty name', (WidgetTester tester) async {
          await tester.pumpWidget(createTestWidget());

          await tester.enterText(find.byType(TextFormField), '');
          await tester.tap(find.text('Save language'));
          await tester.pumpAndSettle();

          expect(
            find.text('Must be between 1 and 30 characters.'),
            findsOneWidget,
          );
        });

        testWidgets('should reject name with only spaces', (
          WidgetTester tester,
        ) async {
          await tester.pumpWidget(createTestWidget());

          // Test with text that would be too short after trimming (just whitespace)
          await tester.enterText(find.byType(TextFormField), '   ');
          await tester.tap(find.text('Save language'));
          await tester.pumpAndSettle();

          expect(
            find.text('Must be between 1 and 30 characters.'),
            findsOneWidget,
          );
        });

        testWidgets('should reject name that is too short', (
          WidgetTester tester,
        ) async {
          await tester.pumpWidget(createTestWidget());

          await tester.enterText(find.byType(TextFormField), 'A');
          await tester.tap(find.text('Save language'));
          await tester.pumpAndSettle();

          expect(
            find.text('Must be between 1 and 30 characters.'),
            findsOneWidget,
          );
        });

        testWidgets('should enforce max length in input decoration', (
          WidgetTester tester,
        ) async {
          await tester.pumpWidget(
            createTestWidget(
              overrides: [
                settingsProvider.overrideWith((ref) => mockSettingsNotifier),
                settingsStorageProvider.overrideWithValue(mockStorage),
              ],
            ),
          );

          await tester.enterText(
            find.byType(TextFormField),
            'A gigantic language name that exceeds the maximum length allowed',
          ); // Just spaces
          await tester.tap(find.text('Save language'));
          await tester.pumpAndSettle();

          // Should not show validation error, but call language with trimmed name
          expect(
            find.text('Must be between 1 and 30 characters.'),
            findsNothing,
          );

          // Capture and verify the arguments
          final captured =
              verify(
                () => mockSettingsNotifier.addLanguage(captureAny()),
              ).captured;
          expect(captured.length, equals(1));
          final capturedLanguage = captured.first as Language;
          expect(
            capturedLanguage.name,
            equals('A gigantic language name that '),
          ); // Trimmed to 30 chars
        });

        testWidgets('should accept valid name', (WidgetTester tester) async {
          await tester.pumpWidget(
            createTestWidget(
              overrides: [
                settingsProvider.overrideWith((ref) => mockSettingsNotifier),
                settingsStorageProvider.overrideWithValue(mockStorage),
              ],
            ),
          );

          await tester.enterText(find.byType(TextFormField), 'Spanish');
          await tester.tap(find.text('Save language'));
          await tester.pumpAndSettle();

          // Should not show validation error
          expect(
            find.text('Must be between 1 and 30 characters.'),
            findsNothing,
          );

          // Capture and verify the arguments
          final captured =
              verify(
                () => mockSettingsNotifier.addLanguage(captureAny()),
              ).captured;
          expect(captured.length, equals(1));
          final capturedLanguage = captured.first as Language;
          expect(capturedLanguage.name, equals('Spanish'));
        });
      });

      group('Emoji Selection Tests', () {
        testWidgets('should toggle emoji picker when flag icon is tapped', (
          WidgetTester tester,
        ) async {
          await tester.pumpWidget(createTestWidget());

          // Initially no emoji picker
          expect(find.byType(FlagSelector), findsNothing);

          // Tap flag icon
          await tester.tap(find.byIcon(Icons.flag_circle));
          await tester.pumpAndSettle();

          // Should show emoji picker
          expect(find.byType(FlagSelector), findsOneWidget);

          // Tap again to hide
          await tester.tap(find.byIcon(Icons.flag_circle));
          await tester.pumpAndSettle();

          // Should hide emoji picker
          expect(find.byType(FlagSelector), findsNothing);
        });

        testWidgets('should toggle emoji picker when emoji button is tapped', (
          WidgetTester tester,
        ) async {
          final testLanguage = Language('Spanish', '🇪🇸');

          await tester.pumpWidget(
            createTestWidget(initialLanguage: testLanguage),
          );

          // Should show emoji button
          expect(find.text('🇪🇸'), findsOneWidget);
          expect(find.byType(FlagSelector), findsNothing);

          // Tap emoji button
          await tester.tap(find.text('🇪🇸'));
          await tester.pumpAndSettle();

          // Should show emoji picker
          expect(find.byType(FlagSelector), findsOneWidget);
        });

        testWidgets('should update emoji when selected from picker', (
          WidgetTester tester,
        ) async {
          await tester.pumpWidget(createTestWidget());

          // Tap flag icon to show picker
          await tester.tap(find.byIcon(Icons.flag_circle));
          await tester.pumpAndSettle();

          // Find FlagSelector and simulate emoji selection
          final flagSelector = tester.widget<FlagSelector>(
            find.byType(FlagSelector),
          );

          // Simulate emoji selection by calling the callback directly
          const testEmoji = Emoji('🇫🇷', 'flag-fr');
          flagSelector.onEmojiSelected(testEmoji);
          await tester.pumpAndSettle();

          // Should show the selected emoji
          expect(find.text('🇫🇷'), findsOneWidget);
          expect(
            find.byType(FlagSelector),
            findsNothing,
          ); // Picker should close
        });
      });

      group('Save Functionality Tests', () {
        testWidgets('should call addLanguage when creating new language', (
          WidgetTester tester,
        ) async {
          await tester.pumpWidget(
            createTestWidget(
              overrides: [
                settingsProvider.overrideWith((ref) => mockSettingsNotifier),
                settingsStorageProvider.overrideWithValue(mockStorage),
              ],
            ),
          );

          // Enter language data
          await tester.enterText(find.byType(TextFormField), 'French');

          // Select emoji
          await tester.tap(find.byIcon(Icons.flag_circle));
          await tester.pumpAndSettle();
          final flagSelector = tester.widget<FlagSelector>(
            find.byType(FlagSelector),
          );
          flagSelector.onEmojiSelected(const Emoji('🇫🇷', 'flag-fr'));
          await tester.pumpAndSettle();

          // Save
          await tester.tap(find.text('Save language'));
          await tester.pumpAndSettle();

          // Capture and verify the arguments
          final captured =
              verify(
                () => mockSettingsNotifier.addLanguage(captureAny()),
              ).captured;
          expect(captured.length, equals(1));
          final capturedLanguage = captured.first as Language;
          expect(capturedLanguage.name, equals('French'));
          expect(capturedLanguage.icon, equals('🇫🇷'));
        });

        testWidgets(
          'should call updateLanguage when editing existing language',
          (WidgetTester tester) async {
            final initialLanguage = Language('Spanish', '🇪🇸');

            await tester.pumpWidget(
              createTestWidget(
                initialLanguage: initialLanguage,
                overrides: [
                  settingsProvider.overrideWith((ref) => mockSettingsNotifier),
                  settingsStorageProvider.overrideWithValue(mockStorage),
                ],
              ),
            );

            // Modify language name
            await tester.enterText(find.byType(TextFormField), 'Español');

            // Select emoji
            await tester.tap(find.text('🇪🇸'));
            await tester.pumpAndSettle();
            final flagSelector = tester.widget<FlagSelector>(
              find.byType(FlagSelector),
            );
            flagSelector.onEmojiSelected(const Emoji('🇦🇷', 'flag-ar'));
            await tester.pumpAndSettle();

            // Save
            await tester.tap(find.text('Save language'));
            await tester.pumpAndSettle();

            // Capture and verify the arguments
            final captured =
                verify(
                  () => mockSettingsNotifier.updateLanguage(
                    captureAny(),
                    captureAny(),
                  ),
                ).captured;
            expect(captured.length, equals(2));
            final capturedOldLanguage = captured[0] as Language;
            final capturedNewLanguage = captured[1] as Language;

            // Verify old language (should be unchanged)
            expect(capturedOldLanguage.name, equals('Spanish'));
            expect(capturedOldLanguage.icon, equals('🇪🇸'));

            // Verify new language (should have updated name)
            expect(capturedNewLanguage.name, equals('Español'));
            expect(capturedNewLanguage.icon, equals('🇦🇷'));
          },
        );

        testWidgets('should close dialog on successful save', (
          WidgetTester tester,
        ) async {
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                settingsProvider.overrideWith((ref) => mockSettingsNotifier),
                settingsStorageProvider.overrideWithValue(mockStorage),
              ],
              child: MaterialApp(
                home: Scaffold(
                  body: Builder(
                    builder:
                        (context) => ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => Dialog(child: NewLanguage()),
                            );
                          },
                          child: Text('Open Dialog'),
                        ),
                  ),
                ),
              ),
            ),
          );

          // Open dialog
          await tester.tap(find.text('Open Dialog'));
          await tester.pumpAndSettle();

          // Enter valid data and save
          await tester.enterText(find.byType(TextFormField), 'German');
          await tester.tap(find.text('Save language'));
          await tester.pumpAndSettle();

          // Dialog should be closed
          expect(find.byType(NewLanguage), findsNothing);
        });

        testWidgets(
          'should show error message when save fails and clear it when form is successfully saved',
          (WidgetTester tester) async {
            // First call returns error, second call succeeds
            when(
              () => mockSettingsNotifier.addLanguage(any()),
            ).thenAnswer((_) async => 'Language already exists');

            await tester.pumpWidget(
              createTestWidget(
                overrides: [
                  settingsProvider.overrideWith((ref) => mockSettingsNotifier),
                  settingsStorageProvider.overrideWithValue(mockStorage),
                ],
              ),
            );

            // Trigger error
            await tester.enterText(find.byType(TextFormField), 'Spanish');
            await tester.tap(find.text('Save language'));
            await tester.pumpAndSettle();

            expect(find.text('Language already exists'), findsOneWidget);

            // Mock successful save for next attempt
            when(
              () => mockSettingsNotifier.addLanguage(any()),
            ).thenAnswer((_) async => null);

            // Try to save again with different name
            await tester.enterText(find.byType(TextFormField), 'French');
            await tester.tap(find.text('Save language'));
            await tester.pumpAndSettle();

            // Error should be cleared after successful save
            expect(find.text('Language already exists'), findsNothing);
          },
        );
      });

      group('Cancel Functionality Tests', () {
        testWidgets('should close dialog when Cancel is tapped', (
          WidgetTester tester,
        ) async {
          await tester.pumpWidget(
            ProviderScope(
              child: MaterialApp(
                home: Scaffold(
                  body: Builder(
                    builder:
                        (context) => ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => Dialog(child: NewLanguage()),
                            );
                          },
                          child: Text('Open Dialog'),
                        ),
                  ),
                ),
              ),
            ),
          );

          // Open dialog
          await tester.tap(find.text('Open Dialog'));
          await tester.pumpAndSettle();

          // Tap Cancel
          await tester.tap(find.text('Cancel'));
          await tester.pumpAndSettle();

          // Dialog should be closed
          expect(find.byType(NewLanguage), findsNothing);
        });
      });

      testWidgets('should disable buttons when saving', (
        WidgetTester tester,
      ) async {
        // Set up a delayed response to simulate loading
        when(() => mockSettingsNotifier.addLanguage(any())).thenAnswer(
          (_) => Future.delayed(Duration(milliseconds: 50), () => null),
        );

        await tester.pumpWidget(
          createTestWidget(
            overrides: [
              settingsProvider.overrideWith((ref) => mockSettingsNotifier),
              settingsStorageProvider.overrideWithValue(mockStorage),
            ],
          ),
        );

        // Enter valid data
        await tester.enterText(find.byType(TextFormField), 'Spanish');
        await tester.tap(find.text('Save language'));
        await tester.pump(); // Don't settle, we want to check loading state

        // Show loading indicator
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Save language'), findsNothing);

        // Both buttons should be disabled
        final cancelButton = tester.widget<TextButton>(
          find.widgetWithText(TextButton, 'Cancel'),
        );
        final saveButton = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );

        expect(cancelButton.onPressed, isNull);
        expect(saveButton.onPressed, isNull);

        // Complete the async operation
        await tester.pumpAndSettle();
      });
    });
  });
}
