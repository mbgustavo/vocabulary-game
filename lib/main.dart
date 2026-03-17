import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocabulary_game/l10n/app_localizations.dart';
import 'package:vocabulary_game/providers/languages_provider.dart';
import 'package:vocabulary_game/providers/vocabulary_provider.dart';
import 'package:vocabulary_game/screens/home.dart';

void main() {
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final languageState = ref.watch(languagesProvider);

    // Get the current locale from the app_language in the state
    final Locale currentLocale = Locale(languageState['app_language'] ?? 'en');

    return MaterialApp(
      title: 'Vocabulary Game',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
        Locale('fr'),
        Locale('de'),
        Locale('it'),
        Locale('pt'),
      ],
      locale: currentLocale,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
        ),
      ),
      builder: (context, child) {
        return _AppBuilder(child: child!);
      },
      home: const HomeScreen(),
    );
  }
}

class _AppBuilder extends ConsumerWidget {
  final Widget child;

  const _AppBuilder({required this.child});

  @override
  Widget build(BuildContext context, ref) {
    final loading =
        ref.watch(languagesProvider)['loading'] ||
        ref.watch(vocabularyProvider)['loading'];

    if (loading) {
      return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.appTitle)),
        body: Center(child: Text(AppLocalizations.of(context)!.appLoading)),
      );
    }

    return child;
  }
}
