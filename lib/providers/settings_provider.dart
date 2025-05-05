import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsNotifier extends StateNotifier<Map> {
  SettingsNotifier() : super({'learning_language': 'english'});

  void changeLearningLanguage(String newLanguage) {
    state = {...state, 'learning_language': newLanguage};
  }

  String getLearningLanguage() {
    return state['learning_language'] as String;
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, Map>(
  (ref) => SettingsNotifier(),
);
