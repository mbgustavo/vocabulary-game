import 'package:vocabulary_game/models/word.dart';

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
