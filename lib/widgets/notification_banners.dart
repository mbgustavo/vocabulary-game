import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocabulary_game/providers/notifications_provider.dart';

class NotificationBanners extends ConsumerWidget {
  const NotificationBanners({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final notifications = ref.watch(notificationsProvider);

    if (notifications.isEmpty) {
      return const SizedBox.shrink();
    }

    Color getBackgroundColor (NotificationType type) {
      switch (type) {
        case NotificationType.error:
          return Colors.red;
        case NotificationType.success:
          return Colors.green;
        default:
          return Colors.blueGrey;
      }
    }

    return Expanded(
      flex: 0,
      child: Column(
        children:
            notifications.map((notification) {
              return MaterialBanner(
                content: Text(notification.message, style: TextStyle(color: Colors.white),),
                backgroundColor: getBackgroundColor(notification.type),
                actions:
                    notification.isDismissable
                        ? [
                          IconButton(
                            onPressed:
                                () => ref
                                    .read(notificationsProvider.notifier)
                                    .dismissNotification(notification.id!),
                            icon: Icon(Icons.close),
                          ),
                        ]
                        : [SizedBox.shrink()],
              );
            }).toList(),
      ),
    );
  }
}
