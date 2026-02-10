import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocabulary_game/models/word.dart';
import 'package:vocabulary_game/storage/storage_interface.dart';
import 'package:vocabulary_game/models/language.dart';

class PrefStorage implements StorageInterface {
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

  /// Creates a backup of all shared preferences data to the specified file path
  @override
  Future<void> restoreDefaults() async {
    if (_pref == null) {
      await _initialize();
    }

    await _pref!.clear();

    addLanguage(defaultLanguage);
    setLearningLanguage(defaultLanguage.value);
  }

  /// Creates a backup of all shared preferences data to the specified file path
  @override
  Future<void> createBackup(String filePath) async {
    if (_pref == null) {
      await _initialize();
    }

    // Get all keys from shared preferences
    final allKeys = _pref!.getKeys();
    final backupData = <String, dynamic>{};

    // Extract all data from shared preferences
    for (final key in allKeys) {
      final value = _pref!.get(key);
      backupData[key] = value;
    }

    // Get app version dynamically
    final packageInfo = await PackageInfo.fromPlatform();
    
    // Add metadata to the backup
    final backupWithMetadata = {
      'backup_timestamp': DateTime.now().toIso8601String(),
      'backup_version': '1.0',
      'app_version': packageInfo.version,
      'data': backupData,
    };

    // Convert to JSON
    final jsonString = jsonEncode(backupWithMetadata);

    // Create the backup file at the specified path
    final backupFile = File(filePath);
    
    // Create directory if it doesn't exist
    final directory = backupFile.parent;
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    // Write the backup file
    await backupFile.writeAsString(jsonString);
  }

  /// Restores data from a backup file
  @override
  Future<void> restoreFromBackup(String filePath) async {
    try {
      if (_pref == null) {
        await _initialize();
      }

      // Read the backup file
      final backupFile = File(filePath);
      if (!await backupFile.exists()) {
        throw Exception('Backup file does not exist: $filePath');
      }

      final jsonString = await backupFile.readAsString();
      final backupData = jsonDecode(jsonString) as Map<String, dynamic>;

      // Validate backup structure
      if (!backupData.containsKey('data')) {
        throw Exception('Invalid backup file format');
      }

      final data = backupData['data'] as Map<String, dynamic>;

      // Clear existing preferences (optional - you might want to prompt user)
      await _pref!.clear();

      // Restore all data
      for (final entry in data.entries) {
        final key = entry.key;
        final value = entry.value;

        // Handle different data types
        if (value is String) {
          await _pref!.setString(key, value);
        } else if (value is int) {
          await _pref!.setInt(key, value);
        } else if (value is double) {
          await _pref!.setDouble(key, value);
        } else if (value is bool) {
          await _pref!.setBool(key, value);
        } else if (value is List<String>) {
          await _pref!.setStringList(key, value);
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

final storageProvider = Provider<StorageInterface>((ref) => PrefStorage());