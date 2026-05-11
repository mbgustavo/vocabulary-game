import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vocabulary_game/models/settings.dart';
import 'package:vocabulary_game/providers/notifications_provider.dart';
import 'package:vocabulary_game/providers/settings_provider.dart';
import 'package:vocabulary_game/storage/pref_storage.dart';
import 'package:vocabulary_game/storage/storage_interface.dart';

// Mock classes
class MockStorageInterface extends Mock implements StorageInterface {}

class MockNotificationsNotifier extends Mock implements NotificationsNotifier {}

void main() {
  late ProviderContainer container;
  late MockStorageInterface mockStorage;
  late MockNotificationsNotifier mockNotificationsNotifier;

  setUpAll(() {
    registerFallbackValue(CustomNotification('dummy'));
  });

  setUp(() async {
    mockStorage = MockStorageInterface();
    mockNotificationsNotifier = MockNotificationsNotifier();

    // Set up default mocks
    when(() => mockStorage.getSettings()).thenAnswer((_) async => null);

    container = ProviderContainer(
      overrides: [
        storageProvider.overrideWithValue(mockStorage),
        notificationsProvider.overrideWith((ref) => mockNotificationsNotifier),
      ],
    );

    // Run the initial loadSettings
    await Future.microtask(() {});
  });

  tearDown(() {
    container.dispose();
    resetMocktailState();
  });

  group('SettingsNotifier', () {
    test('loadSettings should load settings successfully', () async {
      final testSettings = AppSettings(
        wordOfTheMomentSettings: WordOfTheMomentSettings(
          notificationsEnabled: true,
        ),
      );

      when(
        () => mockStorage.getSettings(),
      ).thenAnswer((_) async => testSettings);

      final notifier = container.read(settingsProvider.notifier);
      await notifier.loadSettings();

      final state = container.read(settingsProvider);
      expect(state['loading'], false);
      expect(state['settings'], testSettings);
    });

    test(
      'loadSettings should use default settings if storage returns null',
      () async {
        when(() => mockStorage.getSettings()).thenAnswer((_) async => null);

        final notifier = container.read(settingsProvider.notifier);
        await notifier.loadSettings();

        final state = container.read(settingsProvider);
        expect(state['loading'], false);
        expect(state['settings'], defaultSettings);
      },
    );

    test('getSettings should return default settings if not loaded', () {
      final notifier = container.read(settingsProvider.notifier);
      final settings = notifier.getSettings();
      expect(settings, defaultSettings);
    });

    test('saveSettings should save successfully', () async {
      final testSettings = AppSettings(
        wordOfTheMomentSettings: WordOfTheMomentSettings(
          notificationsEnabled: true,
        ),
      );

      when(
        () => mockStorage.saveSettings(testSettings),
      ).thenAnswer((_) async {});

      final notifier = container.read(settingsProvider.notifier);
      final result = await notifier.saveSettings(testSettings);

      expect(result, null);
      final state = container.read(settingsProvider);
      expect(state['settings'], testSettings);

      verify(() => mockStorage.saveSettings(testSettings)).called(1);
    });

    test('saveSettings should return error on failure', () async {
      final testSettings = AppSettings(
        wordOfTheMomentSettings: WordOfTheMomentSettings(
          notificationsEnabled: true,
        ),
      );
      final error = Exception('Save error');

      when(() => mockStorage.saveSettings(testSettings)).thenThrow(error);

      final notifier = container.read(settingsProvider.notifier);
      final result = await notifier.saveSettings(testSettings);

      expect(result, error.toString());
      final state = container.read(settingsProvider);
      expect(state['settings'], isNot(testSettings));

      verify(() => mockStorage.saveSettings(testSettings)).called(1);
    });
  });
}
