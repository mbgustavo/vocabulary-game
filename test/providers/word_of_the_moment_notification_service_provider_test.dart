import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'package:vocabulary_game/models/settings.dart';
import 'package:vocabulary_game/providers/word_of_the_moment_notification_service_provider.dart';

// Mock Ref for testing
class MockRef extends Mock implements Ref {}

class FakeClock implements Clock {
  final tz.TZDateTime fixedNow;

  FakeClock(this.fixedNow);

  @override
  tz.TZDateTime now() => fixedNow;
}

class TestWordOfTheMomentNotificationService
    extends WordOfTheMomentNotificationService {
  TestWordOfTheMomentNotificationService(super.ref, super.clock);

  @override
  Future<void> initialize() async {}

  @override
  Future<void> cancelScheduledNotification() async {}

  @override
  Future<void> scheduleNotifications() async {}
}

void main() {
  late TestWordOfTheMomentNotificationService service;
  late MockRef mockRef;

  setUp(() {
    tzdata.initializeTimeZones();
    tz.setLocalLocation(tz.UTC);
    mockRef = MockRef();
  });

  group('WordOfTheMomentNotificationService', () {
    test(
      'nextNotificationDate with null previousDate should return initial date if it is before start time',
      () {
        final mockNow = tz.TZDateTime(tz.local, 2017, 11, 29, 8, 0);
        service = TestWordOfTheMomentNotificationService(
          mockRef,
          FakeClock(mockNow),
        );
        final startTime = TimeOfDay(hour: 9, minute: 0);
        final interval = NotificationInterval(
          type: IntervalType.days,
          value: 1,
        );

        final result = service.nextNotificationDate(null, startTime, interval);

        var expected = tz.TZDateTime(
          tz.local,
          mockNow.year,
          mockNow.month,
          mockNow.day,
          9,
          0,
        );
        expect(result, expected);
      },
    );

    test(
      'nextNotificationDate with null previousDate should return initial date in next day if it is after start time',
      () {
        final mockNow = tz.TZDateTime(tz.local, 2017, 11, 29, 10, 0);
        service = TestWordOfTheMomentNotificationService(
          mockRef,
          FakeClock(mockNow),
        );
        final startTime = TimeOfDay(hour: 9, minute: 0);
        final interval = NotificationInterval(
          type: IntervalType.days,
          value: 1,
        );

        final result = service.nextNotificationDate(null, startTime, interval);

        var expected = tz.TZDateTime(
          tz.local,
          mockNow.year,
          mockNow.month,
          mockNow.day,
          9,
          0,
        );
        expected = expected.add(Duration(days: 1));
        expect(result, expected);
      },
    );

    test('nextNotificationDate with previousDate for days interval', () {
      service = TestWordOfTheMomentNotificationService(
        mockRef,
        FakeClock(tz.TZDateTime.now(tz.local)),
      );
      final previousDate = tz.TZDateTime(tz.local, 2023, 1, 1, 9, 0);
      final startTime = TimeOfDay(hour: 9, minute: 0);
      final interval = NotificationInterval(type: IntervalType.days, value: 2);

      final result = service.nextNotificationDate(
        previousDate,
        startTime,
        interval,
      );

      expect(result, tz.TZDateTime(tz.local, 2023, 1, 3, 9, 0));
    });

    test(
      'nextNotificationDate with previousDate for hours interval same day',
      () {
        service = TestWordOfTheMomentNotificationService(
          mockRef,
          FakeClock(tz.TZDateTime.now(tz.local)),
        );
        final previousDate = tz.TZDateTime(tz.local, 2023, 1, 1, 9, 0);
        final startTime = TimeOfDay(hour: 9, minute: 0);
        final interval = NotificationInterval(
          type: IntervalType.hours,
          value: 2,
        );

        final result = service.nextNotificationDate(
          previousDate,
          startTime,
          interval,
        );

        expect(result, tz.TZDateTime(tz.local, 2023, 1, 1, 11, 0));
      },
    );

    test(
      'nextNotificationDate with previousDate for hours interval crossing day',
      () {
        service = TestWordOfTheMomentNotificationService(
          mockRef,
          FakeClock(tz.TZDateTime.now(tz.local)),
        );
        final previousDate = tz.TZDateTime(tz.local, 2023, 1, 1, 23, 0);
        final startTime = TimeOfDay(hour: 9, minute: 0);
        final interval = NotificationInterval(
          type: IntervalType.hours,
          value: 2,
        );

        final result = service.nextNotificationDate(
          previousDate,
          startTime,
          interval,
        );

        expect(result, tz.TZDateTime(tz.local, 2023, 1, 2, 9, 0));
      },
    );
  });
}
