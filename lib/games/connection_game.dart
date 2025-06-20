import 'package:flutter/material.dart';
import 'package:vocabulary_game/models/word.dart';
import 'package:vocabulary_game/widgets/word_connection_card.dart';

const defaultQty = 5;

class ConnectionGame extends StatefulWidget {
  final List<Word> vocabulary;
  final int wordsQty;

  const ConnectionGame(
    this.vocabulary, {
    super.key,
    this.wordsQty = defaultQty,
  });

  @override
  State<ConnectionGame> createState() => _ConnectionGameState();
}

class _ConnectionGameState extends State<ConnectionGame> {
  late List<WordInConnectionGame> _translations;
  late List<WordInConnectionGame> _wordsToPlay;
  List<String>? _examplesShown;
  bool _gameCompleted = false;

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    final wordsToPlay =
        _getWordsForGame().map(WordInConnectionGame.fromWord).toList();
    final translations =
        wordsToPlay.map(WordInConnectionGame.fromWord).toList();
    translations.shuffle();

    setState(() {
      _examplesShown = null;
      _gameCompleted = false;
      _wordsToPlay = wordsToPlay;
      _translations = translations;
    });
  }

  // Try to fill all words with beginner level words first,
  // then intermediate, and finally advanced words if needed.
  List<Word> _getWordsForGame() {
    final playableWords =
        widget.vocabulary
            .where((word) => word.level == WordLevel.beginner)
            .toList();

    if (playableWords.length < widget.wordsQty) {
      playableWords.addAll(
        widget.vocabulary
            .where((word) => word.level == WordLevel.intermediate)
            .take(widget.wordsQty - playableWords.length),
      );
    }

    if (playableWords.length < widget.wordsQty) {
      playableWords.addAll(
        widget.vocabulary
            .where((word) => word.level == WordLevel.advanced)
            .take(widget.wordsQty - playableWords.length),
      );
    }

    playableWords.shuffle();
    return playableWords.take(widget.wordsQty).toList();
  }

  List<Widget> _getCards(
    List<WordInConnectionGame> words,
    String Function(WordInConnectionGame) getText,
    void Function(WordInConnectionGame)? onTap,
  ) {
    return words.map((word) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Center(
          child: WordConnectionCard(word: word, getText: getText, onTap: onTap),
        ),
      );
    }).toList();
  }

  void _selectWord(WordInConnectionGame word, bool isTranslation) {
    List<WordInConnectionGame> inputWords =
        isTranslation ? _translations : _wordsToPlay;
    List<WordInConnectionGame> answerWords =
        isTranslation ? _wordsToPlay : _translations;

    setState(() {
      _examplesShown = null;
    });

    for (final otherWord in inputWords) {
      if (otherWord.status == WordConnectionStatus.completed) {
        continue;
      }

      if (otherWord.id != word.id) {
        otherWord.status = WordConnectionStatus.notSelected;
        continue;
      }

      word.status =
          word.status == WordConnectionStatus.selected
              ? WordConnectionStatus.notSelected
              : WordConnectionStatus.selected;
    }
    setState(() {
      inputWords = inputWords;
    });

    if (word.status == WordConnectionStatus.notSelected) {
      return;
    }

    WordInConnectionGame? selectedAnswer;
    for (final answer in answerWords) {
      if (answer.status == WordConnectionStatus.selected) {
        selectedAnswer = answer;
        break;
      }

      if (answer.status == WordConnectionStatus.error) {
        answer.status = WordConnectionStatus.notSelected;
      }
    }

    setState(() {
      answerWords = answerWords;
    });

    if (selectedAnswer == null) {
      return;
    }

    _verifyAnswer(word, selectedAnswer);
  }

  void _verifyAnswer(WordInConnectionGame input, WordInConnectionGame answer) {
    if (input.id == answer.id) {
      setState(() {
        input.status = WordConnectionStatus.completed;
        answer.status = WordConnectionStatus.completed;
        _examplesShown = input.examples.isNotEmpty ? input.examples : null;
        _gameCompleted = _wordsToPlay.every(
          (w) => w.status == WordConnectionStatus.completed,
        );
      });
      return;
    }

    setState(() {
      input.status = WordConnectionStatus.error;
      answer.status = WordConnectionStatus.error;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Incorrect match! Try again.')));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 480,
              child: GridView.count(
                scrollDirection: Axis.horizontal,
                crossAxisCount: widget.wordsQty,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                childAspectRatio: 0.7,
                children: [
                  ..._getCards(
                    _wordsToPlay,
                    (word) => word.input,
                    (word) => _selectWord(word, false),
                  ),
                  ..._getCards(
                    _translations,
                    (word) => word.translation,
                    (word) => _selectWord(word, true),
                  ),
                ],
              ),
            ),
            _examplesShown != null
                ? Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    _examplesShown!.join('\n'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                )
                : const SizedBox(height: 39),
            if (_gameCompleted)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Congratulations! You completed the game!',
                      style: TextStyle(fontSize: 20, color: Colors.green[900]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _resetGame,
                      style: ButtonStyle(
                        fixedSize: WidgetStateProperty.all(const Size(200, 50)),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.restart_alt, size: 32),
                            const SizedBox(width: 4),
                            const Text(
                              'Play again',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
