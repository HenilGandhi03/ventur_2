import 'package:ventur_2/models/quiz_progress.dart';
import 'package:ventur_2/models/user.dart';

/// Mid-level state, so restarting the app can't re-hide revealed hints
/// or reset which images were unlocked.
class LevelSession {
  final int currentImageIndex;
  final int maxUnlockedImageIndex;
  final bool showOptions;
  final bool showContinent;

  const LevelSession({
    this.currentImageIndex = 0,
    this.maxUnlockedImageIndex = 0,
    this.showOptions = false,
    this.showContinent = false,
  });

  Map<String, dynamic> toJson() => {
    'currentImageIndex': currentImageIndex,
    'maxUnlockedImageIndex': maxUnlockedImageIndex,
    'showOptions': showOptions,
    'showContinent': showContinent,
  };

  factory LevelSession.fromJson(Map<String, dynamic> json) {
    return LevelSession(
      currentImageIndex: (json['currentImageIndex'] as int?) ?? 0,
      maxUnlockedImageIndex: (json['maxUnlockedImageIndex'] as int?) ?? 0,
      showOptions: (json['showOptions'] as bool?) ?? false,
      showContinent: (json['showContinent'] as bool?) ?? false,
    );
  }
}

/// Everything persisted for a player.
class GameSave {
  final User user;
  final List<QuizProgress> progress;
  final LevelSession session;

  const GameSave({
    required this.user,
    this.progress = const [],
    this.session = const LevelSession(),
  });

  Map<String, dynamic> toJson() => {
    'user': user.toJson(),
    'progress': progress.map((p) => p.toJson()).toList(),
    'session': session.toJson(),
  };

  factory GameSave.fromJson(Map<String, dynamic> json) {
    return GameSave(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      progress: ((json['progress'] as List?) ?? const [])
          .map((p) => QuizProgress.fromJson(p as Map<String, dynamic>))
          .toList(),
      session: LevelSession.fromJson(
        (json['session'] as Map<String, dynamic>?) ?? const {},
      ),
    );
  }
}
