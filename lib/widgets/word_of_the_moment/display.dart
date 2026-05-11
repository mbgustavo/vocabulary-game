import 'package:flutter/material.dart';
import 'package:vocabulary_game/l10n/app_localizations.dart';
import 'package:vocabulary_game/models/word.dart';
import 'package:vocabulary_game/widgets/word_of_the_moment/card.dart';

class WordOfTheMomentDisplay extends StatelessWidget {
  final VoidCallback generateWord;
  final Word? word;

  const WordOfTheMomentDisplay({
    super.key,
    required this.generateWord,
    required this.word,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (word == null) {
      return Text(l10n.wordOfTheMomentNoWords);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 300),
          child: WordOfTheMomentCard(word: word!),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: generateWord,
          style: ElevatedButton.styleFrom(fixedSize: const Size(240, 48)),
          icon: const Icon(Icons.restart_alt, size: 28),
          label: Text(
            l10n.wordOfTheMomentGenerateNewWord,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
