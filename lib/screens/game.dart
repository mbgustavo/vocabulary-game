import 'package:flutter/material.dart';
import 'package:vocabulary_game/games/connection_game.dart';
import 'package:vocabulary_game/games/multiple_choice_game.dart';
import 'package:vocabulary_game/models/word.dart';

enum Game {connection, multipleChoice, multipleChoiceReversed}

class GameScreen extends StatelessWidget {
  final List<Word> vocabulary;
  final Game game;

  const GameScreen({
    super.key,
    required this.vocabulary,
    required this.game,
  });

  String get gameTitle {
    switch (game) {
      case Game.connection:
        return 'Connection Game';
      case Game.multipleChoice:
      case Game.multipleChoiceReversed:
        return 'Multiple Choice Game';
    }
  }

  Widget get gameWidget {
    switch (game) {
      case Game.connection:
        return ConnectionGame(vocabulary);
      case Game.multipleChoice:
        return MultipleChoiceGame(vocabulary);
      case Game.multipleChoiceReversed:
        return MultipleChoiceGame(vocabulary, playWithTranslations: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(gameTitle)),
      body: gameWidget,
    );
  }
}
