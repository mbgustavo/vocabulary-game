import 'package:flutter/material.dart';
import 'package:vocabulary_game/models/word.dart';
import 'package:vocabulary_game/screens/home.dart';
import 'package:vocabulary_game/widgets/game_completed.dart';
import 'package:vocabulary_game/widgets/word_card.dart';
import 'package:vocabulary_game/games/get_words_for_game.dart';

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
  late List<WordInGame> _translations;
  late List<WordInGame> _wordsToPlay;
  List<String>? _examplesShown;
  bool _gameCompleted = false;

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    late List<WordInGame> wordsToPlay;
    try {
      wordsToPlay =
          getWordsForGame(
            widget.vocabulary,
            widget.wordsQty,
          ).map(WordInGame.fromWord).toList();
    } catch (e) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (ctx) => const HomeScreen()));
    }
    final translations = wordsToPlay.map(WordInGame.fromWord).toList();
    translations.shuffle();

    setState(() {
      _examplesShown = null;
      _gameCompleted = false;
      _wordsToPlay = wordsToPlay;
      _translations = translations;
    });
  }

  List<Widget> _getCards(
    List<WordInGame> words,
    String Function(WordInGame) getText,
    void Function(WordInGame)? onTap,
  ) {
    return words.map((word) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Center(
          child: WordCard(word: word, getText: getText, onTap: onTap),
        ),
      );
    }).toList();
  }

  void _selectWord(WordInGame word, bool isTranslation) {
    List<WordInGame> inputWords = isTranslation ? _translations : _wordsToPlay;
    List<WordInGame> answerWords = isTranslation ? _wordsToPlay : _translations;

    setState(() {
      _examplesShown = null;
    });

    for (final otherWord in inputWords) {
      if (otherWord.status == WordStatus.completed) {
        continue;
      }

      if (otherWord.id != word.id) {
        otherWord.status = WordStatus.notSelected;
        continue;
      }

      word.status =
          word.status == WordStatus.selected
              ? WordStatus.notSelected
              : WordStatus.selected;
    }
    setState(() {
      inputWords = inputWords;
    });

    if (word.status == WordStatus.notSelected) {
      return;
    }

    WordInGame? selectedAnswer;
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

    _verifyAnswer(word, selectedAnswer);
  }

  void _verifyAnswer(WordInGame input, WordInGame answer) {
    if (input.id == answer.id) {
      setState(() {
        input.status = WordStatus.completed;
        answer.status = WordStatus.completed;
        _examplesShown = input.examples.isNotEmpty ? input.examples : null;
        _gameCompleted = _wordsToPlay.every(
          (w) => w.status == WordStatus.completed,
        );
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      return;
    }

    setState(() {
      input.status = WordStatus.error;
      answer.status = WordStatus.error;
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
                child: GameCompleted(onReset: _resetGame),
              ),
          ],
        ),
      ),
    );
  }
}
