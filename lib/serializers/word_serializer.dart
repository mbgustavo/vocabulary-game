import 'package:vocabulary_game/models/word.dart';
import 'package:vocabulary_game/serializers/serializer.dart';

class WordSerializer implements Serializer<Word> {
  @override
  Map<String, dynamic> toMap(Word value) => {
    'language': value.language,
    'input': value.input,
    'translation': value.translation,
    'examples': value.examples,
    'level': value.level.name,
    'id': value.id,
  };

  @override
  Word fromMap(Map<String, dynamic> map) {
    WordLevel level;
    try {
      level = WordLevel.values.byName(map['level'] ?? 'beginner');
    } catch (e) {
      level = WordLevel.beginner; // Default to beginner if parsing fails
    }

    return Word(
      language: map['language']!,
      input: map['input']!,
      translation: map['translation']!,
      examples: List<String>.from(map['examples'] ?? []),
      level: level,
      id: map['id'],
    );
  }
}
