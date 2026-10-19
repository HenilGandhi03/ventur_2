import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ventur_2/models/user_progress.dart';

abstract class ProgressStorage {
  Future<UserProgress?> load();
  Future<void> save(UserProgress progress);
  Future<void> clear();
}

/// Stores progress as a single JSON string in SharedPreferences.
class SharedPrefsProgressStorage implements ProgressStorage {
  static const _key = 'user_progress_v1';

  @override
  Future<UserProgress?> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      if (raw == null) return null;

      return UserProgress.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      // Corrupt or incompatible data: start fresh rather than crash.
      return null;
    }
  }

  @override
  Future<void> save(UserProgress progress) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, jsonEncode(progress.toJson()));
    } catch (_) {
      // Persistence is best-effort; never break gameplay over it.
    }
  }

  @override
  Future<void> clear() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_key);
    } catch (_) {}
  }
}
