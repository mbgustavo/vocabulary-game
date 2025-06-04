import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocabulary_game/models/word.dart';
import 'package:vocabulary_game/providers/notifications_provider.dart';
import 'package:vocabulary_game/providers/settings_provider.dart';
import 'package:vocabulary_game/providers/vocabulary_provider.dart';
import 'package:vocabulary_game/screens/new_word.dart';
import 'package:vocabulary_game/widgets/notification_banners.dart';

class VocabularyScreen extends ConsumerStatefulWidget {
  const VocabularyScreen({super.key});

  @override
  ConsumerState<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends ConsumerState<VocabularyScreen> {
  void showDeleteDialog(Word word) {
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
              onPressed: () async {
                final error = await ref
                    .read(vocabularyProvider.notifier)
                    .deleteWord(word);
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
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(vocabularyProvider)["vocabulary"];
    final vocabulary = ref.watch(vocabularyProvider.notifier).getVocabulary();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vocabulary List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (ctx) => NewWordScreen()));
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
            child: ListView.builder(
              itemCount: vocabulary.length,
              itemBuilder: (ctx, index) {
                return ListTile(
                  leading: RichText(
                    text: TextSpan(
                      text:
                          ref
                              .read(settingsProvider.notifier)
                              .getLanguage(vocabulary[index].language)
                              .icon,
                    ),
                  ),
                  title: Text(
                    '${vocabulary[index].input} (${vocabulary[index].translation})',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(
                            context,
                          ).push(MaterialPageRoute(builder: (ctx) => NewWordScreen(initialWord: vocabulary[index])));
                        },
                        icon: Icon(
                          Icons.edit,
                        ),
                      ),
                      IconButton(
                        onPressed: () => showDeleteDialog(vocabulary[index]),
                        icon: Icon(
                          Icons.delete,
                          color: const Color.fromARGB(255, 219, 121, 121),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
