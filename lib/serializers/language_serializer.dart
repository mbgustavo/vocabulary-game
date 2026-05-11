import 'package:vocabulary_game/models/language.dart';
import 'package:vocabulary_game/serializers/serializer.dart';

class LanguageSerializer implements Serializer<Language> {
  @override
  Map<String, dynamic> toMap(Language value) => {
    'name': value.name,
    'icon': value.icon,
  };

  @override
  Language fromMap(Map<String, dynamic> map) =>
      Language(map['name'], map['icon']);
}
