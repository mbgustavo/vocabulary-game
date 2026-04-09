import 'package:flutter/material.dart';
import 'package:vocabulary_game/models/word.dart';

enum IntervalType { hours, days }

class NotificationInterval {
  final int value;
  final IntervalType type;

  NotificationInterval({required this.value, required this.type});
}

class WordOfTheMomentSettings {
  final bool enabled;
  final bool fullVocabularyEnabled;
  final Map<WordLevel, int>? wordLevelWeights;
  final NotificationInterval? interval;
  final TimeOfDay? startTime;

  WordOfTheMomentSettings({
    this.enabled = false,
    this.fullVocabularyEnabled = false,
    this.wordLevelWeights,
    this.interval,
    this.startTime,
  });
}

class AppSettings {
  final WordOfTheMomentSettings wordOfTheMomentSettings;

  AppSettings({required this.wordOfTheMomentSettings});
}

final defaultSettings = AppSettings(
  wordOfTheMomentSettings: WordOfTheMomentSettings(),
);
