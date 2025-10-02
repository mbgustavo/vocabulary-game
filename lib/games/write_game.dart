import 'package:flutter/material.dart';
import 'package:vocabulary_game/models/word.dart';
import 'package:vocabulary_game/games/get_words_for_game.dart';
import 'package:vocabulary_game/screens/home.dart';
import 'package:vocabulary_game/widgets/game_completed.dart';

const defaultQty = 5;

class WriteGame extends StatefulWidget {
  final List<Word> vocabulary;
  final int wordsQty;
  final bool playWithTranslations;

  const WriteGame(
    this.vocabulary, {
    super.key,
    this.wordsQty = defaultQty,
    this.playWithTranslations = false,
  });

  @override
  State<WriteGame> createState() => _WriteGameState();
}

class _WriteGameState extends State<WriteGame> {
  late List<Word> _wordsToPlay;
  List<String>? _examplesShown;
  bool _gameCompleted = false;
  bool _questionCompleted = false;
  int _currentQuestion = 0;
  final _answerController = TextEditingController();
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    late List<Word> wordsToPlay;
    try {
      wordsToPlay = getWordsForGame(widget.vocabulary, widget.wordsQty);
    } catch (e) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (ctx) => const HomeScreen()));
    }
    setState(() {
      _examplesShown = null;
      _questionCompleted = false;
      _gameCompleted = false;
      _wordsToPlay = wordsToPlay;
      _currentQuestion = 0;
    });
    _answerController.clear();
  }

  void _verifyAnswer() {
    final expectedAnswer =
        widget.playWithTranslations
            ? _wordsToPlay[_currentQuestion].input
            : _wordsToPlay[_currentQuestion].translation;
    if (expectedAnswer.toLowerCase().trim() ==
        _answerController.text.toLowerCase().trim()) {
      setState(() {
        _examplesShown =
            _wordsToPlay[_currentQuestion].examples.isNotEmpty
                ? _wordsToPlay[_currentQuestion].examples
                : null;
        _questionCompleted = true;
        _gameCompleted = _currentQuestion >= _wordsToPlay.length - 1;
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      return;
    }

    setState(() => _error = true);
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
            Text(
              'Write the translation for the word:',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              widget.playWithTranslations
                  ? _wordsToPlay[_currentQuestion].translation
                  : _wordsToPlay[_currentQuestion].input,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            TextField(
              controller: _answerController,
              readOnly: _questionCompleted,
              style: TextStyle(
                color:
                    _error
                        ? Theme.of(context).colorScheme.error
                        : _questionCompleted
                        ? Color.fromARGB(255, 104, 235, 111)
                        : null,
              ),
              decoration: InputDecoration(labelText: 'Your answer'),
            ),
            const SizedBox(height: 36),
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
            !_gameCompleted
                ? Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed:
                        _questionCompleted
                            ? () {
                              setState(() {
                                _currentQuestion++;
                                _questionCompleted = false;
                                _examplesShown = null;
                              });
                              _answerController.clear();
                            }
                            : _verifyAnswer,
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(200, 50),
                      backgroundColor:
                          Theme.of(context).colorScheme.onPrimaryFixed,
                      foregroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children:
                            _questionCompleted
                                ? [
                                  Text('Next', style: TextStyle(fontSize: 20)),
                                  SizedBox(width: 4),
                                  Icon(Icons.navigate_next, size: 32),
                                ]
                                : [
                                  Text(
                                    'Submit',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(Icons.check, size: 32),
                                ],
                      ),
                    ),
                  ),
                )
                : Padding(
                  padding: const EdgeInsets.all(24),
                  child: GameCompleted(onReset: _resetGame),
                ),
          ],
        ),
      ),
    );
  }
}
