import 'package:flutter/material.dart';
import 'package:vocabulary_game/l10n/app_localizations.dart';
import 'package:vocabulary_game/models/word.dart';

class WordOfTheMomentCard extends StatelessWidget {
  final Word word;

  const WordOfTheMomentCard({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      color: Theme.of(context).colorScheme.onPrimaryFixed,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${word.input} - ${word.translation}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(l10n.wordOfTheMomentLevel(word.level.label)),
          ],
        ),
      ),
    );
  }
}
