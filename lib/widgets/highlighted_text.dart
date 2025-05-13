import 'package:flutter/material.dart';

class Highlightedtext extends StatelessWidget {
  const Highlightedtext(this.text, {super.key});

  final String text;

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
                  ..color = const Color.fromARGB(155, 45, 130, 48)
                  ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1),
          ),
        ),
        Text(text, style: TextStyle(fontSize: 16, color: Colors.black)),
      ],
    );
  }
}
