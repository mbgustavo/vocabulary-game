import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocabulary_game/models/language.dart';
import 'package:vocabulary_game/models/settings.dart';
import 'package:vocabulary_game/models/word.dart';
import 'package:vocabulary_game/providers/languages_provider.dart';
import 'package:vocabulary_game/providers/settings_provider.dart';
import 'package:vocabulary_game/providers/vocabulary_provider.dart';
import 'package:vocabulary_game/screens/word_of_the_moment.dart';
import 'package:vocabulary_game/utils/platform_info.dart';
import '../helpers/test_app_wrapper.dart';

class FakeSettingsNotifier extends SettingsNotifier {
  FakeSettingsNotifier(super.ref, AppSettings initialSettings) {
    state = {'loading': false, 'settings': initialSettings};
  }

  @override
  Future<void> loadSettings() async {
    // Prevent the default async storage read during tests.
  }

  @override
  Future<String?> saveSettings(AppSettings settings) async {
    state = {...state, 'settings': settings};
    return null;
  }
}

class FakeLanguagesNotifier extends LanguagesNotifier {
  FakeLanguagesNotifier(super.ref, Language language) {
    state = {
      'loading': false,
      'app_language': 'en',
      'languages': [language],
      'learning_language': language.value,
    };
  }

  @override
  Future<void> loadLanguages() async {
    // Prevent the default async storage read during tests.
  }
}

class FakeVocabularyNotifier extends VocabularyNotifier {
  FakeVocabularyNotifier(super.ref, List<Word> vocabulary) {
    state = {'loading': false, 'vocabulary': vocabulary};
  }

  @override
  Future<void> loadVocabulary() async {
    // Prevent the default async storage read during tests.
  }
}

class FakeAndroidPlatformInfo implements PlatformInfo {
  @override
  bool get isAndroid => true;

  @override
  bool get isIOS => false;
}

class FakeDesktopPlatformInfo implements PlatformInfo {
  @override
  bool get isAndroid => false;

  @override
  bool get isIOS => false;
}

void main() {
  final testLanguage = Language('Spanish', '🇪🇸');
  final testWord = Word(
    language: testLanguage.value,
    input: 'Hello',
    translation: 'Hola',
    level: WordLevel.beginner,
  );

  Widget createTestWidget({
    AppSettings? settings,
    List<Word>? vocabulary,
    Language? language,
  }) {
    return ProviderScope(
      overrides: [
        settingsProvider.overrideWith(
          (ref) => FakeSettingsNotifier(ref, settings ?? defaultSettings),
        ),
        languagesProvider.overrideWith(
          (ref) => FakeLanguagesNotifier(ref, language ?? testLanguage),
        ),
        vocabularyProvider.overrideWith(
          (ref) => FakeVocabularyNotifier(ref, vocabulary ?? [testWord]),
        ),
      ],
      child: createTestAppWrapper(child: const WordOfTheMomentScreen()),
    );
  }

  setUp(() {
    platformInfo = FakeAndroidPlatformInfo();
  });

  tearDown(() {
    platformInfo = SystemPlatformInfo();
  });

  group('WordOfTheMomentScreen', () {
    testWidgets('renders selected word and base controls', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Word Of The Moment'), findsOneWidget);
      expect(find.text('Hello - Hola'), findsOneWidget);
      expect(find.text('Level: Beginner'), findsOneWidget);
      expect(find.text('Generate new word'), findsOneWidget);
      expect(find.text('Vocabulary scope'), findsOneWidget);
      expect(
        find.text('Learning language only (${testLanguage.name})'),
        findsOneWidget,
      );
      expect(find.text('Whole vocabulary'), findsOneWidget);
      expect(find.text('Use custom weights for word levels'), findsOneWidget);
      expect(
        find.text('Enable Word of the Moment notifications'),
        findsOneWidget,
      );
    });

    testWidgets('shows custom weight controls after switch is enabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final customWeightsSwitch = find.descendant(
        of: find.widgetWithText(ListTile, 'Use custom weights for word levels'),
        matching: find.byWidgetPredicate((widget) => widget is Switch),
      );
      expect(customWeightsSwitch, findsOneWidget);
      expect(find.text('Beginner'), findsNothing);

      await tester.tap(customWeightsSwitch);
      await tester.pumpAndSettle();

      expect(find.text('Beginner'), findsOneWidget);
      expect(find.text('Intermediate'), findsOneWidget);
      expect(find.text('Advanced'), findsOneWidget);
      expect(find.byIcon(Icons.remove), findsNWidgets(3));
      expect(find.byIcon(Icons.add), findsNWidgets(3));
    });

    testWidgets('shows notification interval and start time when enabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final notificationsSwitch = find.descendant(
        of: find.widgetWithText(
          ListTile,
          'Enable Word of the Moment notifications',
        ),
        matching: find.byWidgetPredicate((widget) => widget is Switch),
      );
      expect(notificationsSwitch, findsOneWidget);
      expect(find.text('Interval'), findsNothing);
      expect(find.text('Start time'), findsNothing);

      await tester.tap(notificationsSwitch);
      await tester.pumpAndSettle();

      expect(find.text('Interval'), findsOneWidget);
      expect(find.text('Start time'), findsOneWidget);
      expect(find.text('Pick time'), findsOneWidget);
    });

    testWidgets('opens time picker and updates the selected time', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(
        find.descendant(
          of: find.widgetWithText(
            ListTile,
            'Enable Word of the Moment notifications',
          ),
          matching: find.byWidgetPredicate((widget) => widget is Switch),
        ),
      );
      await tester.pumpAndSettle();

      final pickTimeButton = find.widgetWithText(ElevatedButton, 'Pick time');
      expect(pickTimeButton, findsOneWidget);

      await tester.ensureVisible(pickTimeButton);
      await tester.pumpAndSettle();
      await tester.tap(pickTimeButton);
      await tester.pumpAndSettle();

      expect(find.text('OK'), findsOneWidget);

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(find.text('Pick time'), findsNothing);
      expect(find.textContaining(':'), findsWidgets);
    });

    testWidgets('updates interval type when dropdown value changes', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(
        find.descendant(
          of: find.widgetWithText(
            ListTile,
            'Enable Word of the Moment notifications',
          ),
          matching: find.byWidgetPredicate((widget) => widget is Switch),
        ),
      );
      await tester.pumpAndSettle();

      final dropdownFinder = find.byType(DropdownButtonFormField<IntervalType>);
      await tester.ensureVisible(dropdownFinder);
      await tester.pumpAndSettle();

      await tester.tap(dropdownFinder);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Days').last);
      await tester.pumpAndSettle();

      expect(find.text('Days'), findsWidgets);
    });

    testWidgets(
      'notifications options do not appear on unsupported platforms',
      (WidgetTester tester) async {
        platformInfo =
            FakeDesktopPlatformInfo(); // Simulate unsupported platform
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(
          find.descendant(
            of: find.widgetWithText(
              ListTile,
              'Enable Word of the Moment notifications',
            ),
            matching: find.byWidgetPredicate((widget) => widget is Switch),
          ),
          findsNothing,
        );
      },
    );
  });
}
