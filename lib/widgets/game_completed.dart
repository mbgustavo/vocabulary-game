import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GameCompleted extends StatelessWidget {
  final void Function()? onReset;

  const GameCompleted({super.key, this.onReset});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.gameCompleteMessage,
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
            label: Text(l10n.commonPlayAgain, style: TextStyle(fontSize: 18)),
          ),
        const SizedBox(height: 20),
      ],
    );
  }
}
