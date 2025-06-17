import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocabulary_game/models/word.dart';
import 'package:vocabulary_game/providers/notifications_provider.dart';
import 'package:vocabulary_game/providers/settings_provider.dart';
import 'package:vocabulary_game/providers/vocabulary_provider.dart';
import 'package:vocabulary_game/screens/new_word.dart';

class WordItem extends ConsumerWidget {
  final Word word;

  const WordItem({super.key, required this.word});

  Future<void> _onDelete(BuildContext context, WidgetRef ref) async {
    final error = await ref.read(vocabularyProvider.notifier).deleteWord(word);
    if (error != null) {
      ref
          .read(notificationsProvider.notifier)
          .pushNotification(
            CustomNotification(
              'Failed to delete word: $error',
              type: NotificationType.error,
              isDismissable: false,
            ),
          );
    }
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Word'),
          content: Text(
            "Are you sure you want to delete the word ${word.input}? This action can't be undone.",
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
      leading: RichText(
        text: TextSpan(
          text:
              ref
                  .read(settingsProvider.notifier)
                  .getLanguage(word.language)
                  .icon,
        ),
      ),
      title: Text('${word.input} (${word.translation})'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => NewWordScreen(initialWord: word),
                ),
              );
            },
            icon: Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () => _showDeleteDialog(context, ref),
            icon: Icon(
              Icons.delete,
              color: const Color.fromARGB(255, 219, 121, 121),
            ),
          ),
        ],
      ),
    );
  }
}
