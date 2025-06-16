import 'package:flutter/material.dart';
import 'package:vocabulary_game/models/language.dart';
import 'package:vocabulary_game/widgets/language_item.dart';

class LanguageList extends StatelessWidget {
  const LanguageList({
    super.key,
    required this.languages,
    required this.learningLanguage,
    required this.onTap,
    required this.onDelete,
  });

  final List<Language> languages;
  final String learningLanguage;
  final void Function(Language language) onTap;
  final Future<void> Function(BuildContext context, Language language) onDelete;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: languages.length,
      itemBuilder: (ctx, index) {
        final isSelected = languages[index].value == learningLanguage;

        return LanguageItem(
          language: languages[index],
          isSelected: isSelected,
          onTap: isSelected ? null : onTap,
          onDelete: onDelete,
        );
      },
    );
  }
}
