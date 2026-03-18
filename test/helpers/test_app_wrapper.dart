import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocabulary_game/l10n/app_localizations.dart';
import 'package:vocabulary_game/providers/languages_provider.dart';

/// Wraps a widget with localization support for testing
///
/// This helper ensures that tests have access to AppLocalizations
/// by providing the necessary localizationsDelegates and reactive locale updates
Widget createTestAppWrapper({
  required Widget child,
  Locale locale = const Locale('en'),
}) {
  return _TestAppWrapper(initialLocale: locale, child: child);
}

class _TestAppWrapper extends ConsumerWidget {
  final Widget child;
  final Locale initialLocale;

  const _TestAppWrapper({required this.child, required this.initialLocale});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Try to watch languagesProvider for reactive locale updates
    // If it's not available or fails, fall back to initial locale
    Locale currentLocale = initialLocale;

    try {
      final languageState = ref.watch(languagesProvider);
      final appLanguage = languageState['app_language'] as String? ?? 'en';
      currentLocale = Locale(appLanguage);
    } catch (e) {
      // If languagesProvider is not properly initialized, use initial locale
      currentLocale = initialLocale;
    }

    return MaterialApp(
      locale: currentLocale,
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
      home: child,
    );
  }
}
