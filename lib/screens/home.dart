import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocabulary_game/providers/settings_provider.dart';
import 'package:vocabulary_game/screens/language.dart';
import 'package:vocabulary_game/screens/vocabulary.dart';
import 'package:vocabulary_game/widgets/notification_banners.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final learningLanguage =
        ref.read(settingsProvider.notifier).getLearningLanguage();

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
                  onPressed: () {},
                  child: const Text('Start Game'),
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
