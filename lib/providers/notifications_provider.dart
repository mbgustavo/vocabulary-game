import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NotificationType { error, success, info }

class CustomNotification {
  int? id;
  final String message;
  final NotificationType type;
  final bool isDismissable;
  final int? timeout;

  CustomNotification(
    this.message, {
    this.type = NotificationType.info,
    this.isDismissable = true,
    this.timeout,
  });

  setId(int id) {
    this.id = id;
  }
}

class NotificationsNotifier extends StateNotifier<List<CustomNotification>> {
  NotificationsNotifier() : super([]);
  int id = 0;

  /// Adds a [CustomNotification] to the current state, assigns it a unique ID and returns the id.
  int pushNotification(CustomNotification notification) {
    state = [...state, notification..setId(id)];

    if (notification.timeout != null) {
      Timer(
        Duration(seconds: notification.timeout!),
        () => dismissNotification(notification.id!),
      );
    }
    return id++;
  }

  void dismissNotification(int? id) {
    if (id == null) return;
    state = state.where((notification) => notification.id != id).toList();
  }

  void clearNotifications() {
    state = [];
  }
}

final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, List<CustomNotification>>(
      (ref) => NotificationsNotifier(),
    );
