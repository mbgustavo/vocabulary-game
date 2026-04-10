import 'package:flutter/material.dart';
import 'package:vocabulary_game/models/settings.dart';
import 'package:vocabulary_game/models/word.dart';
import 'package:vocabulary_game/serializers/serializer.dart';

class AppSettingsSerializer implements Serializer<AppSettings> {
  final Serializer wordOfTheMomentSettingsSerializer;

  AppSettingsSerializer({Serializer? wordOfTheMomentSettingsSerializer})
    : wordOfTheMomentSettingsSerializer =
          wordOfTheMomentSettingsSerializer ??
          WordOfTheMomentSettingsSerializer();

  @override
  Map<String, dynamic> toMap(AppSettings value) {
    return {
      'wordOfTheMomentSettings': wordOfTheMomentSettingsSerializer.toMap(
        value.wordOfTheMomentSettings,
      ),
    };
  }

  @override
  AppSettings fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return defaultSettings;
    }

    return AppSettings(
      wordOfTheMomentSettings: wordOfTheMomentSettingsSerializer.fromMap(
        map['wordOfTheMomentSettings'] as Map<String, dynamic>,
      ),
    );
  }
}

class WordOfTheMomentSettingsSerializer
    implements Serializer<WordOfTheMomentSettings> {
  @override
  Map<String, dynamic> toMap(WordOfTheMomentSettings value) {
    final map = <String, dynamic>{
      'notificationsEnabled': value.notificationsEnabled,
      'fullVocabularyEnabled': value.fullVocabularyEnabled,
    };

    if (value.wordLevelWeights != null) {
      map['wordLevelWeights'] = value.wordLevelWeights!.map(
        (level, weight) => MapEntry(level.name, weight),
      );
    }

    if (value.interval != null) {
      map['interval'] = {
        'value': value.interval!.value,
        'type': value.interval!.type.name,
      };
    }

    if (value.startTime != null) {
      map['startTime'] = {
        'hour': value.startTime!.hour,
        'minute': value.startTime!.minute,
      };
    }

    return map;
  }

  @override
  WordOfTheMomentSettings fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return defaultSettings.wordOfTheMomentSettings;
    }

    Map<WordLevel, int>? parsedWeights;
    final rawWeights = map['wordLevelWeights'];
    if (rawWeights is Map) {
      final entries = <MapEntry<WordLevel, int>>[];
      for (final entry in rawWeights.entries) {
        final key = entry.key;
        final value = entry.value;
        if (key is String && value is int) {
          try {
            entries.add(MapEntry(WordLevel.values.byName(key), value));
          } catch (_) {
            // Ignore unknown values.
          }
        }
      }
      if (entries.isNotEmpty) {
        parsedWeights = Map.fromEntries(entries);
      }
    }

    NotificationInterval? parsedInterval;
    final rawInterval = map['interval'];
    if (rawInterval is Map) {
      final value = rawInterval['value'];
      final type = rawInterval['type'];
      if (value is int && type is String) {
        try {
          parsedInterval = NotificationInterval(
            value: value,
            type: IntervalType.values.byName(type),
          );
        } catch (_) {
          // Ignore invalid interval type
        }
      }
    }

    TimeOfDay? parsedStartTime;
    final rawStartTime = map['startTime'];
    if (rawStartTime is Map) {
      final hour = rawStartTime['hour'];
      final minute = rawStartTime['minute'];
      if (hour is int && minute is int) {
        parsedStartTime = TimeOfDay(hour: hour, minute: minute);
      }
    }

    return WordOfTheMomentSettings(
      notificationsEnabled: map['notificationsEnabled'] as bool? ?? false,
      fullVocabularyEnabled: map['fullVocabularyEnabled'] as bool? ?? false,
      wordLevelWeights: parsedWeights,
      interval: parsedInterval,
      startTime: parsedStartTime,
    );
  }
}
