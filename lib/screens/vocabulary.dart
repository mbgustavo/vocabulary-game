import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocabulary_game/models/word.dart';
import 'package:vocabulary_game/providers/notifications_provider.dart';
import 'package:vocabulary_game/providers/settings_provider.dart';
import 'package:vocabulary_game/providers/vocabulary_provider.dart';
import 'package:vocabulary_game/screens/new_word.dart';
import 'package:vocabulary_game/widgets/language_dropdown.dart';
import 'package:vocabulary_game/widgets/notification_banners.dart';
import 'package:vocabulary_game/widgets/word_list.dart';

class VocabularyScreen extends ConsumerStatefulWidget {
  const VocabularyScreen({super.key});

  @override
  ConsumerState<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends ConsumerState<VocabularyScreen> {
  String _selectedLanguage = '';

  Future<void> _onDelete(BuildContext context, Word word) async {
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

  @override
  Widget build(BuildContext context) {
    ref.watch(vocabularyProvider)["vocabulary"];
    final vocabulary = ref
        .watch(vocabularyProvider.notifier)
        .getVocabulary(language: _selectedLanguage);
    final languages = ref.read(settingsProvider.notifier).getLanguages();

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: LanguageDropdown(
              selectedLanguage: _selectedLanguage,
              languages: languages,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: WordList(words: vocabulary, onDelete: _onDelete),
          ),
        ],
      ),
    );
  }
}
