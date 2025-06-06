import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocabulary_game/models/word.dart';

const wordsQtyForGame = 5;

class ConnectionGameScreen extends ConsumerStatefulWidget {
  const ConnectionGameScreen(this.vocabulary, {super.key});

  final List<Word> vocabulary;

  @override
  ConsumerState<ConnectionGameScreen> createState() =>
      _ConnectionGameScreenState();
}

class _ConnectionGameScreenState extends ConsumerState<ConnectionGameScreen> {
  late List<Word> _answers;
  late List<Word> _wordsToPlay;

  @override
  void initState() {
    super.initState();

    final wordsToPlay = getWordsForGame();
    final answers = [...wordsToPlay];
    answers.shuffle();

    setState(() {
      _wordsToPlay = wordsToPlay;
      _answers = answers;
    });
  }

  List<Word> getWordsForGame() {
    final playableWords =
        widget.vocabulary
            .where((word) => word.level == WordLevel.beginner)
            .toList();

    if (playableWords.length < wordsQtyForGame) {
      playableWords.addAll(
        widget.vocabulary
            .where((word) => word.level == WordLevel.intermediate)
            .take(wordsQtyForGame - playableWords.length),
      );
    }

    if (playableWords.length < wordsQtyForGame) {
      playableWords.addAll(
        widget.vocabulary
            .where((word) => word.level == WordLevel.advanced)
            .take(wordsQtyForGame - playableWords.length),
      );
    }

    playableWords.shuffle();
    return playableWords.take(wordsQtyForGame).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connection Game')),
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  _wordsToPlay.map((word) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          word.input,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  _answers.map((word) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          word.input,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
