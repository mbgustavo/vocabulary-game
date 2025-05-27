import 'package:vocabulary_game/models/language.dart';

abstract class StorageInterface {
  // Get all languages from data storage
  Future<List<Language>> getLanguages();

  // Add language to data storage and return updated list of languages
  Future<List<Language>> addLanguage(Language language);

  // Add language from data storage and return updated list of languages
  Future<List<Language>> deleteLanguage(Language language);

  // Get the current learning language value from storage
  Future<String?> getLearningLanguage();

  // Set the current learning language value from storage
  Future<void> setLearningLanguage(String newLanguage);
}