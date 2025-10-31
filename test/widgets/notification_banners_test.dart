import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vocabulary_game/widgets/notification_banners.dart';
import 'package:vocabulary_game/providers/notifications_provider.dart';

class MockNotificationsNotifier extends Mock implements NotificationsNotifier {}

void main() {
  group('NotificationBanners Widget Tests', () {
    Widget createTestWidget({
      List<CustomNotification>? notifications,
      List<Override>? overrides,
    }) {
      return ProviderScope(
        overrides: overrides ?? [],
        child: MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                NotificationBanners(),
                Expanded(child: Container()), // Filler content
              ],
            ),
          ),
        ),
      );
    }

    Future<void> pumpWidgetWithNotifications(
      WidgetTester tester,
      List<CustomNotification> notifications,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            notificationsProvider.overrideWith((ref) {
              return NotificationsNotifier()..state = notifications;
            }),
          ],
        ),
      );
    }

    group('Display Tests', () {
      testWidgets('should show nothing when no notifications', (
        WidgetTester tester,
      ) async {
        await pumpWidgetWithNotifications(tester, []);

        // Should show SizedBox.shrink (nothing visible)
        expect(find.byType(SizedBox), findsOneWidget);
        expect(find.byType(MaterialBanner), findsNothing);
      });

      testWidgets('should display single notification', (
        WidgetTester tester,
      ) async {
        final notification = CustomNotification(
          'Test notification',
          type: NotificationType.info,
          isDismissable: true,
        )..setId(1);
        await pumpWidgetWithNotifications(tester, [notification]);

        // Should display MaterialBanner
        expect(find.byType(MaterialBanner), findsOneWidget);
        expect(find.text('Test notification'), findsOneWidget);
      });

      testWidgets('should display multiple notifications', (
        WidgetTester tester,
      ) async {
        final notifications = [
          CustomNotification('First notification')..setId(1),
          CustomNotification('Second notification')..setId(2),
          CustomNotification('Third notification')..setId(3),
        ];

        await pumpWidgetWithNotifications(tester, notifications);

        // Should display all notifications
        expect(find.byType(MaterialBanner), findsNWidgets(3));
        expect(find.text('First notification'), findsOneWidget);
        expect(find.text('Second notification'), findsOneWidget);
        expect(find.text('Third notification'), findsOneWidget);
      });
    });

    group('Notification Type Tests', () {
      testWidgets('should display error notification with correct color', (
        WidgetTester tester,
      ) async {
        final notification = CustomNotification(
          'Error message',
          type: NotificationType.error,
        )..setId(1);

        await pumpWidgetWithNotifications(tester, [notification]);

        final materialBanner = tester.widget<MaterialBanner>(
          find.byType(MaterialBanner),
        );
        final theme = Theme.of(tester.element(find.byType(MaterialBanner)));

        expect(
          materialBanner.backgroundColor,
          equals(theme.colorScheme.errorContainer),
        );
        expect(find.text('Error message'), findsOneWidget);
      });

      testWidgets('should display success notification with correct color', (
        WidgetTester tester,
      ) async {
        final notification = CustomNotification(
          'Success message',
          type: NotificationType.success,
        )..setId(1);

        await pumpWidgetWithNotifications(tester, [notification]);

        final materialBanner = tester.widget<MaterialBanner>(
          find.byType(MaterialBanner),
        );

        expect(
          materialBanner.backgroundColor,
          equals(const Color.fromARGB(255, 33, 99, 36)),
        );
        expect(find.text('Success message'), findsOneWidget);
      });

      testWidgets('should display info notification with correct color', (
        WidgetTester tester,
      ) async {
        final notification = CustomNotification(
          'Info message',
          type: NotificationType.info,
        )..setId(1);

        await pumpWidgetWithNotifications(tester, [notification]);

        final materialBanner = tester.widget<MaterialBanner>(
          find.byType(MaterialBanner),
        );
        final theme = Theme.of(tester.element(find.byType(MaterialBanner)));

        expect(
          materialBanner.backgroundColor,
          equals(theme.colorScheme.primaryContainer),
        );
        expect(find.text('Info message'), findsOneWidget);
      });

      testWidgets('should handle mixed notification types', (
        WidgetTester tester,
      ) async {
        final notifications = [
          CustomNotification('Error', type: NotificationType.error)..setId(1),
          CustomNotification('Success', type: NotificationType.success)
            ..setId(2),
          CustomNotification('Info', type: NotificationType.info)..setId(3),
        ];

        await pumpWidgetWithNotifications(tester, notifications);

        // Should display all different types
        expect(find.byType(MaterialBanner), findsNWidgets(3));
        expect(find.text('Error'), findsOneWidget);
        expect(find.text('Success'), findsOneWidget);
        expect(find.text('Info'), findsOneWidget);

        // Verify different background colors
        final banners =
            tester
                .widgetList<MaterialBanner>(find.byType(MaterialBanner))
                .toList();
        final theme = Theme.of(
          tester.element(find.byType(MaterialBanner).first),
        );

        expect(
          banners[0].backgroundColor,
          equals(theme.colorScheme.errorContainer),
        );
        expect(
          banners[1].backgroundColor,
          equals(const Color.fromARGB(255, 33, 99, 36)),
        );
        expect(
          banners[2].backgroundColor,
          equals(theme.colorScheme.primaryContainer),
        );
      });
    });

    group('Dismissible Tests', () {
      testWidgets(
        'should not show close button for non-dismissible notifications',
        (WidgetTester tester) async {
          final notification = CustomNotification(
            'Non-dismissible notification',
            isDismissable: false,
          )..setId(1);

          await pumpWidgetWithNotifications(tester, [notification]);

          // Should not show close icon, but should show SizedBox.shrink
          expect(find.byIcon(Icons.close), findsNothing);
          expect(find.byType(IconButton), findsNothing);
          expect(find.byType(SizedBox), findsAtLeastNWidgets(1));
        },
      );

      testWidgets(
        'should show close button and call dismiss for dismissible notifications',
        (WidgetTester tester) async {
          final notifier = NotificationsNotifier();
          final notification = CustomNotification(
            'Test notification',
            isDismissable: true,
          )..setId(1);

          notifier.state = [notification];

          await tester.pumpWidget(
            createTestWidget(
              overrides: [
                notificationsProvider.overrideWith((ref) => notifier),
              ],
            ),
          );

          // Verify notification is displayed
          expect(find.text('Test notification'), findsOneWidget);
          expect(find.byIcon(Icons.close), findsOneWidget);

          // Tap close button
          await tester.tap(find.byIcon(Icons.close));
          await tester.pumpAndSettle();

          // Notification should be dismissed
          expect(notifier.state, isEmpty);
          expect(find.text('Test notification'), findsNothing);
          expect(find.byType(MaterialBanner), findsNothing);
        },
      );

      testWidgets(
        'should handle mixed dismissible and non-dismissible notifications',
        (WidgetTester tester) async {
          final notifications = [
            CustomNotification('Dismissible', isDismissable: true)..setId(1),
            CustomNotification('Non-dismissible', isDismissable: false)
              ..setId(2),
          ];

          await pumpWidgetWithNotifications(tester, notifications);

          // Should have one close button (for dismissible notification)
          expect(find.byIcon(Icons.close), findsOneWidget);
          expect(find.byType(IconButton), findsOneWidget);
          expect(find.byType(MaterialBanner), findsNWidgets(2));
        },
      );
    });

    group('Provider Integration Tests', () {
      testWidgets('should react to provider state changes', (
        WidgetTester tester,
      ) async {
        final notifier = NotificationsNotifier();

        await tester.pumpWidget(
          createTestWidget(
            overrides: [notificationsProvider.overrideWith((ref) => notifier)],
          ),
        );

        // Initially no notifications
        expect(find.byType(MaterialBanner), findsNothing);

        // Add notification
        notifier.state = [CustomNotification('New notification')..setId(1)];
        await tester.pumpAndSettle();

        // Should display the new notification
        expect(find.byType(MaterialBanner), findsOneWidget);
        expect(find.text('New notification'), findsOneWidget);

        // Clear notifications
        notifier.state = [];
        await tester.pumpAndSettle();

        // Should show nothing again
        expect(find.byType(MaterialBanner), findsNothing);
      });
    });

    group('Edge Cases Tests', () {
      testWidgets('should handle notifications with special characters', (
        WidgetTester tester,
      ) async {
        final notification = CustomNotification(
          'Special chars: !@#\$%^&*()_+-=[]{}|;:\'",.<>?',
        )..setId(1);

        await pumpWidgetWithNotifications(tester, [notification]);

        expect(
          find.text('Special chars: !@#\$%^&*()_+-=[]{}|;:\'",.<>?'),
          findsOneWidget,
        );
        expect(find.byType(MaterialBanner), findsOneWidget);
      });

      testWidgets('should handle very long notification messages', (
        WidgetTester tester,
      ) async {
        final longMessage =
            'This is a very long notification message that should ' +
            'still be displayed properly even though it contains a lot of text and ' +
            'might need to wrap or scroll in the UI depending on the layout constraints.';

        final notification = CustomNotification(longMessage)..setId(1);

        await pumpWidgetWithNotifications(tester, [notification]);

        expect(find.byType(MaterialBanner), findsOneWidget);
        expect(
          find.textContaining('This is a very long notification'),
          findsOneWidget,
        );
      });

      testWidgets('should handle empty notification message', (
        WidgetTester tester,
      ) async {
        final notification = CustomNotification('')..setId(1);

        await pumpWidgetWithNotifications(tester, [notification]);

        expect(find.byType(MaterialBanner), findsOneWidget);
        expect(find.text(''), findsOneWidget);
      });
    });
  });
}
