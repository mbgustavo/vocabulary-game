import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocabulary_game/models/word.dart';
import 'package:vocabulary_game/storage/storage_interface.dart';
import 'package:vocabulary_game/models/language.dart';

class PrefStorage extends StorageInterface {
  SharedPreferences? _pref;

  Language _mapToLanguage(dynamic language) =>
      Language(language['name']!, language['icon']!);

  Word _mapToWord(dynamic word) {
    WordLevel level;
    try {
      level = WordLevel.values.byName(word['level'] ?? 'beginner');
    } catch (e) {
      level = WordLevel.beginner; // Default to beginner if parsing fails
    }

    return Word(
      language: word['language']!,
      input: word['input']!,
      translation: word['translation']!,
      examples: List<String>.from(word['examples'] ?? []),
      level: level,
      id: word['id'],
    );
  }

  Map<String, String> _languageToMap(Language language) => {
    'name': language.name,
    'icon': language.icon,
  };

  Map<String, dynamic> _wordToMap(Word word) => {
    'language': word.language,
    'input': word.input,
    'translation': word.translation,
    'examples': word.examples,
    'level': word.level.name,
    'id': word.id,
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
  Future<List<Language>> updateLanguage(
    Language oldLanguage,
    Language newLanguage,
  ) async {
    if (_pref == null) {
      await _initialize();
    }

    final currentLanguages = await getLanguages();
    final index = currentLanguages.indexWhere(
      (l) => l.value == oldLanguage.value,
    );

    if (index == -1) {
      throw Exception('Language not found: ${oldLanguage.value}');
    }
    currentLanguages[index] = newLanguage;

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

  @override
  Future<List<Word>> saveWord(Word word) async {
    if (_pref == null) {
      await _initialize();
    }

    final vocabulary = await getVocabulary();
    final existingIndex = vocabulary.indexWhere((w) => w.id == word.id);

    if (existingIndex != -1) {
      vocabulary[existingIndex] = word; // Update existing word
    } else {
      vocabulary.add(word); // Add new word
    }

    await _pref!.setString(
      'vocabulary',
      jsonEncode(vocabulary.map(_wordToMap).toList()),
    );

    return vocabulary;
  }

  @override
  Future<List<Word>> updateWordsLanguage(
    String oldLanguage,
    String newLanguage,
  ) async {
    if (_pref == null) {
      await _initialize();
    }

    final currentVocabulary = await getVocabulary();
    final updatedVocabulary =
        currentVocabulary.map((word) {
          if (word.language == oldLanguage) {
            word = Word(
              input: word.input,
              translation: word.translation,
              examples: word.examples,
              level: word.level,
              id: word.id,
              language: newLanguage,
            );
          }
          return word;
        }).toList();

    await _pref!.setString(
      'vocabulary',
      jsonEncode(updatedVocabulary.map(_wordToMap).toList()),
    );
    return updatedVocabulary;
  }

  @override
  Future<List<Word>> deleteWord(Word word) async {
    if (_pref == null) {
      await _initialize();
    }

    final currentVocabulary = await getVocabulary();
    final remainingVocabulary =
        currentVocabulary.where((w) => w.id != word.id).toList();

    await _pref!.setString(
      'vocabulary',
      jsonEncode(remainingVocabulary.map(_wordToMap).toList()),
    );

    return remainingVocabulary;
  }

  @override
  Future<List<Word>> deleteWordsByLanguage(String language) async {
    if (_pref == null) {
      await _initialize();
    }

    final currentVocabulary = await getVocabulary();
    final remainingVocabulary =
        currentVocabulary.where((w) => w.language != language).toList();

    await _pref!.setString(
      'vocabulary',
      jsonEncode(remainingVocabulary.map(_wordToMap).toList()),
    );

    return remainingVocabulary;
  }
}
