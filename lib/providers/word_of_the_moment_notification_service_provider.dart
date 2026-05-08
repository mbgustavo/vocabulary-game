import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'package:vocabulary_game/models/settings.dart';
import 'package:vocabulary_game/providers/languages_provider.dart';
import 'package:vocabulary_game/providers/settings_provider.dart';
import 'package:vocabulary_game/providers/vocabulary_provider.dart';
import 'package:vocabulary_game/utils/words.dart';

const notificationsQueue = 20;

abstract class WordOfTheMomentNotificationService {
  WordOfTheMomentNotificationService(this.ref);

  final Ref ref;

  static const int notificationId = 1000;
  static const String channelId = 'word_of_the_moment';
  static const String channelName = 'Word Of The Moment';
  static const String channelDescription =
      'Scheduled Word Of The Moment notifications.';

  Future<void> initialize();
  Future<void> cancelScheduledNotification();
  Future<void> scheduleNotifications();

  tz.TZDateTime nextNotificationDate(
    tz.TZDateTime? previousDate,
    TimeOfDay startTime,
    NotificationInterval interval,
  ) {
    if (previousDate == null) {
      return _initialNotificationDate(startTime, interval);
    }

    if (interval.type == IntervalType.hours) {
      var scheduled = previousDate.add(Duration(hours: interval.value));
      if (scheduled.day != previousDate.day) {
        scheduled = tz.TZDateTime(
          tz.local,
          scheduled.year,
          scheduled.month,
          scheduled.day,
          startTime.hour,
          startTime.minute,
        );
      }
      return scheduled;
    } else {
      return previousDate.add(Duration(days: interval.value));
    }
  }

  tz.TZDateTime _initialNotificationDate(
    TimeOfDay startTime,
    NotificationInterval interval,
  ) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      startTime.hour,
      startTime.minute,
    );

    if (interval.type == IntervalType.hours) {
      final intervalDuration = Duration(hours: interval.value);
      if (!now.isBefore(scheduled)) {
        final delta = now.difference(scheduled);
        final increments =
            (delta.inSeconds / intervalDuration.inSeconds).ceil();
        scheduled = scheduled.add(intervalDuration * increments);
        if (scheduled.day != now.day) {
          scheduled = tz.TZDateTime(
            tz.local,
            scheduled.year,
            scheduled.month,
            scheduled.day,
            startTime.hour,
            startTime.minute,
          );
        }
      }
    } else if (!now.isBefore(scheduled)) {
      scheduled = scheduled.add(Duration(days: interval.value));
    }

    return scheduled;
  }
}

class WordOfTheMomentNotificationServiceMobile
    extends WordOfTheMomentNotificationService {
  WordOfTheMomentNotificationServiceMobile(
    super.ref,
    this.notificationsPlugin, {
    this.timeZoneInitializer = tzdata.initializeTimeZones,
    this.localTimeZoneGetter = FlutterTimezone.getLocalTimezone,
  });

  final FlutterLocalNotificationsPlugin notificationsPlugin;
  final FutureOr<void> Function() timeZoneInitializer;
  final Future<TimezoneInfo> Function() localTimeZoneGetter;
  bool _initialized = false;

  @override
  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    WidgetsFlutterBinding.ensureInitialized();
    await timeZoneInitializer();
    final TimezoneInfo timeZone = await localTimeZoneGetter();
    tz.setLocalLocation(tz.getLocation(timeZone.identifier));

    const androidInitializationSettings = AndroidInitializationSettings('icon');
    const linuxInitializationSettings = LinuxInitializationSettings(
      defaultActionName: 'Open notification',
    );
    const darwinInitializationSettings = DarwinInitializationSettings();

    final initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      linux: linuxInitializationSettings,
      iOS: darwinInitializationSettings,
      macOS: darwinInitializationSettings,
    );

    await notificationsPlugin.initialize(settings: initializationSettings);
    scheduleNotifications();
    _initialized = true;
  }

  @override
  Future<void> cancelScheduledNotification() async {
    await initialize();
    await notificationsPlugin.cancel(
      id: WordOfTheMomentNotificationService.notificationId,
    );
  }

  Future<bool> _hasPendingNotification() async {
    await initialize();

    final pending = await notificationsPlugin.pendingNotificationRequests();
    return pending.any(
      (request) =>
          request.id == WordOfTheMomentNotificationService.notificationId,
    );
  }

  @override
  Future<void> scheduleNotifications() async {
    await initialize();

    if (await _hasPendingNotification()) {
      await cancelScheduledNotification();
    }

    final settings = ref.read(settingsProvider.notifier).getSettings();

    if (!settings.wordOfTheMomentSettings.notificationsEnabled) {
      return await cancelScheduledNotification();
    }

    final language =
        settings.wordOfTheMomentSettings.fullVocabularyEnabled
            ? null
            : ref.read(languagesProvider.notifier).getLearningLanguage();
    final vocabulary = ref
        .read(vocabularyProvider.notifier)
        .getVocabulary(language: language?.value);

    final interval = settings.wordOfTheMomentSettings.interval;
    final startTime =
        settings.wordOfTheMomentSettings.startTime ?? TimeOfDay.now();
    if (interval == null) {
      return;
    }

    final darwinDetails = DarwinNotificationDetails();
    tz.TZDateTime? previousDate;

    for (var i = 0; i < notificationsQueue; i++) {
      final word = getRandomWord(
        vocabulary,
        language: language,
        weights: settings.wordOfTheMomentSettings.wordLevelWeights,
      );
      if (word == null) {
        return;
      }

      final scheduledDate = nextNotificationDate(
        previousDate,
        startTime,
        interval,
      );
      previousDate = scheduledDate;

      final notificationUniqueId =
          WordOfTheMomentNotificationService.notificationId + i;

      final androidDetails = AndroidNotificationDetails(
        WordOfTheMomentNotificationService.channelId,
        WordOfTheMomentNotificationService.channelName,
        channelDescription:
            WordOfTheMomentNotificationService.channelDescription,
        importance: Importance.low,
        priority: Priority.low,
        tag: 'word_of_the_moment',
        ticker: '${word.input} - ${word.translation}',
      );

      final notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
        macOS: darwinDetails,
      );

      await notificationsPlugin.zonedSchedule(
        id: notificationUniqueId,
        title: 'Word Of The Moment',
        body: '${word.input} - ${word.translation}',
        scheduledDate: scheduledDate,
        notificationDetails: notificationDetails,
        androidScheduleMode: AndroidScheduleMode.inexact,
        payload: word.id,
      );
    }
  }
}

class WordOfTheMomentNotificationServiceDesktop
    extends WordOfTheMomentNotificationService {
  WordOfTheMomentNotificationServiceDesktop(super.ref);

  @override
  Future<void> initialize() async {}

  @override
  Future<void> cancelScheduledNotification() async {}

  @override
  Future<void> scheduleNotifications() async {}
}

final wordOfTheMomentNotificationServiceProvider =
    Provider<WordOfTheMomentNotificationService>((ref) {
      if (Platform.isAndroid || Platform.isIOS) {
        return WordOfTheMomentNotificationServiceMobile(
          ref,
          FlutterLocalNotificationsPlugin(),
        );
      }

      return WordOfTheMomentNotificationServiceDesktop(ref);
    });
