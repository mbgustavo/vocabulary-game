import 'package:flutter/material.dart';
import 'package:vocabulary_game/models/word.dart';
import 'package:vocabulary_game/widgets/word_card.dart';

class MultipleChoiceQuestion extends StatelessWidget {
  final Word question;
  final List<WordInGame> answers;
  final bool playWithTranslations;
  final void Function(WordInGame)? onAnswerSelected;

  const MultipleChoiceQuestion({
    super.key,
    required this.question,
    required this.answers,
    required this.onAnswerSelected,
    this.playWithTranslations = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
              playWithTranslations
                  ? question.translation
                  : question.input,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 36),
            for (final answer in answers)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: SizedBox(
                  height: 60,
                  width: 200,
                  child: WordCard(
                    word: answer,
                    getText:
                        (answer) =>
                            playWithTranslations
                                ? answer.input
                                : answer.translation,
                    onTap: onAnswerSelected,
                  ),
                ),
              ),
      ],
    );
  }
}