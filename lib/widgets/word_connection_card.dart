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

  Color _getColorForStatus(WordConnectionStatus status) {
    switch (status) {
      case WordConnectionStatus.notSelected:
        return Colors.black54;
      case WordConnectionStatus.selected:
        return Colors.blue;
      case WordConnectionStatus.completed:
        return Colors.green;
      case WordConnectionStatus.error:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color:
          word.status == WordConnectionStatus.completed ? Colors.white30 : Colors.white,
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
                color: _getColorForStatus(word.status),
              ),
            ),
          ),
        ),
      ),
    );
  }
}