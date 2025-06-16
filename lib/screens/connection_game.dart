import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocabulary_game/models/word.dart';

const wordsQtyForGame = 5;

enum WordStatus { notSelected, selected, completed, error }

class WordInPlay extends Word {
  WordInPlay({
    required super.input,
    required super.translation,
    required super.level,
    required super.language,
    required super.examples,
    required super.id,
  });

  WordStatus status = WordStatus.notSelected;
}

class ConnectionGameScreen extends ConsumerStatefulWidget {
  const ConnectionGameScreen(this.vocabulary, {super.key});

  final List<Word> vocabulary;

  @override
  ConsumerState<ConnectionGameScreen> createState() =>
      _ConnectionGameScreenState();
}

class _ConnectionGameScreenState extends ConsumerState<ConnectionGameScreen> {
  late List<WordInPlay> _translations;
  late List<WordInPlay> _wordsToPlay;
  List<String>? _examplesShown;
  bool _gameCompleted = false;

  @override
  void initState() {
    super.initState();
    _resetGame();

  }

  void _resetGame() {
    final wordsToPlay =
        _getWordsForGame()
            .map(
              (word) => WordInPlay(
                id: word.id,
                input: word.input,
                translation: word.translation,
                level: word.level,
                language: word.language,
                examples: word.examples,
              ),
            )
            .toList();
    final answers =
        wordsToPlay
            .map(
              (word) => WordInPlay(
                id: word.id,
                input: word.input,
                translation: word.translation,
                level: word.level,
                language: word.language,
                examples: word.examples,
              ),
            )
            .toList();
    answers.shuffle();

    setState(() {
      _examplesShown = null;
      _gameCompleted = false;
      _wordsToPlay = wordsToPlay;
      _translations = answers;
    });
  }

  List<Word> _getWordsForGame() {
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

  Color _getColorForStatus(WordStatus status) {
    switch (status) {
      case WordStatus.notSelected:
        return Colors.black54;
      case WordStatus.selected:
        return Colors.blue;
      case WordStatus.completed:
        return Colors.green;
      case WordStatus.error:
        return Colors.red;
    }
  }

  List<Widget> _getCards(
    List<WordInPlay> words,
    String Function(WordInPlay) getText,
    void Function(WordInPlay)? onTap,
  ) {
    return words.map((word) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Center(
          child: Card(
            child: InkWell(
              onTap:
                  word.status == WordStatus.completed || onTap == null
                      ? null
                      : () => onTap(word),
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
          ),
        ),
      );
    }).toList();
  }

  void _selectWord(WordInPlay word, bool isTranslation) {
    List<WordInPlay> inputWords = isTranslation ? _translations : _wordsToPlay;
    List<WordInPlay> answerWords = isTranslation ? _wordsToPlay : _translations;

    setState(() {
      _examplesShown = null;
    });

    for (final otherWord in inputWords) {
      if (otherWord.status == WordStatus.completed) {
        continue;
      }

      if (otherWord.id == word.id) {
        word.status =
            word.status == WordStatus.selected
                ? WordStatus.notSelected
                : WordStatus.selected;
        continue;
      }
      otherWord.status = WordStatus.notSelected;
    }
    setState(() {
      inputWords = inputWords;
    });

    if (word.status == WordStatus.notSelected) {
      return;
    }

    WordInPlay? selectedAnswer;
    for (final answer in answerWords) {
      if (answer.status == WordStatus.selected) {
        selectedAnswer = answer;
        break;
      }

      if (answer.status == WordStatus.error) {
        answer.status = WordStatus.notSelected;
      }
    }

    setState(() {
      answerWords = answerWords;
    });

    if (selectedAnswer == null) {
      return;
    }

    if (selectedAnswer.id == word.id) {
      setState(() {
        word.status = WordStatus.completed;
        selectedAnswer!.status = WordStatus.completed;
        _examplesShown = word.examples.isNotEmpty ? word.examples : null;
      });
      if (_wordsToPlay.every((w) => w.status == WordStatus.completed)) {
        setState(() {
          _gameCompleted = true;
        });
      }
    } else {
      setState(() {
        word.status = WordStatus.error;
        selectedAnswer!.status = WordStatus.error;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Incorrect match! Try again.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connection Game')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 480,
                child: GridView.count(
                  scrollDirection: Axis.horizontal,
                  crossAxisCount: wordsQtyForGame,
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
                        style: TextStyle(fontSize: 20, color: Colors.green),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _resetGame,
                        style: ButtonStyle(
                          fixedSize: WidgetStateProperty.all(
                            const Size(200, 50),
                          ),
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
      ),
    );
  }
}
