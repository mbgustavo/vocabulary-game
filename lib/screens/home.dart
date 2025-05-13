import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocabulary_game/providers/settings_provider.dart';
import 'package:vocabulary_game/screens/language.dart';
import 'package:vocabulary_game/screens/vocabulary.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(settingsProvider.notifier).loadLanguages();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    Widget content;

    if (!settings.containsKey('learning_language') ||
        settings['learning_language'] == null) {
      content = const Text("Loading...");
    } else {
      final learningLanguage = ref.read(settingsProvider.notifier).getLearningLanguage();
      content = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Welcome to Vocabulary Game!'),
          SizedBox(height: 20),
          Text('You are learning ${learningLanguage.name}'),
          SizedBox(height: 80),
          ElevatedButton(onPressed: () {}, child: const Text('Start Game')),
          SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const VocabularyScreen()),
              );
            },
            child: const Text('Edit vocabulary'),
          ),
          SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const LanguageScreen()),
              );
            },
            child: const Text('Select learning language'),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Vocabulary Game')),
      body: Center(child: content),
    );
  }
}
