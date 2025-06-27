import 'package:flutter/material.dart';

class GameCompleted extends StatelessWidget {
  final void Function() onReset;

  const GameCompleted({super.key, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Congratulations! You completed the game!',
          style: TextStyle(
            fontSize: 20,
            color: const Color.fromARGB(255, 104, 235, 111),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 26),
        ElevatedButton(
          onPressed: onReset,
          style: ElevatedButton.styleFrom(
            fixedSize: Size(200, 50),
            backgroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
            foregroundColor: Theme.of(context).colorScheme.primary,
          ),
          child: const Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.restart_alt, size: 32),
                SizedBox(width: 4),
                Text('Play again', style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
