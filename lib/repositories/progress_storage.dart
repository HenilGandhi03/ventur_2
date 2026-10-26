import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ventur_2/models/game_save.dart';

abstract class ProgressStorage {
  Future<GameSave?> load();
  Future<void> save(GameSave save);
  Future<void> clear();
}

/// Stores the save as a single JSON string in SharedPreferences.
class SharedPrefsProgressStorage implements ProgressStorage {
  static const _key = 'game_save_v1';

  @override
  Future<GameSave?> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      if (raw == null) return null;

      return GameSave.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      // Corrupt or incompatible data: start fresh rather than crash.
      return null;
    }
  }

  @override
  Future<void> save(GameSave save) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, jsonEncode(save.toJson()));
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
