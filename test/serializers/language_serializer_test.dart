import 'package:flutter_test/flutter_test.dart';
import 'package:vocabulary_game/models/language.dart';
import 'package:vocabulary_game/serializers/language_serializer.dart';

void main() {
  late LanguageSerializer serializer;

  setUp(() {
    serializer = LanguageSerializer();
  });

  group('LanguageSerializer', () {
    test('toMap should serialize Language correctly', () {
      final language = Language('English', '🇺🇸');

      final map = serializer.toMap(language);

      expect(map['name'], 'English');
      expect(map['icon'], '🇺🇸');
    });

    test('fromMap should deserialize map correctly', () {
      final map = {
        'name': 'Spanish',
        'icon': '🇪🇸',
      };

      final language = serializer.fromMap(map);

      expect(language.name, 'Spanish');
      expect(language.icon, '🇪🇸');
    });
  });
}