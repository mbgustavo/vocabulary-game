import 'package:shared_preferences/shared_preferences.dart';

import 'mocks.dart';

/// Utility class for managing SharedPreferences in integration tests
class TestPrefsHelper {
  /// Clears all SharedPreferences data
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// Sets up default test data
  static Future<void> setupTestData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    await prefs.setString('languages', mockLanguages);
    await prefs.setString('vocabulary', mockVocabulary);
    await prefs.setString('learning_language', 'spanish');
  }

  /// Sets pref data for a specific key
  static Future<void> setTestDataByKey(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }
}
