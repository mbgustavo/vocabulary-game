import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocabulary_game/models/language.dart';
import 'package:vocabulary_game/providers/notifications_provider.dart';
import 'package:vocabulary_game/providers/settings_provider.dart';
import 'package:vocabulary_game/widgets/highlighted_text.dart';
import 'package:vocabulary_game/widgets/new_language.dart';

class LanguageItem extends ConsumerWidget {
  final Language language;
  final bool isSelected;

  const LanguageItem({
    super.key,
    required this.language,
    required this.isSelected,
  });

  Future<void> _onDelete(
    BuildContext context,
    WidgetRef ref,
  ) async {
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

  void _showDeleteDialog(
    BuildContext context,
    WidgetRef ref,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Language'),
          content: Text(
            "Are you sure you want to delete ${language.name} and its vocabulary? This action can't be undone.",
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Delete'),
              onPressed: () => _onDelete(context, ref),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      onTap:
          isSelected
              ? null
              : () => ref
                  .read(settingsProvider.notifier)
                  .changeLearningLanguage(language.value),
      leading: RichText(text: TextSpan(text: language.icon)),
      title: isSelected ? HighlightedText(language.name) : Text(language.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(child: NewLanguage(initialLanguage: language));
                },
              );
            },
            icon: Icon(Icons.edit),
          ),
          isSelected
              ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Icon(
                  Icons.check,
                  color: Color.fromARGB(255, 45, 130, 48),
                ),
              )
              : IconButton(
                onPressed: () => _showDeleteDialog(context, ref),
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
        ],
      ),
    );
  }
}
