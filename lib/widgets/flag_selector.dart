import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class FlagSelector extends StatelessWidget {
  final Function(Emoji) onEmojiSelected;

  const FlagSelector({super.key, required this.onEmojiSelected});

  @override
  Widget build(BuildContext context) {
    // Pegue os emojis da categoria desejada
    final flagEmojis = defaultEmojiSet.firstWhere((emoji) {
      return emoji.category == Category.FLAGS;
    }).emoji;

    return GridView.builder(
      itemCount: flagEmojis.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
      ),
      itemBuilder: (context, index) {
        final emoji = flagEmojis[index];
        return GestureDetector(
          onTap: () => onEmojiSelected(emoji),
          child: Center(child: Text(emoji.emoji, style: TextStyle(fontSize: 24))),
        );
      },
    );
  }
}