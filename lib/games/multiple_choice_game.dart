import 'package:flutter/material.dart';
import 'package:vocabulary_game/models/word.dart';
import 'package:vocabulary_game/games/get_words_for_game.dart';
import 'package:vocabulary_game/widgets/game_completed.dart';
import 'package:vocabulary_game/widgets/multiple_choice_question.dart';

const defaultQty = 5;

class MultipleChoiceGame extends StatefulWidget {
  final List<Word> vocabulary;
  final int wordsQty;
  final bool playWithTranslations;

  const MultipleChoiceGame(
    this.vocabulary, {
    super.key,
    this.wordsQty = defaultQty,
    this.playWithTranslations = false,
  });

  @override
  State<MultipleChoiceGame> createState() => _MultipleChoiceGameState();
}

class _MultipleChoiceGameState extends State<MultipleChoiceGame> {
  late List<Word> _wordsToPlay;
  late List<WordInGame> _answers;
  List<String>? _examplesShown;
  bool _gameCompleted = false;
  bool _questionCompleted = false;
  int _currentQuestion = 0;

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    final wordsToPlay = getWordsForGame(widget.vocabulary, widget.wordsQty);
    setState(() {
      _examplesShown = null;
      _questionCompleted = false;
      _gameCompleted = false;
      _wordsToPlay = wordsToPlay;
      _currentQuestion = 0;
    });

    _getAnswers();
  }

  void _getAnswers() {
    final answers = [
      WordInGame.fromWord(_wordsToPlay[_currentQuestion]),
      ...widget.vocabulary
          .where((word) => word.id != _wordsToPlay[_currentQuestion].id)
          .take(widget.wordsQty - 1)
          .map(WordInGame.fromWord),
    ];
    answers.shuffle();

    setState(() {
      _answers = answers;
    });
  }

  void _verifyAnswer(WordInGame answer) {
    if (_wordsToPlay[_currentQuestion].id == answer.id) {
      setState(() {
        answer.status = WordStatus.completed;
        _examplesShown = answer.examples.isNotEmpty ? answer.examples : null;
        _questionCompleted = true;
        _gameCompleted = _currentQuestion >= _wordsToPlay.length - 1;
      });
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Incorrect match! Try again.')));

    setState(() {
      answer.status = WordStatus.disabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MultipleChoiceQuestion(
              question: _wordsToPlay[_currentQuestion],
              answers: _answers,
              onAnswerSelected: _questionCompleted ? null : _verifyAnswer,
              playWithTranslations: widget.playWithTranslations,
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
                              _getAnswers();
                            }
                            : null,
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(200, 50),
                      backgroundColor:
                          Theme.of(context).colorScheme.onPrimaryFixed,
                      foregroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Next', style: TextStyle(fontSize: 20)),
                          SizedBox(width: 4),
                          Icon(Icons.navigate_next, size: 32),
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
