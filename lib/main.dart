import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocabulary_game/providers/settings_provider.dart';
import 'package:vocabulary_game/providers/vocabulary_provider.dart';
import 'package:vocabulary_game/screens/home.dart';

void main() {
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final loading =
        ref.watch(settingsProvider)['loading'] ||
        ref.watch(vocabularyProvider)['loading'];

    return MaterialApp(
      title: 'Vocabulary Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
        ),
      ),
      home:
          loading
              ? Scaffold(
                appBar: AppBar(title: const Text('Vocabulary Game')),
                body: const Center(child: Text("Loading...")),
              )
              : const HomeScreen(),
    );
  }
}
