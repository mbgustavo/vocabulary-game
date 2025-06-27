import 'package:uuid/uuid.dart';

enum WordLevel { beginner, intermediate, advanced }
enum WordStatus { notSelected, selected, completed, error, disabled }

extension WordLevelExtension on WordLevel {
  String get label {
    switch (this) {
      case WordLevel.beginner:
        return 'Beginner';
      case WordLevel.intermediate:
        return 'Intermediate';
      case WordLevel.advanced:
        return 'Advanced';
    }
  }
}

var uuid = Uuid();

class Word {
  final String id;
  final String language;
  final String input;
  final String translation;
  final List<String> examples;
  final WordLevel level;

  Word(
    {required this.language,
    required this.input,
    required this.translation,
    this.examples = const [],
    this.level = WordLevel.beginner,
    id,
  }) : id = id ?? uuid.v4();
}

class WordInGame extends Word {
  WordStatus status = WordStatus.notSelected;

  WordInGame({
    required super.input,
    required super.translation,
    required super.level,
    required super.language,
    required super.examples,
    required super.id,
  });

  WordInGame.fromWord(Word word)
    : this(
        id: word.id,
        input: word.input,
        translation: word.translation,
        level: word.level,
        language: word.language,
        examples: word.examples,
      );
}