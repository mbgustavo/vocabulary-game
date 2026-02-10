import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocabulary_game/storage/pref_storage.dart';
import 'package:vocabulary_game/providers/languages_provider.dart';
import 'package:vocabulary_game/providers/vocabulary_provider.dart';
import 'package:file_picker/file_picker.dart';

class DataScreen extends ConsumerWidget {
  const DataScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Text(
              'Manage your vocabulary data',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _buildDataOption(
              context,
              icon: Icons.save,
              title: 'Save Backup',
              subtitle: 'Save your current vocabulary and languages',
              onTap: () => _saveBackup(context, ref),
            ),
            const SizedBox(height: 16),
            _buildDataOption(
              context,
              icon: Icons.restore,
              title: 'Restore Backup',
              subtitle: 'Restore from a previously saved backup',
              onTap: () => _restoreBackup(context, ref),
            ),
            const SizedBox(height: 16),
            _buildDataOption(
              context,
              icon: Icons.refresh,
              title: 'Restore Defaults',
              subtitle: 'Reset to default settings and clear all data',
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
          color: isDestructive
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
          color: isDestructive
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        onTap: onTap,
      ),
    );
  }

  void _saveBackup(BuildContext context, WidgetRef ref) async {
    try {
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final defaultFileName = 'my_vocabulary_backup_$timestamp.json';
      
      // Let user select where to save the backup
      String? selectedPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save vocabulary backup',
        fileName: defaultFileName,
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      
      if (selectedPath == null) {
        // User cancelled the dialog
        return;
      }
      
      final storage = ref.read(storageProvider);
      await storage.createBackup(selectedPath);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Backup saved successfully to:\n${selectedPath.split('/').last}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save backup: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _restoreBackup(BuildContext context, WidgetRef ref) async {
    try {
      // Let user select backup file to restore
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        dialogTitle: 'Select backup file to restore',
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
            content: Text('Failed to restore backup: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showRestoreDefaultsDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Restore Defaults'),
          content: const Text(
            'This will delete all your vocabulary data and languages, returning the app to its initial state. \n\n'
            'You can create a backup first if you want to save your current data. This action cannot be undone.\n\n'
            'Are you sure you want to continue? ',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _restoreDefaults(context, ref);
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Restore Defaults'),
            ),
          ],
        );
      },
    );
  }

  void _restoreDefaults(BuildContext context, WidgetRef ref) async {
    try {
      final storage = ref.read(storageProvider);
      await storage.restoreDefaults();
      
      // Refresh providers to reflect the changes
      ref.invalidate(languagesProvider);
      ref.invalidate(vocabularyProvider);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully restored to defaults'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to restore defaults: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  Future<void> _performRestore(BuildContext context, WidgetRef ref, String filePath) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Restore'),
          content: const Text(
            'This will replace all your current data with the backup data. '
            'This action cannot be undone.\n\nAre you sure you want to continue?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: const Text('Restore'),
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
            const SnackBar(
              content: Text('Backup restored successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to restore backup: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
