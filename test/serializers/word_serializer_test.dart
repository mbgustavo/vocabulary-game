import 'package:flutter_test/flutter_test.dart';
import 'package:vocabulary_game/models/word.dart';
import 'package:vocabulary_game/serializers/word_serializer.dart';

void main() {
  late WordSerializer serializer;

  setUp(() {
    serializer = WordSerializer();
  });

  group('WordSerializer', () {
    test('toMap should serialize Word correctly', () {
      final word = Word(
        language: 'english',
        input: 'hello',
        translation: 'hola',
        examples: ['Hello world', 'Hello there'],
        level: WordLevel.intermediate,
        id: '123',
      );

      final map = serializer.toMap(word);

      expect(map['language'], 'english');
      expect(map['input'], 'hello');
      expect(map['translation'], 'hola');
      expect(map['examples'], ['Hello world', 'Hello there']);
      expect(map['level'], 'intermediate');
      expect(map['id'], '123');
    });

    test('fromMap should deserialize map correctly', () {
      final map = {
        'language': 'spanish',
        'input': 'hola',
        'translation': 'hello',
        'examples': ['Hola mundo', 'Hola amigo'],
        'level': 'advanced',
        'id': '456',
      };

      final word = serializer.fromMap(map);

      expect(word.language, 'spanish');
      expect(word.input, 'hola');
      expect(word.translation, 'hello');
      expect(word.examples, ['Hola mundo', 'Hola amigo']);
      expect(word.level, WordLevel.advanced);
      expect(word.id, '456');
    });

    test('fromMap should handle null examples', () {
      final map = {
        'language': 'french',
        'input': 'bonjour',
        'translation': 'hello',
        'level': 'beginner',
      };

      final word = serializer.fromMap(map);

      expect(word.language, 'french');
      expect(word.input, 'bonjour');
      expect(word.translation, 'hello');
      expect(word.examples, []);
      expect(word.level, WordLevel.beginner);
      expect(word.id, isNotNull); // ID is generated if not provided
    });

    test('fromMap should handle invalid level', () {
      final map = {
        'language': 'German',
        'input': 'hallo',
        'translation': 'hello',
        'level': 'invalid',
      };

      final word = serializer.fromMap(map);

      expect(word.level, WordLevel.beginner); // Defaults to beginner
    });

    test('fromMap should handle null level', () {
      final map = {
        'language': 'Italian',
        'input': 'ciao',
        'translation': 'hello',
      };

      final word = serializer.fromMap(map);

      expect(word.level, WordLevel.beginner); // Defaults to beginner
    });
  });
}
