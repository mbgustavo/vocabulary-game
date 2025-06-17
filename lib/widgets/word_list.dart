import 'package:flutter/material.dart';
import 'package:vocabulary_game/models/word.dart';
import 'package:vocabulary_game/widgets/word_item.dart';

class WordList extends StatelessWidget {
  const WordList({
    super.key,
    required this.words,
    required this.onDelete,
  });

  final List<Word> words;
  final Future<void> Function(BuildContext context, Word word) onDelete;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: words.length,
      itemBuilder: (ctx, index) {
        return WordItem(word: words[index], onDelete: onDelete);
      },
    );
  }
}
