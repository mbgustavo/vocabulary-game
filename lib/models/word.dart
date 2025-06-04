import 'package:uuid/uuid.dart';

enum WordLevel { beginner, intermediate, advanced }

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
