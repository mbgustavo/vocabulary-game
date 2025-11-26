import 'package:flutter/material.dart';
import 'package:vocabulary_game/models/word.dart';
import 'package:vocabulary_game/widgets/game_completed.dart';

class WriteGame extends StatefulWidget {
  final List<Word> words;
  final void Function()? onReset;
  final bool playWithTranslations;

  const WriteGame(
    this.words, {
    super.key,
    this.onReset,
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
    _initializeGame();
  }

  @override
  void didUpdateWidget(WriteGame oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if the words list has changed
    if (oldWidget.words != widget.words) {
      _initializeGame();
    }
  }

  void _initializeGame() {
    setState(() {
      _examplesShown = null;
      _questionCompleted = false;
      _gameCompleted = false;
      _wordsToPlay = widget.words;
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
        _error = false;
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
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400),
              child: TextField(
                controller: _answerController,
                readOnly: _questionCompleted,
                onChanged: (_) {
                  if (_error) {
                    setState(() => _error = false);
                  }
                },
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
                  child: ElevatedButton.icon(
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
                      fixedSize: Size(200, 48),
                      backgroundColor:
                          Theme.of(context).colorScheme.onPrimaryFixed,
                      foregroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    icon: Icon(
                      _questionCompleted ? Icons.navigate_next : Icons.check,
                      size: 28,
                    ),
                    label: Text(
                      _questionCompleted ? 'Next' : 'Submit',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                )
                : Padding(
                  padding: const EdgeInsets.all(24),
                  child: GameCompleted(onReset: widget.onReset),
                ),
          ],
        ),
      ),
    );
  }
}
