enum WordLevel {
  beginner,
  intermediate,
  advanced,
}

class Word {
  final String language;
  final String input;
  final String translation;
  final List<String> examples;
  final WordLevel level;

  Word(this.language, this.input, this.translation, {this.examples = const [], this.level = WordLevel.beginner});

  addExample(String phrase) {
    if (phrase.isNotEmpty) {
      examples.add(phrase);
    }
  }
}