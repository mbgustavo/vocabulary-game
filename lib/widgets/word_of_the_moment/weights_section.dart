import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocabulary_game/l10n/app_localizations.dart';
import 'package:vocabulary_game/models/settings.dart';
import 'package:vocabulary_game/models/word.dart';
import 'package:vocabulary_game/providers/settings_provider.dart';
import 'package:vocabulary_game/utils/words.dart';

class WordOfTheMomentWeightsSection extends ConsumerStatefulWidget {
  const WordOfTheMomentWeightsSection({
    super.key,
    required this.onSettingsChanged,
  });

  final Future<void> Function(AppSettings settings) onSettingsChanged;

  @override
  ConsumerState<WordOfTheMomentWeightsSection> createState() =>
      _WordOfTheMomentWeightsSectionState();
}

class _WordOfTheMomentWeightsSectionState
    extends ConsumerState<WordOfTheMomentWeightsSection> {
  bool _customWeightsEnabled = false;
  Map<WordLevel, int>? _weights;
  final GlobalKey<TooltipState> _customWeightsTooltipKey =
      GlobalKey<TooltipState>();

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsProvider)['settings'] as AppSettings?;
    if (settings != null) {
      _syncLocalFields(settings);
    }
  }

  void _syncLocalFields(AppSettings settings) {
    setState(() {
      _customWeightsEnabled =
          settings.wordOfTheMomentSettings.wordLevelWeights != null;
      _weights = settings.wordOfTheMomentSettings.wordLevelWeights;
    });
  }

  Future<void> _updateSettings({
    bool? customWeightsEnabled,
    Map<WordLevel, int>? weights,
  }) async {
    final current = ref.read(settingsProvider.notifier).getSettings();
    final currentWordSettings = current.wordOfTheMomentSettings;
    final updatedWeights =
        customWeightsEnabled == false
            ? null
            : weights ?? currentWordSettings.wordLevelWeights ?? _weights;

    final updatedSettings = AppSettings(
      wordOfTheMomentSettings: WordOfTheMomentSettings(
        notificationsEnabled: currentWordSettings.notificationsEnabled,
        fullVocabularyEnabled: currentWordSettings.fullVocabularyEnabled,
        wordLevelWeights: updatedWeights,
        interval: currentWordSettings.interval,
        startTime: currentWordSettings.startTime,
      ),
    );

    if (mounted) {
      setState(() {
        if (customWeightsEnabled != null) {
          _customWeightsEnabled = customWeightsEnabled;
        }
        if (weights != null) {
          _weights = weights;
        }
      });
    }

    await widget.onSettingsChanged(updatedSettings);
  }

  Widget _buildWeightRow(WordLevel level) {
    final weight = _weights?[level] ?? defaultWordLevelWeights[level]!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              final nextValue = (weight - 1).clamp(0, 99);
              _updateSettings(weights: {...(_weights ?? {}), level: nextValue});
            },
            icon: const Icon(Icons.remove),
          ),
          Text('$weight', style: const TextStyle(fontWeight: FontWeight.bold)),
          IconButton(
            onPressed: () {
              final nextValue = (weight + 1).clamp(0, 99);
              _updateSettings(weights: {...(_weights ?? {}), level: nextValue});
            },
            icon: const Icon(Icons.add),
          ),
          Expanded(child: Text(level.label)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        ListTile(
          title: Text(l10n.wordOfTheMomentCustomWeightsTitle),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Switch(
                value: _customWeightsEnabled,
                onChanged: (value) async {
                  await _updateSettings(customWeightsEnabled: value);
                },
              ),
              const SizedBox(width: 8),
              Tooltip(
                key: _customWeightsTooltipKey,
                message: l10n.wordOfTheMomentCustomWeightsSubtitle,
                child: GestureDetector(
                  onTap: () {
                    _customWeightsTooltipKey.currentState
                        ?.ensureTooltipVisible();
                  },
                  child: const Icon(Icons.info_outline, size: 28),
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
      ],
    );
  }
}
