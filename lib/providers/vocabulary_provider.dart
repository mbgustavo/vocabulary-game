import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocabulary_game/models/word.dart';
import 'package:vocabulary_game/storage/storage_interface.dart';
import 'package:vocabulary_game/storage/pref_storage.dart';
import 'package:vocabulary_game/providers/notifications_provider.dart';

class VocabularyNotifier extends StateNotifier<Map<String, dynamic>> {
  VocabularyNotifier(this.ref) : super({}) {
    _storage = PrefStorage();
    state = {'loading': true};
    loadVocabulary();
  }

  final Ref ref;
  late StorageInterface _storage;
  int? _loadingErrorNotification;

  Future<void> loadVocabulary() async {
    try {
      final vocabulary = await _storage.getVocabulary();
      state = {...state, 'vocabulary': vocabulary};

      if (_loadingErrorNotification != null) {
        ref
            .read(notificationsProvider.notifier)
            .dismissNotification(_loadingErrorNotification!);
        _loadingErrorNotification = null;
      }
    } catch (e) {
      ref.read(notificationsProvider.notifier).clearNotifications();
      _loadingErrorNotification = ref
          .read(notificationsProvider.notifier)
          .pushNotification(
            CustomNotification(
              'Failed to load vocabulary: ${e.toString()}',
              type: NotificationType.error,
              isDismissable: false,
            ),
          );
    } finally {
      state = {...state, 'loading': false};
    }
  }

  List<Word> getVocabulary({String? language}) {
  if (language != null && language.isNotEmpty) {
      return (state['vocabulary'] ?? [])
          .where((word) => word.language == language)
          .toList() as List<Word>;
    }
    return (state['vocabulary'] ?? []) as List<Word>;
  }

  Future<String?> saveWord(Word word) async {
    try {
      final vocabulary = await _storage.saveWord(word);
      state = {...state, 'vocabulary': vocabulary};
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> updateWordsLanguage(String oldLanguage, String newLanguage) async {
    try {
      final updatedVocabulary = await _storage.updateWordsLanguage(oldLanguage, newLanguage);
      state = {...state, 'vocabulary': updatedVocabulary};
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> deleteWord(Word word) async {
    try {
      final remainingVocabulary = await _storage.deleteWord(word);
      state = {...state, 'vocabulary': remainingVocabulary};
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> deleteWordsByLanguage(String language) async {
    try {
      final remainingVocabulary = await _storage.deleteWordsByLanguage(language);
      state = {...state, 'vocabulary': remainingVocabulary};
    } catch (e) {
      ref.read(notificationsProvider.notifier).pushNotification(
        CustomNotification(
          'Failed to delete words for language $language: ${e.toString()}',
          type: NotificationType.error,
          isDismissable: false,
        ),
      );
    }
  }
}

final vocabularyProvider = StateNotifierProvider<VocabularyNotifier, Map>(
  (ref) => VocabularyNotifier(ref),
);
