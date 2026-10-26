import 'package:ventur_2/models/game_mode.dart';

/// Result of one level in one game mode.
class QuizProgress {
  final GameMode mode;
  final int level;
  final bool completed;

  /// 0-3. Fewer wrong guesses earn more stars.
  final int stars;

  const QuizProgress({
    required this.mode,
    required this.level,
    this.completed = false,
    this.stars = 0,
  });

  Map<String, dynamic> toJson() => {
    'mode': mode.name,
    'level': level,
    'completed': completed,
    'stars': stars,
  };

  factory QuizProgress.fromJson(Map<String, dynamic> json) {
    return QuizProgress(
      mode: GameMode.fromName(json['mode'] as String?),
      level: json['level'] as int,
      completed: (json['completed'] as bool?) ?? false,
      stars: (json['stars'] as int?) ?? 0,
    );
  }
}
