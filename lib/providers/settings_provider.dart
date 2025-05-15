import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocabulary_game/models/language.dart';
import 'package:vocabulary_game/providers/notifications_provider.dart';

class SettingsNotifier extends StateNotifier<Map<String, dynamic>> {
  SettingsNotifier(this.ref) : super({}) {
    loadLanguages();
  }

  final Ref ref;
  late SharedPreferences _pref;
  int? _loadingErrorNotification;

  Map<String, String> languageToMap(Language language) => {
    'name': language.name,
    'icon': language.icon,
  };

  Language mapToLanguage(dynamic language) =>
      Language(language['name']!, language['icon']!);

  Future<void> loadLanguages() async {
    try {
      _pref = await SharedPreferences.getInstance();
      final languagesJson = _pref.getString('languages');
      final languagesMap =
          ((languagesJson != null ? jsonDecode(languagesJson) : [])
              as List<dynamic>);
      final languages = languagesMap.map(mapToLanguage).toList();
      if (languages.isEmpty) {
        state = {
          ...state,
          'languages': [defaultLanguage],
          'learning_language': defaultLanguage.value,
        };
        return;
      } else {
        final learningLanguage =
            _pref.getString('learning_language') ?? languages[0].value;
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
    }
  }

  List<Language> getLanguages() {
    return (state['languages'] ?? []) as List<Language>;
  }

  Future<String?> addLanguage(Language newLanguage) async {
    try {
      List<Language> currentLanguages = [...getLanguages()];
      final conflictingLanguages = currentLanguages.where(
        (language) => language.value == newLanguage.value,
      );
      if (conflictingLanguages.isNotEmpty) {
        return 'Language already exists';
      }

      currentLanguages.add(newLanguage);
      await _pref.setString(
        'languages',
        jsonEncode(currentLanguages.map(languageToMap).toList()),
      );
      state = {...state, 'languages': currentLanguages};
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> deleteLanguage(Language language) async {
    try {
      final remainingLanguages =
          getLanguages().where((l) => l.value != language.value).toList();

      await _pref.setString(
        'languages',
        jsonEncode(remainingLanguages.map(languageToMap).toList()),
      );
      state = {...state, 'languages': remainingLanguages};
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> changeLearningLanguage(String newLanguage) async {
    await _pref.setString('learning_language', newLanguage);
    state = {...state, 'learning_language': newLanguage};
  }

  Language getLearningLanguage() {
    final languages = state['languages'] as List<Language>;
    return languages.firstWhere(
      (language) => language.value == state['learning_language'],
      orElse: () => defaultLanguage,
    );
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, Map>(
  (ref) => SettingsNotifier(ref),
);
