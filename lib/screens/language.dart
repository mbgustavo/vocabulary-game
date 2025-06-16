import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocabulary_game/models/language.dart';
import 'package:vocabulary_game/providers/notifications_provider.dart';
import 'package:vocabulary_game/providers/settings_provider.dart';
import 'package:vocabulary_game/widgets/language_list.dart';
import 'package:vocabulary_game/widgets/new_language.dart';
import 'package:vocabulary_game/widgets/notification_banners.dart';

class LanguageScreen extends ConsumerStatefulWidget {
  const LanguageScreen({super.key});

  @override
  ConsumerState<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends ConsumerState<LanguageScreen> {
  Future<void> onDelete(BuildContext context, Language language) async {
    final error = await ref
        .read(settingsProvider.notifier)
        .deleteLanguage(language);
    if (error != null) {
      ref
          .read(notificationsProvider.notifier)
          .pushNotification(
            CustomNotification(
              'Failed to delete language: $error',
              type: NotificationType.error,
              isDismissable: false,
            ),
          );
    }
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(settingsProvider)["languages"];
    ref.watch(settingsProvider)["learning_language"];
    final languages = ref.watch(settingsProvider.notifier).getLanguages();
    final learningLanguage =
        ref.read(settingsProvider.notifier).getLearningLanguage();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Learning Language'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(child: NewLanguage());
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NotificationBanners(),
          Expanded(
            flex: 1,
            child: LanguageList(
              languages: languages,
              learningLanguage: learningLanguage.value,
              onTap:
                  (language) => ref
                      .read(settingsProvider.notifier)
                      .changeLearningLanguage(language.value),
              onDelete: onDelete,
            ),
          ),
        ],
      ),
    );
  }
}
