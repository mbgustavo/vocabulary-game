import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocabulary_game/l10n/app_localizations.dart';
import 'package:vocabulary_game/models/settings.dart';
import 'package:vocabulary_game/models/word.dart';
import 'package:vocabulary_game/providers/languages_provider.dart';
import 'package:vocabulary_game/providers/settings_provider.dart';
import 'package:vocabulary_game/providers/vocabulary_provider.dart';
import 'package:vocabulary_game/providers/word_of_the_moment_notification_service_provider.dart';
import 'package:vocabulary_game/utils/words.dart';
import 'package:vocabulary_game/widgets/notification_banners.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class WordOfTheMomentScreen extends ConsumerStatefulWidget {
  const WordOfTheMomentScreen({super.key});

  @override
  ConsumerState<WordOfTheMomentScreen> createState() =>
      _WordOfTheMomentScreenState();
}

class _WordOfTheMomentScreenState extends ConsumerState<WordOfTheMomentScreen> {
  Word? _selectedWord;
  bool _customWeightsEnabled = false;
  Map<WordLevel, int>? _weights;
  String _intervalText = '';
  IntervalType _intervalType = IntervalType.hours;
  TimeOfDay? _startTime;
  late final TextEditingController _intervalController;
  final GlobalKey<TooltipState> _customWeightsTooltipKey =
      GlobalKey<TooltipState>();
  final GlobalKey<TooltipState> _notificationsTooltipKey =
      GlobalKey<TooltipState>();

  @override
  void initState() {
    super.initState();
    _intervalController = TextEditingController();
    Permission.notification.request();

    final settings = ref.read(settingsProvider)['settings'] as AppSettings?;
    if (settings != null) {
      _syncLocalFields(settings);
      _generateWord(settings);
    }
  }

  @override
  void dispose() {
    _intervalController.dispose();
    super.dispose();
  }

  void _syncLocalFields(AppSettings settings) {
    setState(() {
      _customWeightsEnabled =
          settings.wordOfTheMomentSettings.wordLevelWeights != null;
      _weights = settings.wordOfTheMomentSettings.wordLevelWeights;
      _intervalType =
          settings.wordOfTheMomentSettings.interval?.type ?? IntervalType.hours;
      _intervalText =
          settings.wordOfTheMomentSettings.interval?.value.toString() ?? '';
      _intervalController.text = _intervalText;
      _startTime = settings.wordOfTheMomentSettings.startTime;
    });
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
      weights: _customWeightsEnabled ? _weights : null,
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

  Future<void> _updateSettings({
    bool? notificationsEnabled,
    bool? fullVocabularyEnabled,
    bool? customWeightsEnabled,
    Map<WordLevel, int>? weights,
    IntervalType? intervalType,
    String? intervalText,
    TimeOfDay? startTime,
  }) async {
    final current = ref.read(settingsProvider.notifier).getSettings();
    final currentWordSettings = current.wordOfTheMomentSettings;
    final updatedWeights =
        customWeightsEnabled == false
            ? null
            : weights ?? currentWordSettings.wordLevelWeights ?? _weights;
    final intervalValue = int.tryParse(intervalText ?? _intervalText);
    final updatedInterval =
        intervalValue != null
            ? NotificationInterval(
              value: intervalValue,
              type:
                  intervalType ??
                  currentWordSettings.interval?.type ??
                  _intervalType,
            )
            : currentWordSettings.interval != null ||
                (intervalText ?? _intervalText).isNotEmpty
            ? NotificationInterval(
              value: currentWordSettings.interval?.value ?? 0,
              type:
                  intervalType ??
                  currentWordSettings.interval?.type ??
                  _intervalType,
            )
            : null;

    final updatedSettings = AppSettings(
      wordOfTheMomentSettings: WordOfTheMomentSettings(
        notificationsEnabled:
            notificationsEnabled ?? currentWordSettings.notificationsEnabled,
        fullVocabularyEnabled:
            fullVocabularyEnabled ?? currentWordSettings.fullVocabularyEnabled,
        wordLevelWeights: updatedWeights,
        interval: updatedInterval,
        startTime: startTime ?? currentWordSettings.startTime,
      ),
    );

    if (mounted) {
      setState(() {
        if (notificationsEnabled != null) {
          _generateWord(updatedSettings);
        }
        if (fullVocabularyEnabled != null) {
          _generateWord(updatedSettings);
        }
        if (customWeightsEnabled != null) {
          _customWeightsEnabled = customWeightsEnabled;
        }
        if (weights != null) {
          _weights = weights;
        }
        if (intervalText != null) {
          _intervalText = intervalText;
        }
        if (intervalType != null) {
          _intervalType = intervalType;
        }
        if (startTime != null) {
          _startTime = startTime;
        }
      });
    }

    await _saveSettings(updatedSettings);
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      await _updateSettings(startTime: picked);
    }
  }

