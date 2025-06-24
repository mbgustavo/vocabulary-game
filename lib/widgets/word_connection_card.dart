import 'package:flutter/material.dart';
import 'package:vocabulary_game/models/word.dart';

class WordConnectionCard extends StatelessWidget {
  final WordInConnectionGame word;
  final String Function(WordInConnectionGame) getText;
  final void Function(WordInConnectionGame)? onTap;

  const WordConnectionCard({
    super.key,
    required this.word,
    required this.getText,
    this.onTap,
  });

  Color _getColorForStatus(WordConnectionStatus status, BuildContext context) {
    switch (status) {
      case WordConnectionStatus.notSelected:
        return Theme.of(context).colorScheme.onSurface;
      case WordConnectionStatus.selected:
        return Theme.of(context).colorScheme.primary;
      case WordConnectionStatus.completed:
        return const Color.fromARGB(255, 104, 235, 111);
      case WordConnectionStatus.error:
        return Theme.of(context).colorScheme.errorContainer;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color:
          word.status == WordConnectionStatus.completed ? Theme.of(context).colorScheme.surfaceContainer : Theme.of(context).colorScheme.onPrimaryFixed,
      child: InkWell(
        onTap:
            word.status == WordConnectionStatus.completed || onTap == null
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