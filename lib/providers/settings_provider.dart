import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocabulary_game/storage/storage_interface.dart';
import 'package:vocabulary_game/storage/pref_storage.dart';
import 'package:vocabulary_game/models/language.dart';
import 'package:vocabulary_game/providers/notifications_provider.dart';

class SettingsNotifier extends StateNotifier<Map<String, dynamic>> {
  SettingsNotifier(this.ref) : super({}) {
    _storage = PrefStorage();
    state = {'loading': true};
    loadLanguages();
  }

  final Ref ref;
  late StorageInterface _storage;
  int? _loadingErrorNotification;

  Future<void> loadLanguages() async {
    try {
      final languages = await _storage.getLanguages();
      if (languages.isEmpty) {
        state = {
          ...state,
          'languages': [defaultLanguage],
          'learning_language': defaultLanguage.value,
        };
        addLanguage(defaultLanguage);
        return;
      } else {
        final learningLanguage =
            await _storage.getLearningLanguage() ?? languages[0].value;
        state = {
          ...state,
          'languages': languages,
          'learning_language': learningLanguage,
        };
      }

      if (_loadingErrorNotification != null) {
        ref.read(notificationsProvider.notifier).dismissNotification(_loadingErrorNotification!);
        _loadingErrorNotification = null;
      }
    } catch (e) {
      ref.read(notificationsProvider.notifier).clearNotifications();
      _loadingErrorNotification = ref
          .read(notificationsProvider.notifier)
          .pushNotification(
            CustomNotification(
              'Failed to load languages: ${e.toString()}',
              type: NotificationType.error,
              isDismissable: false,
            ),
          );
    } finally {
      state = {...state, 'loading': false};
    }
  }

  List<Language> getLanguages() {
    return (state['languages'] ?? []) as List<Language>;
  }

  Future<String?> addLanguage(Language newLanguage) async {
    try {
      if (newLanguage.name == "") {
        throw 'Language name cannot be empty';
      }

      List<Language> currentLanguages = [...getLanguages()];
      final conflictingLanguages = currentLanguages.where(
        (language) => language.value == newLanguage.value,
      );
      if (conflictingLanguages.isNotEmpty) {
        throw 'Language already exists';
      }

      final newLanguages = await _storage.addLanguage(newLanguage);
      state = {...state, 'languages': newLanguages};
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> deleteLanguage(Language language) async {
    try {
      final remainingLanguages = await _storage.deleteLanguage(language);
      state = {...state, 'languages': remainingLanguages};
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> changeLearningLanguage(String newLanguage) async {
    try {
      _storage.setLearningLanguage(newLanguage);
      state = {...state, 'learning_language': newLanguage};
    } catch (e) {
      ref.read(notificationsProvider.notifier).pushNotification(
        CustomNotification(
          'Failed to change learning language: ${e.toString()}',
          type: NotificationType.error,
          isDismissable: true,
        ),
      );
    }
  }

  Language getLearningLanguage() {
    final languages = state['languages'] as List<Language>;
    return languages.firstWhere(
      (language) => language.value == state['learning_language'],
      orElse: () => defaultLanguage,
    );
  }

  Language getLanguage(String language) {
    final languages = state['languages'] as List<Language>;
    return languages.firstWhere(
      (l) => l.value == language,
      orElse: () => defaultLanguage,
    );
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, Map>(
  (ref) => SettingsNotifier(ref),
);
