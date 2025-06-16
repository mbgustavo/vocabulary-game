import 'package:vocabulary_game/models/language.dart';
import 'package:vocabulary_game/models/word.dart';

abstract class StorageInterface {
  // Get all languages from data storage
  Future<List<Language>> getLanguages();

  // Add language to data storage and return updated list of languages
  Future<List<Language>> addLanguage(Language language);

  // Update language in data storage and return updated list of languages
  Future<List<Language>> updateLanguage(Language oldLanguage, Language newlanguage);

  // Add language from data storage and return updated list of languages
  Future<List<Language>> deleteLanguage(Language language);

  // Get the current learning language value from storage
  Future<String?> getLearningLanguage();

  // Set the current learning language value from storage
  Future<void> setLearningLanguage(String newLanguage);

  // Get all vocabulary
  Future<List<Word>> getVocabulary();

  // Add or update word and return updated vocabulary
  Future<List<Word>> saveWord(Word word);

  // Update all words with the old language to the new language and return updated vocabulary
  Future<List<Word>> updateWordsLanguage(String oldLanguage, String newLanguage);

  // Add or update word and return updated vocabulary
  Future<List<Word>> deleteWord(Word word);

  // Delete all vocabulary words by language and return updated vocabulary
  Future<List<Word>> deleteWordsByLanguage(String language);
}