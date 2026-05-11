import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocabulary_game/l10n/app_localizations.dart';
import 'package:vocabulary_game/models/settings.dart';
import 'package:vocabulary_game/providers/settings_provider.dart';
import 'package:vocabulary_game/providers/word_of_the_moment_notification_service_provider.dart';
import 'package:vocabulary_game/utils/platform_info.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class WordOfTheMomentNotificationsSection extends ConsumerStatefulWidget {
  const WordOfTheMomentNotificationsSection({
    super.key,
    required this.onSettingsChanged,
  });

  final Future<void> Function(AppSettings) onSettingsChanged;

  @override
  ConsumerState<WordOfTheMomentNotificationsSection> createState() =>
      _WordOfTheMomentNotificationsSectionState();
}

class _WordOfTheMomentNotificationsSectionState
    extends ConsumerState<WordOfTheMomentNotificationsSection> {
  String _intervalText = '';
  IntervalType _intervalType = IntervalType.hours;
  TimeOfDay? _startTime;
  late final TextEditingController _intervalController;
  final GlobalKey<TooltipState> _notificationsTooltipKey =
      GlobalKey<TooltipState>();

  @override
  void initState() {
    super.initState();
    _intervalController = TextEditingController();
    if (platformInfo.isAndroid || platformInfo.isIOS) {
      Permission.notification.request();
    }

    final settings = ref.read(settingsProvider)['settings'] as AppSettings?;
    if (settings != null) {
      _syncLocalFields(settings);
    }
  }

  @override
  void dispose() {
    _intervalController.dispose();
    super.dispose();
  }

  void _syncLocalFields(AppSettings settings) {
    setState(() {
      settings.wordOfTheMomentSettings.interval?.type ?? IntervalType.hours;
      _intervalText =
          settings.wordOfTheMomentSettings.interval?.value.toString() ?? '';
      _intervalController.text = _intervalText;
      _startTime = settings.wordOfTheMomentSettings.startTime;
    });
  }

  Future<void> _updateSettings({
    bool? notificationsEnabled,
    IntervalType? intervalType,
    String? intervalText,
    TimeOfDay? startTime,
  }) async {
    final current = ref.read(settingsProvider.notifier).getSettings();
    final currentWordSettings = current.wordOfTheMomentSettings;
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
        fullVocabularyEnabled: currentWordSettings.fullVocabularyEnabled,
        wordLevelWeights: currentWordSettings.wordLevelWeights,
        interval: updatedInterval,
        startTime: startTime ?? currentWordSettings.startTime,
      ),
    );

    if (mounted) {
      setState(() {
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

    await widget.onSettingsChanged(updatedSettings);
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

  @override
  Widget build(BuildContext context) {
    final settingsState = ref.watch(settingsProvider);
    final settings =
        settingsState['settings'] as AppSettings? ?? defaultSettings;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        ListTile(
          title: Text(l10n.wordOfTheMomentNotificationsEnabled),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Switch(
                value: settings.wordOfTheMomentSettings.notificationsEnabled,
                onChanged: (value) async {
                  await _updateSettings(notificationsEnabled: value);
                },
              ),
              const SizedBox(width: 8),
              Tooltip(
                key: _notificationsTooltipKey,
                message: l10n.wordOfTheMomentNotificationsScheduled(
                  notificationsQueue,
                ),
                child: GestureDetector(
                  onTap: () {
                    _notificationsTooltipKey.currentState
                        ?.ensureTooltipVisible();
                  },
                  child: const Icon(Icons.info_outline, size: 28),
                ),
              ),
            ],
          ),
        ),
        if (settings.wordOfTheMomentSettings.notificationsEnabled)
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
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    SizedBox(
                      width: 35,
                      child: TextFormField(
                        controller: _intervalController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        onChanged: (value) async {
                          await _updateSettings(intervalText: value);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 100,
                      child: DropdownButtonFormField<IntervalType>(
                        isExpanded: true,
                        initialValue: _intervalType,
                        items:
                            IntervalType.values.map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(
                                  type == IntervalType.hours
                                      ? l10n.wordOfTheMomentIntervalHours
                                      : l10n.wordOfTheMomentIntervalDays,
                                ),
                              );
                            }).toList(),
                        onChanged: (type) async {
                          if (type != null) {
                            await _updateSettings(intervalType: type);
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
                        style: Theme.of(context).textTheme.titleMedium,
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
    );
  }
}
