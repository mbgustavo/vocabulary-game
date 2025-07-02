import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocabulary_game/providers/settings_provider.dart';
import 'package:vocabulary_game/providers/vocabulary_provider.dart';
import 'package:vocabulary_game/screens/game.dart';

class GameSelectScreen extends ConsumerWidget {
  const GameSelectScreen({super.key});

  void _navigateToGame(BuildContext context, WidgetRef ref, Game game) {
    final learningLanguage =
        ref.read(settingsProvider.notifier).getLearningLanguage();
    final vocabulary =
        ref.read(vocabularyProvider.notifier).getVocabulary(language: learningLanguage.value);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => GameScreen(vocabulary: vocabulary, game: game),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Game')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select a game mode:',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Text("Easy", style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                _navigateToGame(context, ref, Game.connection);
              },
              child: const Text('Connect Words', textAlign: TextAlign.center),
            ),
            const SizedBox(height: 8),
            Text("Medium", style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                _navigateToGame(context, ref, Game.multipleChoice);
              },
              child: const Text('Multiple Choice', textAlign: TextAlign.center),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                _navigateToGame(context, ref, Game.multipleChoiceReversed);
              },
              child: const Text(
                'Multiple Choice\n(from translations)',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            Text("Hard", style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                _navigateToGame(context, ref, Game.write);
              },
              child: const Text(
                'Write Words',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                _navigateToGame(context, ref, Game.writeReversed);
              },
              child: const Text(
                'Write Words\n(from translations)',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
