import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocabulary_game/models/language.dart';
import 'package:vocabulary_game/providers/settings_provider.dart';
import 'package:vocabulary_game/widgets/flag_selector.dart';

class NewLanguage extends ConsumerStatefulWidget {
  final Language? initialLanguage;

  const NewLanguage({super.key, this.initialLanguage});

  @override
  ConsumerState<NewLanguage> createState() => _NewLanguageState();
}

class _NewLanguageState extends ConsumerState<NewLanguage> {
  final _formKey = GlobalKey<FormState>();
  String _enteredEmoji = '';
  String _enteredName = '';
  bool _showEmojiPicker = false;
  bool _isSending = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.initialLanguage != null) {
      _enteredName = widget.initialLanguage!.name;
      _enteredEmoji = widget.initialLanguage!.icon;
    }
  }

  void _saveLanguage() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isSending = true;
      });
      final newLanguage = Language(_enteredName, _enteredEmoji);
      String? error;
      if (widget.initialLanguage != null) {
        error = await ref
          .read(settingsProvider.notifier)
          .updateLanguage(widget.initialLanguage!, newLanguage);
      } else {
        error = await ref
          .read(settingsProvider.notifier)
          .addLanguage(newLanguage);
      }

      setState(() {
        _isSending = false;
        _error = error;
      });

      if (error == null && mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  void _onEmojiSelected(Emoji emoji) {
    setState(() {
      _enteredEmoji = emoji.emoji;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _enteredEmoji != ""
                    ? TextButton(
                      onPressed: () {
                        setState(() {
                          _showEmojiPicker = !_showEmojiPicker;
                        });
                      },
                      child: Text(
                        _enteredEmoji,
                        style: TextStyle(fontSize: 24),
                      ),
                    )
                    : IconButton(
                      icon: Icon(Icons.flag_circle),
                      iconSize: 30,
                      onPressed: () {
                        setState(() {
                          _showEmojiPicker = !_showEmojiPicker;
                        });
                      },
                    ),
                Expanded(
                  child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    maxLength: 30,
                    decoration: const InputDecoration(label: Text('Name')),
                    initialValue: _enteredName,
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
                      _error = null;
                      _enteredName = value!;
                    },
                  ),
                ),
              ],
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed:
                      _isSending
                          ? null
                          : () {
                            _formKey.currentState!.reset();
                            Navigator.of(context).pop();
                          },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _isSending ? null : _saveLanguage,
                  child:
                      _isSending
                          ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(),
                          )
                          : const Text('Save language'),
                ),
              ],
            ),
            if (_showEmojiPicker)
              Column(
                children: [
                  SizedBox(height: 12),
                  SizedBox(
                    height: 250,
                    child: FlagSelector(
                      onEmojiSelected: (emoji) {
                        setState(() {
                          _showEmojiPicker = false;
                        });
                        _onEmojiSelected(emoji);
                      },
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
