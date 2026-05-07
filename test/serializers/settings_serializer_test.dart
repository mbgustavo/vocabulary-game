import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocabulary_game/models/settings.dart';
import 'package:vocabulary_game/models/word.dart';
import 'package:vocabulary_game/serializers/settings_serializer.dart';

void main() {
  late AppSettingsSerializer appSerializer;
  late WordOfTheMomentSettingsSerializer wordSerializer;

  setUp(() {
    appSerializer = AppSettingsSerializer();
    wordSerializer = WordOfTheMomentSettingsSerializer();
  });

  group('WordOfTheMomentSettingsSerializer', () {
    test('toMap should serialize WordOfTheMomentSettings correctly', () {
      final settings = WordOfTheMomentSettings(
        notificationsEnabled: true,
        fullVocabularyEnabled: false,
        wordLevelWeights: {WordLevel.beginner: 1, WordLevel.intermediate: 3},
        interval: NotificationInterval(value: 1, type: IntervalType.hours),
        startTime: TimeOfDay(hour: 8, minute: 30),
      );

      final map = wordSerializer.toMap(settings);

      expect(map['notificationsEnabled'], true);
      expect(map['fullVocabularyEnabled'], false);
      expect(map['wordLevelWeights'], {'beginner': 1, 'intermediate': 3});
      expect(map['interval'], {'value': 1, 'type': 'hours'});
      expect(map['startTime'], {'hour': 8, 'minute': 30});
    });

    test('fromMap should deserialize map correctly', () {
      final map = {
        'notificationsEnabled': true,
        'fullVocabularyEnabled': true,
        'wordLevelWeights': {'advanced': 3},
        'interval': {'value': 2, 'type': 'days'},
        'startTime': {'hour': 9, 'minute': 0},
      };

      final settings = wordSerializer.fromMap(map);

      expect(settings.notificationsEnabled, true);
      expect(settings.fullVocabularyEnabled, true);
      expect(settings.wordLevelWeights, {WordLevel.advanced: 3});
      expect(settings.interval!.value, 2);
      expect(settings.interval!.type, IntervalType.days);
      expect(settings.startTime!.hour, 9);
      expect(settings.startTime!.minute, 0);
    });

    test('fromMap should handle null map', () {
      final settings = wordSerializer.fromMap(null);

      expect(settings, defaultSettings.wordOfTheMomentSettings);
    });

    test('fromMap should handle partial map', () {
      final map = {'notificationsEnabled': false};

      final settings = wordSerializer.fromMap(map);

      expect(settings.notificationsEnabled, false);
      expect(settings.fullVocabularyEnabled, false);
      expect(settings.wordLevelWeights, null);
      expect(settings.interval, null);
      expect(settings.startTime, null);
    });

    test('fromMap should ignore invalid wordLevelWeights', () {
      final map = {
        'wordLevelWeights': {'invalid': 1},
      };

      final settings = wordSerializer.fromMap(map);

      expect(settings.wordLevelWeights, null);
    });

    test('fromMap should ignore invalid interval', () {
      final map = {
        'interval': {'value': 1, 'type': 'invalid'},
      };

      final settings = wordSerializer.fromMap(map);

      expect(settings.interval, null);
    });

    test('fromMap should ignore invalid startTime', () {
      final map = {
        'startTime': {'hour': 'invalid', 'minute': 30},
      };

      final settings = wordSerializer.fromMap(map);

      expect(settings.startTime, null);
    });
  });

  group('AppSettingsSerializer', () {
    test('toMap should serialize AppSettings correctly', () {
      final settings = AppSettings(
        wordOfTheMomentSettings: WordOfTheMomentSettings(
          notificationsEnabled: true,
        ),
      );

      final map = appSerializer.toMap(settings);

      expect(map['wordOfTheMomentSettings'], isA<Map<String, dynamic>>());
      expect(map['wordOfTheMomentSettings']['notificationsEnabled'], true);
    });

    test('fromMap should deserialize map correctly', () {
      final map = {
        'wordOfTheMomentSettings': {
          'notificationsEnabled': false,
          'fullVocabularyEnabled': true,
        },
      };

      final settings = appSerializer.fromMap(map);

      expect(settings.wordOfTheMomentSettings.notificationsEnabled, false);
      expect(settings.wordOfTheMomentSettings.fullVocabularyEnabled, true);
    });

    test('fromMap should handle null map', () {
      final settings = appSerializer.fromMap(null);

      expect(settings, defaultSettings);
    });
  });
}