  Widget _buildWeightRow(WordLevel level) {
    final weight = _weights?[level] ?? 1;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              final nextValue = (weight - 1).clamp(1, 99);
              _updateSettings(weights: {...(_weights ?? {}), level: nextValue});
            },
            icon: const Icon(Icons.remove),
          ),
          Text('$weight', style: const TextStyle(fontWeight: FontWeight.bold)),
          IconButton(
            onPressed: () {
              final nextValue = (weight + 1).clamp(1, 99);
              _updateSettings(weights: {...(_weights ?? {}), level: nextValue});
            },
            icon: const Icon(Icons.add),
          ),
          Expanded(child: Text(level.label)),
        ],
      ),
    );
  }

  Widget _buildWordDisplay(AppLocalizations l10n) {
    if (_selectedWord == null) {
      return Text(l10n.wordOfTheMomentNoWords);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 300),
          child: Card(
            color: Theme.of(context).colorScheme.onPrimaryFixed,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${_selectedWord!.input} - ${_selectedWord!.translation}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(l10n.wordOfTheMomentLevel(_selectedWord!.level.label)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () {
            final settings = ref.read(settingsProvider.notifier).getSettings();
            _generateWord(settings);
          },
          style: ElevatedButton.styleFrom(fixedSize: const Size(240, 48)),
          icon: const Icon(Icons.restart_alt, size: 28),
          label: Text(
            l10n.wordOfTheMomentGenerateNewWord,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
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
                        Center(child: _buildWordDisplay(l10n)),
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
                        ListTile(
                          title: Text(l10n.wordOfTheMomentCustomWeightsTitle),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Switch(
                                value: _customWeightsEnabled,
                                onChanged: (value) async {
                                  await _updateSettings(
                                    customWeightsEnabled: value,
                                  );
                                },
                              ),
                              const SizedBox(width: 8),
                              Tooltip(
                                key: _customWeightsTooltipKey,
                                message:
                                    l10n.wordOfTheMomentCustomWeightsSubtitle,
                                child: GestureDetector(
                                  onTap: () {
                                    _customWeightsTooltipKey.currentState
                                        ?.ensureTooltipVisible();
                                  },
                                  child: const Icon(
                                    Icons.info_outline,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_customWeightsEnabled) ...[
                          _buildWeightRow(WordLevel.beginner),
                          _buildWeightRow(WordLevel.intermediate),
                          _buildWeightRow(WordLevel.advanced),
                          const SizedBox(height: 12),
                        ],
                        const Divider(),
                        const SizedBox(height: 8),
                        ListTile(
                          title: Text(l10n.wordOfTheMomentNotificationsEnabled),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Switch(
                                value:
                                    settings
                                        .wordOfTheMomentSettings
                                        .notificationsEnabled,
                                onChanged: (value) async {
                                  await _updateSettings(
                                    notificationsEnabled: value,
                                  );
                                },
                              ),
                              const SizedBox(width: 8),
                              Tooltip(
                                key: _notificationsTooltipKey,
                                message: l10n
                                    .wordOfTheMomentNotificationsScheduled(
                                      notificationsQueue,
                                    ),
                                child: GestureDetector(
                                  onTap: () {
                                    _notificationsTooltipKey.currentState
                                        ?.ensureTooltipVisible();
                                  },
                                  child: const Icon(
                                    Icons.info_outline,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (settings
                            .wordOfTheMomentSettings
                            .notificationsEnabled)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        l10n.wordOfTheMomentInterval,
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.titleMedium,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 35,
                                      child: TextFormField(
                                        controller: _intervalController,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(3),
                                        ],
                                        onChanged: (value) async {
                                          await _updateSettings(
                                            intervalText: value,
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    SizedBox(
                                      width: 100,
                                      child: DropdownButtonFormField<
                                        IntervalType
                                      >(
                                        isExpanded: true,
                                        initialValue: _intervalType,
                                        items:
                                            IntervalType.values.map((type) {
                                              return DropdownMenuItem(
                                                value: type,
                                                child: Text(
                                                  type == IntervalType.hours
                                                      ? l10n
                                                          .wordOfTheMomentIntervalHours
                                                      : l10n
                                                          .wordOfTheMomentIntervalDays,
                                                ),
                                              );
                                            }).toList(),
                                        onChanged: (type) async {
                                          if (type != null) {
                                            await _updateSettings(
                                              intervalType: type,
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        l10n.wordOfTheMomentStartTime,
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.titleMedium,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    ElevatedButton(
                                      onPressed: _pickStartTime,
                                      child: Text(
                                        _startTime != null
                                            ? _startTime!.format(context)
                                            : l10n.wordOfTheMomentPickTime,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
        ),
      ),
    );
  }
}
