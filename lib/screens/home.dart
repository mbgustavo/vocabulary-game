import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocabulary_game/l10n/app_localizations.dart';
import 'package:vocabulary_game/providers/languages_provider.dart';
import 'package:vocabulary_game/providers/vocabulary_provider.dart';
import 'package:vocabulary_game/screens/data.dart';
import 'package:vocabulary_game/screens/game_select.dart';
import 'package:vocabulary_game/screens/language.dart';
import 'package:vocabulary_game/screens/vocabulary.dart';
import 'package:vocabulary_game/widgets/notification_banners.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    ref.watch(languagesProvider)["learning_language"];
    ref.watch(vocabularyProvider)["vocabulary"];
    final learningLanguage =
        ref.read(languagesProvider.notifier).getLearningLanguage();
    final vocabulary = ref
        .read(vocabularyProvider.notifier)
        .getVocabulary(language: learningLanguage.value);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.appTitle)),
      body: Stack(
        children: [
          NotificationBanners(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.homeWelcome),
                SizedBox(height: 20),
                Text(
                  AppLocalizations.of(
                    context,
                  )!.homeYouAreLearning(learningLanguage.name),
                ),
                SizedBox(height: 80),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.onPrimaryFixed,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed:
                      vocabulary.length < 5
                          ? null
                          : () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => GameSelectScreen(),
                              ),
                            );
                          },
                  child: Text(AppLocalizations.of(context)!.homeStartGame),
                ),
                if (vocabulary.length < 5)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      AppLocalizations.of(context)!.homeVocabularyTooSmall,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.onPrimaryFixed,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => const VocabularyScreen(),
                      ),
                    );
                  },
                  child: Text(AppLocalizations.of(context)!.homeVocabulary),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.onPrimaryFixed,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => const LanguageScreen(),
                      ),
                    );
                  },
                  child: Text(AppLocalizations.of(context)!.homeLanguages),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (ctx) => DataScreen()));
        },
        tooltip: AppLocalizations.of(context)!.dataTooltip,
        child: const Icon(Icons.storage),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
