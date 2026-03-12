import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vocabulary_game/storage/pref_storage.dart';
import 'package:vocabulary_game/providers/languages_provider.dart';
import 'package:vocabulary_game/providers/vocabulary_provider.dart';
import 'package:file_picker/file_picker.dart';

class DataScreen extends ConsumerWidget {
  const DataScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.dataTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Text(
              l10n.dataManageTitle,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _buildDataOption(
              context,
              icon: Icons.save,
              title: l10n.dataSaveBackupTitle,
              subtitle: l10n.dataSaveBackupSubtitle,
              onTap: () => _saveBackup(context, ref),
            ),
            const SizedBox(height: 16),
            _buildDataOption(
              context,
              icon: Icons.restore,
              title: l10n.dataRestoreBackupTitle,
              subtitle: l10n.dataRestoreBackupSubtitle,
              onTap: () => _restoreBackup(context, ref),
            ),
            const SizedBox(height: 16),
            _buildDataOption(
              context,
              icon: Icons.refresh,
              title: l10n.dataRestoreDefaultsTitle,
              subtitle: l10n.dataRestoreDefaultsSubtitle,
              onTap: () => _showRestoreDefaultsDialog(context, ref),
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(
          icon,
          color:
              isDestructive
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.primary,
          size: 32,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive ? Theme.of(context).colorScheme.error : null,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: Icon(
          Icons.chevron_right,
          color:
              isDestructive
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        onTap: onTap,
      ),
    );
  }

  void _saveBackup(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final defaultFileName = 'my_vocabulary_backup_$timestamp.json';

      // Get backup data from storage
      final storage = ref.read(storageProvider);
      final backupData = await storage.getBackupData();

      // Convert string to bytes for mobile platforms
      final bytes = utf8.encode(backupData);

      // Let user select where to save the backup with bytes
      String? selectedPath = await FilePicker.platform.saveFile(
        dialogTitle: l10n.dataSaveFileDialogTitle,
        fileName: defaultFileName,
        type: FileType.custom,
        allowedExtensions: ['json'],
        bytes: bytes,
      );

      if (selectedPath == null) {
        // User cancelled the dialog
        return;
      }

      if (context.mounted) {
        final filename = selectedPath.split('/').last;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.dataSaveSuccessMessage(filename)),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.dataSaveErrorMessage(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _restoreBackup(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      // Let user select backup file to restore
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        dialogTitle: l10n.dataRestoreFileDialogTitle,
        type: FileType.custom,
        allowedExtensions: ['json'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        // User cancelled the dialog
        return;
      }

      final selectedFile = result.files.first;
      if (selectedFile.path != null && context.mounted) {
        await _performRestore(context, ref, selectedFile.path!);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.dataRestoreErrorMessage(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showRestoreDefaultsDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.dataRestoreDefaultsTitle),
          content: Text(l10n.dataRestoreDefaultsConfirmMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.commonCancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _restoreDefaults(context, ref);
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: Text(l10n.dataRestoreDefaultsButton),
            ),
          ],
        );
      },
    );
  }

  void _restoreDefaults(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final storage = ref.read(storageProvider);
      await storage.restoreDefaults();

      // Refresh providers to reflect the changes
      ref.invalidate(languagesProvider);
      ref.invalidate(vocabularyProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.dataRestoreDefaultsSuccessMessage),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.dataRestoreDefaultsErrorMessage(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _performRestore(
    BuildContext context,
    WidgetRef ref,
    String filePath,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.dataConfirmRestoreTitle),
          content: Text(l10n.dataConfirmRestoreMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.commonCancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: Text(l10n.dataRestoreButton),
            ),
          ],
        );
      },
    );

    if (confirmed == true && context.mounted) {
      try {
        final storage = ref.read(storageProvider);
        await storage.restoreFromBackup(filePath);

        // Refresh providers to reflect the changes
        ref.invalidate(languagesProvider);
        ref.invalidate(vocabularyProvider);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.dataRestoreSuccessMessage),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.dataRestoreErrorMessage(e.toString())),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
