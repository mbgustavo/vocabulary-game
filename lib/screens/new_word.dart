import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocabulary_game/l10n/app_localizations.dart';
import 'package:vocabulary_game/models/word.dart';
import 'package:vocabulary_game/providers/notifications_provider.dart';
import 'package:vocabulary_game/providers/languages_provider.dart';
import 'package:vocabulary_game/providers/vocabulary_provider.dart';
import 'package:vocabulary_game/widgets/language_dropdown.dart';

class NewWordScreen extends ConsumerStatefulWidget {
  final Word? initialWord;

  const NewWordScreen({super.key, this.initialWord});

  @override
  ConsumerState<NewWordScreen> createState() => _NewWordScreenState();
}

class _NewWordScreenState extends ConsumerState<NewWordScreen> {
  final _formKey = GlobalKey<FormState>();
  String _enteredInput = '';
  String _enteredTranslation = '';
  String _selectedLanguage = '';
  WordLevel _selectedLevel = WordLevel.beginner;
  final List<String> _examples = [''];

  @override
  void initState() {
    super.initState();
    if (widget.initialWord != null) {
      _enteredInput = widget.initialWord!.input;
      _enteredTranslation = widget.initialWord!.translation;
      _selectedLanguage = widget.initialWord!.language;
      _selectedLevel = widget.initialWord!.level;
      _examples.addAll(widget.initialWord!.examples);
    } else {
      _selectedLanguage = ref.read(languagesProvider)["learning_language"];
    }
  }

  void _addWord() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final examplesToSave = _examples.where((e) => e.isNotEmpty).toList();
      final newWord = Word(
        language: _selectedLanguage,
        input: _enteredInput,
        translation: _enteredTranslation,
        level: _selectedLevel,
        examples: examplesToSave,
        id: widget.initialWord?.id,
      );

      final error = await ref
          .read(vocabularyProvider.notifier)
          .saveWord(newWord);

      if (error != null) {
        ref
            .read(notificationsProvider.notifier)
            .pushNotification(
              CustomNotification(
                'Failed to save word: $error',
                type: NotificationType.error,
                isDismissable: true,
              ),
            );
        return;
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final languages = ref.read(languagesProvider.notifier).getLanguages();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.newWordTitle)),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              top: 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LanguageDropdown(
                  languages: languages,
                  selectedLanguage: _selectedLanguage,
                  onChanged: (value) {
                    setState(() {
                      _selectedLanguage = value!;
                    });
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  maxLength: 30,
                  decoration: InputDecoration(
                    label: Text(l10n.newWordInputLabel),
                  ),
                  initialValue: _enteredInput,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.trim().length > 50) {
                      return l10n.validationCharacterRange(1, 50);
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredInput = value!;
                  },
                ),
                TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  maxLength: 30,
                  decoration: InputDecoration(
                    label: Text(l10n.newWordTranslationLabel),
                  ),
                  initialValue: _enteredTranslation,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.trim().length > 50) {
                      return l10n.validationCharacterRange(1, 50);
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredTranslation = value!;
                  },
                ),
                SizedBox(height: 10),
                DropdownButtonFormField(
                  value: _selectedLevel,
                  decoration: InputDecoration(
                    labelText: l10n.fluencyLevel,
                    helper: Text(
                      l10n.fluencyLevelHelper,
                      style: TextStyle(
                        fontSize: 10,
                        color: Theme.of(
                          context,
                        ).colorScheme.secondary.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  items:
                      WordLevel.values.map((WordLevel level) {
                        return DropdownMenuItem<WordLevel>(
                          value: level,
                          child: Text(level.label),
                        );
                      }).toList(),

                  onChanged: (value) {
                    setState(() {
                      _selectedLevel = value!;
                    });
                  },
                ),
                SizedBox(height: 20),
                Text(l10n.newWordExamplesLabel),
                ..._examples.asMap().entries.map(
                  (entry) => TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    maxLength: 100,
                    initialValue: entry.value,
                    onSaved: (value) {
                      _examples[entry.key] = value ?? '';
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _examples.add('');
                    });
                  },
                  icon: Icon(Icons.plus_one),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: _addWord,
                  child: Text(l10n.commonSave),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
