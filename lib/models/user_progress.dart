/// The part of the quiz state that survives app restarts.
class UserProgress {
  final int currentLevel;
  final int coins;
  final int hints;

  // Mid-level state, so restarting the app can't be used to refill lives
  // or re-hide revealed hints.
  final int wrongAttempts;
  final int currentImageIndex;
  final int maxUnlockedImageIndex;
  final bool showOptions;
  final bool showContinent;

  const UserProgress({
    required this.currentLevel,
    required this.coins,
    required this.hints,
    this.wrongAttempts = 0,
    this.currentImageIndex = 0,
    this.maxUnlockedImageIndex = 0,
    this.showOptions = false,
    this.showContinent = false,
  });

  Map<String, dynamic> toJson() => {
    'currentLevel': currentLevel,
    'coins': coins,
    'hints': hints,
    'wrongAttempts': wrongAttempts,
    'currentImageIndex': currentImageIndex,
    'maxUnlockedImageIndex': maxUnlockedImageIndex,
    'showOptions': showOptions,
    'showContinent': showContinent,
  };

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      currentLevel: json['currentLevel'] as int,
      coins: json['coins'] as int,
      hints: json['hints'] as int,
      wrongAttempts: (json['wrongAttempts'] as int?) ?? 0,
      currentImageIndex: (json['currentImageIndex'] as int?) ?? 0,
      maxUnlockedImageIndex: (json['maxUnlockedImageIndex'] as int?) ?? 0,
      showOptions: (json['showOptions'] as bool?) ?? false,
      showContinent: (json['showContinent'] as bool?) ?? false,
    );
  }
}
