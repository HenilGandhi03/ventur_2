import 'package:ventur_2/models/game_save.dart';
import 'package:ventur_2/services/api_client.dart';

/// Talks to the backend's progress endpoints, keyed by the player's id.
///
/// This is intentionally not a [ProgressStorage] itself because that interface
/// has no user id on `load()` — the id lives inside the locally-cached save.
/// [CompositeProgressStorage] bridges the two.
class RemoteProgressStorage {
  final ApiClient _api;

  RemoteProgressStorage({ApiClient? api}) : _api = api ?? ApiClient();

  /// Returns the server's saved game for [userId], or null if none exists yet.
  Future<GameSave?> loadFor(String userId) async {
    final body = await _api.getJson('/users/$userId/progress');
    final data = (body is Map) ? body['data'] : null;
    if (data is! Map) return null;
    // Server returns user:null when nothing has been stored yet.
    if (data['user'] == null) return null;
    return GameSave.fromJson(Map<String, dynamic>.from(data));
  }

  /// Upserts [save] on the server under its user's id.
  Future<void> save(GameSave save) async {
    await _api.putJson('/users/${save.user.id}/progress', save.toJson());
  }
}
