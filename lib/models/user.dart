import 'dart:math';

class UserStatistics {
  final int totalCorrect;
  final int totalWrong;
  final int totalSkipped;
  final int gamesLost;

  const UserStatistics({
    this.totalCorrect = 0,
    this.totalWrong = 0,
    this.totalSkipped = 0,
    this.gamesLost = 0,
  });

  UserStatistics copyWith({
    int? totalCorrect,
    int? totalWrong,
    int? totalSkipped,
    int? gamesLost,
  }) {
    return UserStatistics(
      totalCorrect: totalCorrect ?? this.totalCorrect,
      totalWrong: totalWrong ?? this.totalWrong,
      totalSkipped: totalSkipped ?? this.totalSkipped,
      gamesLost: gamesLost ?? this.gamesLost,
    );
  }

  Map<String, dynamic> toJson() => {
    'totalCorrect': totalCorrect,
    'totalWrong': totalWrong,
    'totalSkipped': totalSkipped,
    'gamesLost': gamesLost,
  };

  factory UserStatistics.fromJson(Map<String, dynamic> json) {
    return UserStatistics(
      totalCorrect: (json['totalCorrect'] as int?) ?? 0,
      totalWrong: (json['totalWrong'] as int?) ?? 0,
      totalSkipped: (json['totalSkipped'] as int?) ?? 0,
      gamesLost: (json['gamesLost'] as int?) ?? 0,
    );
  }
}

class User {
  static const int maxLives = 3;
  static const int startingCoins = 120;
  static const int startingHints = 3;

  final String id;
  final int coins;

  /// Lives left on the current level (resets to [maxLives] on a new level
  /// or retry).
  final int lives;
  final int hints;

  /// Level the player resumes on.
  final int currentLevel;

  /// Furthest level the player has reached.
  final int highestLevel;

  final UserStatistics statistics;

  const User({
    required this.id,
    required this.coins,
    required this.lives,
    required this.hints,
    required this.currentLevel,
    required this.highestLevel,
    this.statistics = const UserStatistics(),
  });

  factory User.newPlayer() {
    final rand = Random().nextInt(1 << 32).toRadixString(36);
    return User(
      id: '${DateTime.now().microsecondsSinceEpoch.toRadixString(36)}$rand',
      coins: startingCoins,
      lives: maxLives,
      hints: startingHints,
      currentLevel: 1,
      highestLevel: 1,
    );
  }

  User copyWith({
    int? coins,
    int? lives,
    int? hints,
    int? currentLevel,
    int? highestLevel,
    UserStatistics? statistics,
  }) {
    return User(
      id: id,
      coins: coins ?? this.coins,
      lives: lives ?? this.lives,
      hints: hints ?? this.hints,
      currentLevel: currentLevel ?? this.currentLevel,
      highestLevel: highestLevel ?? this.highestLevel,
      statistics: statistics ?? this.statistics,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'coins': coins,
    'lives': lives,
    'hints': hints,
    'currentLevel': currentLevel,
    'highestLevel': highestLevel,
    'statistics': statistics.toJson(),
  };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      coins: json['coins'] as int,
      lives: (json['lives'] as int?) ?? maxLives,
      hints: json['hints'] as int,
      currentLevel: json['currentLevel'] as int,
      highestLevel: (json['highestLevel'] as int?) ?? json['currentLevel'] as int,
      statistics: UserStatistics.fromJson(
        (json['statistics'] as Map<String, dynamic>?) ?? const {},
      ),
    );
  }
}
