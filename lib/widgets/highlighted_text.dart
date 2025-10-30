import 'package:flutter/material.dart';

class HighlightedText extends StatelessWidget {
  final String text;

  const HighlightedText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            foreground:
                Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 2
                  ..color = const Color.fromARGB(222, 33, 99, 36)
                  ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1),
          ),
        ),
        Text(text, style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface)),
      ],
    );
  }
}
