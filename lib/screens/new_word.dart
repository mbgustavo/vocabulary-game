import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocabulary_game/models/word.dart';
import 'package:vocabulary_game/providers/notifications_provider.dart';
import 'package:vocabulary_game/providers/settings_provider.dart';
import 'package:vocabulary_game/providers/vocabulary_provider.dart';

class NewWordScreen extends ConsumerStatefulWidget {
  const NewWordScreen({super.key, this.initialWord});

  final Word? initialWord;

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
      _selectedLanguage = ref.read(settingsProvider)["learning_language"];
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
    final languages = ref.read(settingsProvider.notifier).getLanguages();

    return Scaffold(
      appBar: AppBar(title: const Text('Add new word')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField(
                value: _selectedLanguage,
                items: [
                  for (final language in languages)
                    DropdownMenuItem(
                      value: language.value,
                      child: Row(
                        children: [
                          Text(language.icon),
                          const SizedBox(width: 6),
                          Text(language.name),
                        ],
                      ),
                    ),
                ],
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
                decoration: const InputDecoration(label: Text('Input word')),
                initialValue: _enteredInput,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 and 50 characters.';
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
                decoration: const InputDecoration(label: Text('Translation')),
                initialValue: _enteredTranslation,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 and 50 characters.';
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
              const Text("Examples (optional)"),
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
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
