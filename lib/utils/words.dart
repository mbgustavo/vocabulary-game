import 'package:vocabulary_game/models/language.dart';
import 'package:vocabulary_game/models/word.dart';

const defaultWordLevelWeights = {
  WordLevel.beginner: 5,
  WordLevel.intermediate: 3,
  WordLevel.advanced: 1,
};

// Try to fill all words with beginner level words first,
// then intermediate, and finally advanced words if needed.
List<Word> getWordsForGame(List<Word> vocabulary, int wordsQty) {
  final playableWords =
      vocabulary.where((word) => word.level == WordLevel.beginner).toList();

  if (playableWords.length < wordsQty) {
    final intermediateWords =
        vocabulary
            .where((word) => word.level == WordLevel.intermediate)
            .toList();
    intermediateWords.shuffle();
    playableWords.addAll(
      intermediateWords.take(wordsQty - playableWords.length),
    );
  }

  if (playableWords.length < wordsQty) {
    final advancedWords =
        vocabulary.where((word) => word.level == WordLevel.advanced).toList();
    advancedWords.shuffle();
    playableWords.addAll(advancedWords.take(wordsQty - playableWords.length));
  }

  if (playableWords.length < wordsQty) {
    throw 'Not enough words to play the game';
  }

  playableWords.shuffle();
  return playableWords.take(wordsQty).toList();
}

// Get a random word from the vocabulary, optionally filtered by language and weighted by difficulty level.
Word? getRandomWord(
  List<Word> vocabulary, {
  Language? language,
  Map<WordLevel, int>? weights = defaultWordLevelWeights,
}) {
  final filteredVocabulary =
      language != null
          ? vocabulary.where((word) => word.language == language.value).toList()
          : vocabulary;

  if (filteredVocabulary.isEmpty) {
    return null;
  }

  final weightedVocabulary =
      filteredVocabulary
          .expand(
            (word) => List.filled(
              weights != null ? (weights[word.level] ?? 1) : 1,
              word,
            ),
          )
          .toList();

  weightedVocabulary.shuffle();
  return weightedVocabulary.first;
}
