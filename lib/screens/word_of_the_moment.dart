import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocabulary_game/l10n/app_localizations.dart';
import 'package:vocabulary_game/models/settings.dart';
import 'package:vocabulary_game/models/word.dart';
import 'package:vocabulary_game/providers/languages_provider.dart';
import 'package:vocabulary_game/providers/settings_provider.dart';
import 'package:vocabulary_game/providers/vocabulary_provider.dart';
import 'package:vocabulary_game/providers/word_of_the_moment_notification_service_provider.dart';
import 'package:vocabulary_game/utils/platform_info.dart';
import 'package:vocabulary_game/utils/words.dart';
import 'package:vocabulary_game/widgets/notification_banners.dart';
import 'package:vocabulary_game/widgets/word_of_the_moment/display.dart';
import 'package:vocabulary_game/widgets/word_of_the_moment/notifications_section.dart';
import 'package:vocabulary_game/widgets/word_of_the_moment/weights_section.dart';

class WordOfTheMomentScreen extends ConsumerStatefulWidget {
  const WordOfTheMomentScreen({super.key});

  @override
  ConsumerState<WordOfTheMomentScreen> createState() =>
      _WordOfTheMomentScreenState();
}

class _WordOfTheMomentScreenState extends ConsumerState<WordOfTheMomentScreen> {
  Word? _selectedWord;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsProvider)['settings'] as AppSettings?;
    if (settings != null) {
      _generateWord(settings);
    }
  }

  void _generateWord(AppSettings settings) {
    final learningLanguage =
        ref.read(languagesProvider.notifier).getLearningLanguage();
    final vocabularyNotifier = ref.read(vocabularyProvider.notifier);
    final vocabulary = vocabularyNotifier.getVocabulary(
      language:
          settings.wordOfTheMomentSettings.fullVocabularyEnabled
              ? null
              : learningLanguage.value,
    );

    final word = getRandomWord(
      vocabulary,
      language:
          settings.wordOfTheMomentSettings.fullVocabularyEnabled
              ? null
              : learningLanguage,
      weights: settings.wordOfTheMomentSettings.wordLevelWeights,
    );

    setState(() {
      _selectedWord = word;
    });
  }

  Future<void> _saveSettings(AppSettings settings) async {
    final error = await ref
        .read(settingsProvider.notifier)
        .saveSettings(settings);
    if (error != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(
                context,
              )!.wordOfTheMomentSaveSettingsError(error),
            ),
          ),
        );
      }
      return;
    }
    ref
        .read(wordOfTheMomentNotificationServiceProvider)
        .scheduleNotifications();
  }

  Future<void> _updateSettings({bool? fullVocabularyEnabled}) async {
    final current = ref.read(settingsProvider.notifier).getSettings();
    final currentWordSettings = current.wordOfTheMomentSettings;

    final updatedSettings = AppSettings(
      wordOfTheMomentSettings: WordOfTheMomentSettings(
        notificationsEnabled: currentWordSettings.notificationsEnabled,
        fullVocabularyEnabled:
            fullVocabularyEnabled ?? currentWordSettings.fullVocabularyEnabled,
        wordLevelWeights: currentWordSettings.wordLevelWeights,
        interval: currentWordSettings.interval,
        startTime: currentWordSettings.startTime,
      ),
    );

    if (mounted) {
      setState(() {
        if (fullVocabularyEnabled != null) {
          _generateWord(updatedSettings);
        }
      });
    }

    await _saveSettings(updatedSettings);
  }

  @override
  Widget build(BuildContext context) {
    final settingsState = ref.watch(settingsProvider);
    final vocabularyState = ref.watch(vocabularyProvider);
    final languagesState = ref.watch(languagesProvider);
    final settings =
        settingsState['settings'] as AppSettings? ?? defaultSettings;
    final isLoading =
        settingsState['loading'] == true ||
        vocabularyState['loading'] == true ||
        languagesState['loading'] == true;
    final learningLanguage =
        ref.read(languagesProvider.notifier).getLearningLanguage();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.wordOfTheMomentTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child:
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const NotificationBanners(),
                        Center(
                          child: WordOfTheMomentDisplay(
                            generateWord: () {
                              final settings =
                                  ref
                                      .read(settingsProvider.notifier)
                                      .getSettings();
                              _generateWord(settings);
                            },
                            word: _selectedWord,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Divider(),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            l10n.wordOfTheMomentVocabularyScope,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        RadioGroup<bool>(
                          groupValue:
                              settings
                                  .wordOfTheMomentSettings
                                  .fullVocabularyEnabled,
                          onChanged: (value) async {
                            if (value != null) {
                              await _updateSettings(
                                fullVocabularyEnabled: value,
                              );
                            }
                          },
                          child: Column(
                            children: [
                              RadioListTile<bool>(
                                title: Text(
                                  l10n.wordOfTheMomentLearningLanguageOnly(
                                    learningLanguage.name,
                                  ),
                                ),
                                value: false,
                              ),
                              RadioListTile<bool>(
                                title: Text(
                                  l10n.wordOfTheMomentWholeVocabulary,
                                ),
                                value: true,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        WordOfTheMomentWeightsSection(
                          onSettingsChanged: _saveSettings,
                        ),
                        if (platformInfo.isAndroid || platformInfo.isIOS) ...[
                          const Divider(),
                          const SizedBox(height: 8),
                          WordOfTheMomentNotificationsSection(
                            onSettingsChanged: _saveSettings,
                          ),
                        ],
                      ],
                    ),
                  ),
        ),
      ),
    );
  }
}
