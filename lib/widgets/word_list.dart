import 'package:flutter/material.dart';
import 'package:vocabulary_game/l10n/app_localizations.dart';
import 'package:vocabulary_game/models/word.dart';
import 'package:vocabulary_game/widgets/word_item.dart';

class WordList extends StatelessWidget {
  final List<Word> words;

  const WordList({super.key, required this.words});

  @override
  Widget build(BuildContext context) {
    if (words.isEmpty) {
      return Center(
        child: Text(AppLocalizations.of(context)!.noWordsInVocabulary),
      );
    }

    return ListView.builder(
      itemCount: words.length,
      itemBuilder: (ctx, index) {
        return WordItem(word: words[index]);
      },
    );
  }
}
