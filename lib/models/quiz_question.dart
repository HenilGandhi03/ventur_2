class QuizQuestion {
  final List<String> imageUrls;
  final String correctAnswer;
  final List<String> options;
  final String continent;
  final String? description;
  final String? funfact;

  const QuizQuestion({
    required this.imageUrls,
    required this.correctAnswer,
    required this.options,
    required this.continent,
    this.description,
    this.funfact,
  });
}
