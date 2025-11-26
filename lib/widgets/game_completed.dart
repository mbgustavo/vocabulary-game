import 'package:flutter/material.dart';

class GameCompleted extends StatelessWidget {
  final void Function()? onReset;

  const GameCompleted({super.key, this.onReset});

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
        const SizedBox(height: 20),
        if (onReset != null)
          ElevatedButton.icon(
            onPressed: onReset,
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(200, 48),
              backgroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
            icon: const Icon(Icons.restart_alt, size: 28),
            label: const Text('Play again', style: TextStyle(fontSize: 18)),
          ),
      ],
    );
  }
}
