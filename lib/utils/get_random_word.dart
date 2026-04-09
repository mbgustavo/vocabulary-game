import 'package:vocabulary_game/models/language.dart';
import 'package:vocabulary_game/models/word.dart';

Word? getRandomWord(
  List<Word> vocabulary, {
  Language? language,
  Map<WordLevel, int>? weights = const {
    WordLevel.beginner: 3,
    WordLevel.intermediate: 2,
    WordLevel.advanced: 1,
  },
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
              weights != null ? weights[word.level] ??= 1 : 1,
              word,
            ),
          )
          .toList();

  weightedVocabulary.shuffle();
  return weightedVocabulary.first;
}
