import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vocabulary_game/screens/game.dart';

class GameSelectScreen extends ConsumerWidget {
  const GameSelectScreen({super.key});

  void _navigateToGame(BuildContext context, WidgetRef ref, Game game) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => GameScreen(game: game),
      ),
    );
  }

  void _navigateToRandomGame(BuildContext context, WidgetRef ref) {
    final random = Random();
    final games = Game.values;
    final randomGame = games[random.nextInt(games.length)];
    _navigateToGame(context, ref, randomGame);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.gameSelectTitle)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.gameSelectGameMode,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Text(l10n.gameDifficultyEasy, style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                _navigateToGame(context, ref, Game.connection);
              },
              child: Text(l10n.gameConnectWords, textAlign: TextAlign.center),
            ),
            const SizedBox(height: 8),
            Text(l10n.gameDifficultyMedium, style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                _navigateToGame(context, ref, Game.multipleChoice);
              },
              child: Text(l10n.gameMultipleChoice, textAlign: TextAlign.center),
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
              child: Text(
                '${l10n.gameMultipleChoice}\n(${l10n.gameFromTranslations})',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            Text(l10n.gameDifficultyHard, style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                _navigateToGame(context, ref, Game.write);
              },
              child: Text(
                l10n.gameWriteWords,
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
              child: Text(
                '${l10n.gameWriteWords}\n(${l10n.gameFromTranslations})',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            Text(l10n.gameDifficultyRandom, style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                _navigateToRandomGame(context, ref);
              },
              child: Text(
                l10n.gameAnyGameMode,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
