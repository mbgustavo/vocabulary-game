import 'package:vocabulary_game/models/word.dart';

// Try to fill all words with beginner level words first,
// then intermediate, and finally advanced words if needed.
List<Word> getWordsForGame(List<Word> vocabulary, int wordsQty) {
  final playableWords =
      vocabulary.where((word) => word.level == WordLevel.beginner).toList();

  if (playableWords.length < wordsQty) {
    playableWords.addAll(
      vocabulary
          .where((word) => word.level == WordLevel.intermediate)
          .take(wordsQty - playableWords.length),
    );
  }

  if (playableWords.length < wordsQty) {
    playableWords.addAll(
      vocabulary
          .where((word) => word.level == WordLevel.advanced)
          .take(wordsQty - playableWords.length),
    );
  }

  if (playableWords.length < wordsQty) {
    throw 'Not enough words to play the game';
  }

  playableWords.shuffle();
  return playableWords.take(wordsQty).toList();
}
