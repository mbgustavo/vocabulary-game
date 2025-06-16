import 'package:flutter/material.dart';
import 'package:vocabulary_game/models/language.dart';
import 'package:vocabulary_game/widgets/highlighted_text.dart';
import 'package:vocabulary_game/widgets/new_language.dart';

class LanguageItem extends StatelessWidget {
  const LanguageItem({
    super.key,
    required this.language,
    required this.isSelected,
    required this.onTap,
    required this.onDelete,
  });

  final Language language;
  final bool isSelected;
  final void Function(Language language)? onTap;
  final Future<void> Function(BuildContext context, Language language) onDelete;


  void showDeleteDialog(BuildContext context, Language language) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Language'),
          content: Text(
            "Are you sure you want to delete ${language.name} and its vocabulary? This action can't be undone.",
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Delete'),
              onPressed: () => onDelete(context, language),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap != null ? () => onTap!(language) : null,
      leading: RichText(text: TextSpan(text: language.icon)),
      title:
          isSelected
              ? Highlightedtext(language.name)
              : Text(language.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    child: NewLanguage(initialLanguage: language),
                  );
                },
              );
            },
            icon: Icon(Icons.edit),
          ),
          isSelected
              ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Icon(
                  Icons.check,
                  color: Color.fromARGB(255, 45, 130, 48),
                ),
              )
              : IconButton(
                onPressed: () => showDeleteDialog(context, language),
                icon: Icon(
                  Icons.delete,
                  color: const Color.fromARGB(255, 219, 121, 121),
                ),
              ),
        ],
      ),
    );
  }
}
