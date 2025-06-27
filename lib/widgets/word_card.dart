import 'package:flutter/material.dart';
import 'package:vocabulary_game/models/word.dart';

class WordCard extends StatelessWidget {
  final WordInGame word;
  final String Function(WordInGame) getText;
  final void Function(WordInGame)? onTap;

  const WordCard({
    super.key,
    required this.word,
    required this.getText,
    this.onTap,
  });

  Color _getColorForStatus(WordStatus status, BuildContext context) {
    switch (status) {
      case WordStatus.disabled:
        return Theme.of(context).colorScheme.onSurface;
      case WordStatus.notSelected:
        return Theme.of(context).colorScheme.onSurface;
      case WordStatus.selected:
        return Theme.of(context).colorScheme.primary;
      case WordStatus.completed:
        return const Color.fromARGB(255, 104, 235, 111);
      case WordStatus.error:
        return Theme.of(context).colorScheme.errorContainer;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color:
          word.status == WordStatus.completed ||
                  word.status == WordStatus.disabled
              ? Theme.of(context).colorScheme.surfaceContainer
              : Theme.of(context).colorScheme.onPrimaryFixed,
      child: InkWell(
        onTap:
            word.status == WordStatus.completed ||
                    word.status == WordStatus.disabled ||
                    onTap == null
                ? null
                : () => onTap!(word),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Center(
            child: Text(
              getText(word),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: _getColorForStatus(word.status, context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
