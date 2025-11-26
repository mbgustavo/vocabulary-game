import 'package:flutter/material.dart';
import 'package:vocabulary_game/games/connection_game.dart';
import 'package:vocabulary_game/games/get_words_for_game.dart';
import 'package:vocabulary_game/games/multiple_choice_game.dart';
import 'package:vocabulary_game/games/write_game.dart';
import 'package:vocabulary_game/models/word.dart';
import 'package:vocabulary_game/screens/home.dart';

enum Game {
  connection,
  multipleChoice,
  multipleChoiceReversed,
  write,
  writeReversed,
}

const defaultQty = 5;

class GameScreen extends StatefulWidget {
  final List<Word> vocabulary;
  final Game game;
  final int wordsQty;

  const GameScreen({
    super.key,
    required this.vocabulary,
    required this.game,
    this.wordsQty = defaultQty,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<Word> _wordsToPlay;

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  String get gameTitle {
    switch (widget.game) {
      case Game.connection:
        return 'Connection Game';
      case Game.multipleChoice:
      case Game.multipleChoiceReversed:
        return 'Multiple Choice Game';
      case Game.write:
      case Game.writeReversed:
        return 'Write Game';
    }
  }

  void _resetGame() {
    try {
      setState(() {
        _wordsToPlay = getWordsForGame(widget.vocabulary, widget.wordsQty);
      });
    } catch (e) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (ctx) => const HomeScreen()));
    }
  }

  Widget get gameWidget {
    switch (widget.game) {
      case Game.connection:
        return ConnectionGame(_wordsToPlay, onReset: _resetGame);
      case Game.multipleChoice:
        return MultipleChoiceGame(_wordsToPlay, vocabulary: widget.vocabulary, onReset: _resetGame);
      case Game.multipleChoiceReversed:
        return MultipleChoiceGame(
          _wordsToPlay,
          vocabulary: widget.vocabulary,
          onReset: _resetGame,
          playWithTranslations: true,
        );
      case Game.write:
        return WriteGame(_wordsToPlay, onReset: _resetGame);
      case Game.writeReversed:
        return WriteGame(_wordsToPlay, onReset: _resetGame, playWithTranslations: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(gameTitle)), body: gameWidget);
  }
}
