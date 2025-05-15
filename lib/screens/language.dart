import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocabulary_game/models/language.dart';
import 'package:vocabulary_game/providers/settings_provider.dart';
import 'package:vocabulary_game/widgets/highlighted_text.dart';
import 'package:vocabulary_game/widgets/new_language.dart';
import 'package:vocabulary_game/widgets/notification_banners.dart';

class LanguageScreen extends ConsumerStatefulWidget {
  const LanguageScreen({super.key});

  @override
  ConsumerState<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends ConsumerState<LanguageScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(settingsProvider.notifier).loadLanguages();
  }

  void showDeleteDialog(Language language) {
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
              onPressed: () async {
                final error = await ref
                    .read(settingsProvider.notifier)
                    .deleteLanguage(language);
                if (error == null && context.mounted) {
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
            child: ListView.builder(
              itemCount: languages.length,
              itemBuilder: (ctx, index) {
                final isSelected =
                    languages[index].value == learningLanguage.value;
            
                return ListTile(
                  onTap:
                      isSelected
                          ? () => {}
                          : () => ref
                              .read(settingsProvider.notifier)
                              .changeLearningLanguage(languages[index].value),
                  leading: RichText(text: TextSpan(text: languages[index].icon)),
                  title:
                      isSelected
                          ? Highlightedtext(languages[index].name)
                          : Text(languages[index].name),
                  trailing:
                      isSelected
                          ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Icon(
                              Icons.check,
                              color: Color.fromARGB(255, 45, 130, 48),
                            ),
                          )
                          : IconButton(
                            onPressed: () => showDeleteDialog(languages[index]),
                            icon: Icon(
                              Icons.delete,
                              color: const Color.fromARGB(255, 219, 121, 121),
                            ),
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
