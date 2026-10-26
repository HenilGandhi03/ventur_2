import 'dart:async';

import 'package:ventur_2/models/game_save.dart';
import 'package:ventur_2/repositories/progress_storage.dart';
import 'package:ventur_2/repositories/remote_progress_storage.dart';

/// Progress storage that keeps a fast local cache (SharedPreferences) in sync
/// with the backend.
///
/// - **Reads** prefer whichever copy is more advanced, so progress made on this
///   device while offline is never clobbered by a stale server copy, and vice
///   versa. If the server is unreachable, the local cache is used.
/// - **Writes** hit the local cache immediately (gameplay never waits on the
///   network) and push to the server in the background.
///
/// This gives durable, cross-session sync while remaining fully playable
/// offline. (Cross-*device* restore requires a stable user id, e.g. from a
/// future sign-in; today the id is generated per install.)
class CompositeProgressStorage implements ProgressStorage {
  final ProgressStorage local;
  final RemoteProgressStorage remote;

  CompositeProgressStorage({
    ProgressStorage? local,
    RemoteProgressStorage? remote,
  }) : local = local ?? SharedPrefsProgressStorage(),
       remote = remote ?? RemoteProgressStorage();

  @override
  Future<GameSave?> load() async {
    final localSave = await local.load();

    // No local save means no user id to query the server with — a fresh start.
    if (localSave == null) return null;

    try {
      final remoteSave = await remote.loadFor(localSave.user.id);
      if (remoteSave == null) {
        // Server has nothing yet; seed it with what we have locally.
        unawaited(_safePush(localSave));
        return localSave;
      }
      final chosen = _moreAdvanced(localSave, remoteSave);
      // Keep the local cache aligned with the chosen snapshot.
      await local.save(chosen);
      return chosen;
    } catch (_) {
      // Offline or server error: the local cache is authoritative.
      return localSave;
    }
  }

  @override
  Future<void> save(GameSave save) async {
    await local.save(save);
    unawaited(_safePush(save));
  }

  @override
  Future<void> clear() async {
    await local.clear();
    // The remote copy is intentionally left intact so progress can be restored.
  }

  Future<void> _safePush(GameSave save) async {
    try {
      await remote.save(save);
    } catch (_) {
      // Best-effort sync; a failed push will be retried on the next save.
    }
  }

  /// Pick the snapshot representing more progress. Highest reached level wins,
  /// then current level, then coins; ties favour the local (most recent) copy.
  GameSave _moreAdvanced(GameSave a, GameSave b) {
    int score(GameSave s) =>
        s.user.highestLevel * 1000000 + s.user.currentLevel * 1000 + s.user.coins;
    return score(b) > score(a) ? b : a;
  }
}
