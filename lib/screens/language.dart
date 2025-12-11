import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  @override
  Widget build(BuildContext context) {
    ref.watch(settingsProvider)["languages"];
    ref.watch(settingsProvider)["learning_language"];
    final languages = ref.watch(settingsProvider.notifier).getLanguages();
    final learningLanguage =
        ref.read(settingsProvider.notifier).getLearningLanguage();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning languages'),
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
            ),
          ),
        ],
      ),
    );
  }
}
