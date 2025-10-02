import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocabulary_game/providers/notifications_provider.dart';

void main() {
  group('CustomNotification', () {
    test('should create notification with default values', () {
      final notification = CustomNotification('Test message');
      
      expect(notification.message, 'Test message');
      expect(notification.type, NotificationType.info);
      expect(notification.isDismissable, true);
      expect(notification.timeout, null);
      expect(notification.id, null);
    });

    test('should create notification with custom values', () {
      final notification = CustomNotification(
        'Error message',
        type: NotificationType.error,
        isDismissable: true,
        timeout: 5,
      );
      notification.setId(42);
      
      expect(notification.message, 'Error message');
      expect(notification.type, NotificationType.error);
      expect(notification.isDismissable, true);
      expect(notification.timeout, 5);
      expect(notification.id, 42);
    });
  });

  group('NotificationsNotifier', () {
    late ProviderContainer container;
    late NotificationsNotifier notifier;

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(notificationsProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('should start with empty list', () {
      final notifications = container.read(notificationsProvider);
      expect(notifications, isEmpty);
    });

    test('should push notification and assign ID', () {
      final notification = CustomNotification('Test message');
      final returnedId = notifier.pushNotification(notification);
      
      final notifications = container.read(notificationsProvider);
      
      expect(notifications.length, 1);
      expect(notifications[0].message, 'Test message');
      expect(notifications[0].id, 0);
      expect(returnedId, 0);
    });

    test('should push multiple notifications with incremental IDs', () {
      final notification1 = CustomNotification('Message 1');
      final notification2 = CustomNotification('Message 2');
      final notification3 = CustomNotification('Message 3');
      
      notifier.pushNotification(notification1);
      notifier.pushNotification(notification2);
      notifier.pushNotification(notification3);
      
      final notifications = container.read(notificationsProvider);
      
      expect(notifications.length, 3);
      expect(notifications[0].id, 0);
      expect(notifications[1].id, 1);
      expect(notifications[2].id, 2);
      expect(notifications[0].message, 'Message 1');
      expect(notifications[1].message, 'Message 2');
      expect(notifications[2].message, 'Message 3');
    });

    test('should dismiss notification by ID', () {
      final notification1 = CustomNotification('Message 1');
      final notification2 = CustomNotification('Message 2');
      final notification3 = CustomNotification('Message 3');
      
      notifier.pushNotification(notification1);
      notifier.pushNotification(notification2);
      notifier.pushNotification(notification3);
      
      // Dismiss middle notification
      notifier.dismissNotification(1);
      
      final notifications = container.read(notificationsProvider);
      
      expect(notifications.length, 2);
      expect(notifications[0].id, 0);
      expect(notifications[1].id, 2);
      expect(notifications[0].message, 'Message 1');
      expect(notifications[1].message, 'Message 3');
    });

    test('should handle dismissing non-existent notification', () {
      final notification = CustomNotification('Test message');
      notifier.pushNotification(notification);
      
      // Try to dismiss non-existent ID
      notifier.dismissNotification(999);
      
      final notifications = container.read(notificationsProvider);
      
      expect(notifications.length, 1);
      expect(notifications[0].message, 'Test message');
    });

    test('should clear all notifications', () {
      final notification1 = CustomNotification('Message 1');
      final notification2 = CustomNotification('Message 2');
      final notification3 = CustomNotification('Message 3');
      
      notifier.pushNotification(notification1);
      notifier.pushNotification(notification2);
      notifier.pushNotification(notification3);
      
      notifier.clearNotifications();
      
      final notifications = container.read(notificationsProvider);
      
      expect(notifications, isEmpty);
    });

    test('should handle different notification types', () {
      final errorNotification = CustomNotification(
        'Error message',
        type: NotificationType.error,
      );
      final successNotification = CustomNotification(
        'Success message',
        type: NotificationType.success,
      );
      final infoNotification = CustomNotification(
        'Info message',
        type: NotificationType.info,
      );
      
      notifier.pushNotification(errorNotification);
      notifier.pushNotification(successNotification);
      notifier.pushNotification(infoNotification);
      
      final notifications = container.read(notificationsProvider);
      
      expect(notifications.length, 3);
      expect(notifications[0].type, NotificationType.error);
      expect(notifications[1].type, NotificationType.success);
      expect(notifications[2].type, NotificationType.info);
    });

    test('should handle dismissable and non-dismissable notifications', () {
      final dismissableNotification = CustomNotification(
        'Dismissable message',
        isDismissable: true,
      );
      final nonDismissableNotification = CustomNotification(
        'Non-dismissable message',
        isDismissable: false,
      );
      
      notifier.pushNotification(dismissableNotification);
      notifier.pushNotification(nonDismissableNotification);
      
      final notifications = container.read(notificationsProvider);
      
      expect(notifications.length, 2);
      expect(notifications[0].isDismissable, true);
      expect(notifications[1].isDismissable, false);
    });

    test('should auto-dismiss notification with timeout', () async {
      final notification = CustomNotification(
        'Timeout message',
        timeout: 1, // 1 second timeout
      );
      
      notifier.pushNotification(notification);
      
      // Check notification is present
      var notifications = container.read(notificationsProvider);
      expect(notifications.length, 1);
      
      // Wait for timeout + a bit more
      await Future.delayed(Duration(milliseconds: 1100));
      
      // Check notification is automatically dismissed
      notifications = container.read(notificationsProvider);
      expect(notifications.length, 0);
    });

    test('should not auto-dismiss notification without timeout', () async {
      final notification = CustomNotification('No timeout message');
      
      notifier.pushNotification(notification);
      
      // Check notification is present
      var notifications = container.read(notificationsProvider);
      expect(notifications.length, 1);
      
      // Wait a bit
      await Future.delayed(Duration(milliseconds: 100));
      
      // Check notification is still present
      notifications = container.read(notificationsProvider);
      expect(notifications.length, 1);
    });

    test('should preserve state after adding and removing notifications', () {
      // Add some notifications
      notifier.pushNotification(CustomNotification('Message 1'));
      notifier.pushNotification(CustomNotification('Message 2'));
      notifier.pushNotification(CustomNotification('Message 3'));
      
      // Remove middle one
      notifier.dismissNotification(1);
      
      // Add another
      notifier.pushNotification(CustomNotification('Message 4'));
      
      final notifications = container.read(notificationsProvider);
      
      expect(notifications.length, 3);
      expect(notifications[0].id, 0);
      expect(notifications[1].id, 2);
      expect(notifications[2].id, 3);
      expect(notifications[0].message, 'Message 1');
      expect(notifications[1].message, 'Message 3');
      expect(notifications[2].message, 'Message 4');
    });
  });
}