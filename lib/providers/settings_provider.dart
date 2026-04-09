import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocabulary_game/models/settings.dart';
import 'package:vocabulary_game/storage/storage_interface.dart';
import 'package:vocabulary_game/storage/pref_storage.dart';
import 'package:vocabulary_game/providers/notifications_provider.dart';

class SettingsNotifier extends StateNotifier<Map<String, dynamic>> {
  SettingsNotifier(this.ref) : super({}) {
    _storage = ref.read(storageProvider);
    state = {'loading': true};
    Future.microtask(() => loadSettings());
  }

  final Ref ref;
  late StorageInterface _storage;
  int? _loadingErrorNotification;

  Future<void> loadSettings() async {
    try {
      AppSettings settings = await _storage.getSettings() ?? defaultSettings;
      state = {...state, 'settings': settings};

      if (_loadingErrorNotification != null) {
        ref
            .read(notificationsProvider.notifier)
            .dismissNotification(_loadingErrorNotification!);
        _loadingErrorNotification = null;
      }
    } catch (e) {
      ref.read(notificationsProvider.notifier).clearNotifications();
      _loadingErrorNotification = ref
          .read(notificationsProvider.notifier)
          .pushNotification(
            CustomNotification(
              'Failed to load settings: ${e.toString()}',
              type: NotificationType.error,
              isDismissable: false,
            ),
          );
    } finally {
      state = {...state, 'loading': false};
    }
  }

  AppSettings getSettings({String? language}) =>
      state['settings'] as AppSettings? ?? defaultSettings;

  Future<String?> saveSettings(AppSettings settings) async {
    try {
      await _storage.saveSettings(settings);
      state = {...state, 'settings': settings};
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, Map>(
  (ref) => SettingsNotifier(ref),
);
