enum GameMode {
  country;

  static GameMode fromName(String? name) {
    return GameMode.values.firstWhere(
      (m) => m.name == name,
      orElse: () => GameMode.country,
    );
  }
}
