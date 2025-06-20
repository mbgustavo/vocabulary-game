import 'package:flutter/material.dart';
import 'package:vocabulary_game/games/connection_game.dart';
import 'package:vocabulary_game/models/word.dart';

class GameScreen extends StatefulWidget {
  final List<Word> vocabulary;

  const GameScreen(this.vocabulary, {super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connection Game')),
      body: ConnectionGame(widget.vocabulary),
    );
  }
}
