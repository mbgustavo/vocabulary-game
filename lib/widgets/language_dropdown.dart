import 'package:flutter/material.dart';
import 'package:vocabulary_game/models/language.dart';

class LanguageDropdown extends StatelessWidget {
  final List<Language> languages;
  final String selectedLanguage;
  final void Function(String? value) onChanged;
  final bool showAllLanguages;

  const LanguageDropdown({
    super.key,
    required this.languages,
    required this.selectedLanguage,
    required this.onChanged,
    this.showAllLanguages = false,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: selectedLanguage,
      items: [
        if (showAllLanguages)
          DropdownMenuItem(value: '', child: Text('All Languages')),
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
      onChanged: onChanged,
    );
  }
}
