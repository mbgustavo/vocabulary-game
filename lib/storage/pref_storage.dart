import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocabulary_game/models/word.dart';
import 'package:vocabulary_game/storage/storage_interface.dart';
import 'package:vocabulary_game/models/language.dart';

class PrefStorage extends StorageInterface {
  SharedPreferences? _pref;

  Language _mapToLanguage(dynamic language) =>
      Language(language['name']!, language['icon']!);

  Word _mapToWord(dynamic word) =>
      Word(word['language']!, word['input']!, word['translation']!, examples: word['examples'], level: word['level']);

  Map<String, String> _languageToMap(Language language) => {
    'name': language.name,
    'icon': language.icon,
  };

  Future<void> _initialize() async {
    _pref = await SharedPreferences.getInstance();
  }

  @override
  Future<List<Language>> getLanguages() async {
    if (_pref == null) {
      await _initialize();
    }

    final languagesJson = _pref!.getString('languages');
    final languagesMap =
        ((languagesJson != null ? jsonDecode(languagesJson) : [])
            as List<dynamic>);
    return languagesMap.map(_mapToLanguage).toList();
  }

  @override
  Future<List<Language>> addLanguage(Language language) async {
    if (_pref == null) {
      await _initialize();
    }
    final currentLanguages = await getLanguages();
    currentLanguages.add(language);
    await _pref!.setString(
      'languages',
      jsonEncode(currentLanguages.map(_languageToMap).toList()),
    );

    return currentLanguages;
  }

  @override
  Future<List<Language>> deleteLanguage(Language language) async {
    if (_pref == null) {
      await _initialize();
    }

    final currentLanguages = await getLanguages();
    final remainingLanguages =
        currentLanguages.where((l) => l.value != language.value).toList();

    await _pref!.setString(
      'languages',
      jsonEncode(remainingLanguages.map(_languageToMap).toList()),
    );

    return remainingLanguages;
  }

  @override
  Future<String?> getLearningLanguage() async {
    if (_pref == null) {
      await _initialize();
    }

    return _pref!.getString('learning_language');
  }

  @override
  Future<void> setLearningLanguage(String newLanguage) async {
    if (_pref == null) {
      await _initialize();
    }

    await _pref!.setString('learning_language', newLanguage);
  }

  @override
  Future<List<Word>> getVocabulary() async {
    if (_pref == null) {
      await _initialize();
    }

    final vocabularyJson = _pref!.getString('vocabulary');
    final vocabularyMap =
        ((vocabularyJson != null ? jsonDecode(vocabularyJson) : [])
            as List<dynamic>);
    return vocabularyMap.map(_mapToWord).toList();
  }
}
