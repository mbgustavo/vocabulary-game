import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vocabulary_game/models/language.dart';
import 'package:vocabulary_game/providers/notifications_provider.dart';
import 'package:vocabulary_game/providers/languages_provider.dart';
import 'package:vocabulary_game/widgets/highlighted_text.dart';
import 'package:vocabulary_game/widgets/new_language.dart';

class LanguageItem extends ConsumerWidget {
  final Language language;
  final bool isSelected;

  const LanguageItem({
    super.key,
    required this.language,
    required this.isSelected,
  });

  Future<void> _onDelete(BuildContext context, WidgetRef ref) async {
    final error = await ref
        .read(languagesProvider.notifier)
        .deleteLanguage(language);
    if (error != null) {
      ref
          .read(notificationsProvider.notifier)
          .pushNotification(
            CustomNotification(
              'Failed to delete language: $error',
              type: NotificationType.error,
              isDismissable: false,
            ),
          );
    }
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.deleteLanguageTitle),
          content: Text(l10n.deleteLanguageConfirm(language.name)),
          actions: [
            TextButton(
              child: Text(l10n.commonCancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text(l10n.commonDelete),
              onPressed: () => _onDelete(context, ref),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      onTap:
          isSelected
              ? null
              : () => ref
                  .read(languagesProvider.notifier)
                  .changeLearningLanguage(language.value),
      leading: RichText(text: TextSpan(text: language.icon)),
      title: isSelected ? HighlightedText(language.name) : Text(language.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(child: NewLanguage(initialLanguage: language));
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
                onPressed: () => _showDeleteDialog(context, ref),
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
        ],
      ),
    );
  }
}
