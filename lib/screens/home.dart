import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocabulary_game/providers/settings_provider.dart';
import 'package:vocabulary_game/providers/vocabulary_provider.dart';
import 'package:vocabulary_game/screens/connection_game.dart';
import 'package:vocabulary_game/screens/language.dart';
import 'package:vocabulary_game/screens/vocabulary.dart';
import 'package:vocabulary_game/widgets/notification_banners.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    ref.watch(settingsProvider)["learning_language"];
    ref.watch(vocabularyProvider)["vocabulary"];
    final learningLanguage =
        ref.read(settingsProvider.notifier).getLearningLanguage();
    final vocabulary =
        ref.read(vocabularyProvider.notifier).getVocabulary(language: learningLanguage.value);

    return Scaffold(
      appBar: AppBar(title: const Text('Vocabulary Game')),
      body: Stack(
        children: [
          NotificationBanners(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Welcome to Vocabulary Game!'),
                SizedBox(height: 20),
                Text('You are learning ${learningLanguage.name}'),
                SizedBox(height: 80),
                ElevatedButton(
                  onPressed: vocabulary.length < 5 ? null : () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => ConnectionGameScreen(vocabulary),
                      ),
                    );
                  },
                  child: const Text('Start Game'),
                ),
                if (vocabulary.length < 5)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'You need at least 5 words in your vocabulary to start the game.',
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => const VocabularyScreen(),
                      ),
                    );
                  },
                  child: const Text('Edit vocabulary'),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => const LanguageScreen(),
                      ),
                    );
                  },
                  child: const Text('Select learning language'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
