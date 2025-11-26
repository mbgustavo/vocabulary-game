import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocabulary_game/games/connection_game.dart';
import 'package:vocabulary_game/games/get_words_for_game.dart';
import 'package:vocabulary_game/games/multiple_choice_game.dart';
import 'package:vocabulary_game/games/write_game.dart';
import 'package:vocabulary_game/models/word.dart';
import 'package:vocabulary_game/providers/settings_provider.dart';
import 'package:vocabulary_game/providers/vocabulary_provider.dart';
import 'package:vocabulary_game/screens/home.dart';

enum Game {
  connection,
  multipleChoice,
  multipleChoiceReversed,
  write,
  writeReversed,
}

const defaultQty = 5;

class GameScreen extends ConsumerStatefulWidget {
  final Game game;
  final int wordsQty;

  const GameScreen({super.key, required this.game, this.wordsQty = defaultQty});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  late List<Word> _wordsToPlay;
  late List<Word> _vocabulary;

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
      final learningLanguage =
          ref.read(settingsProvider.notifier).getLearningLanguage();
      final vocabulary = ref
          .read(vocabularyProvider.notifier)
          .getVocabulary(language: learningLanguage.value);
      setState(() {
        _wordsToPlay = getWordsForGame(vocabulary, widget.wordsQty);
        _vocabulary = vocabulary;
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
        return MultipleChoiceGame(
          _wordsToPlay,
          vocabulary: _vocabulary,
          onReset: _resetGame,
        );
      case Game.multipleChoiceReversed:
        return MultipleChoiceGame(
          _wordsToPlay,
          vocabulary: _vocabulary,
          onReset: _resetGame,
          playWithTranslations: true,
        );
      case Game.write:
        return WriteGame(_wordsToPlay, onReset: _resetGame);
      case Game.writeReversed:
        return WriteGame(
          _wordsToPlay,
          onReset: _resetGame,
          playWithTranslations: true,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(gameTitle)), body: gameWidget);
  }
}
