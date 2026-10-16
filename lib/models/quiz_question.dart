class QuizQuestion {
  final List<String> imageUrls;
  final String correctAnswer;
  final List<String> options;
  final String continent;

  const QuizQuestion({
    required this.imageUrls,
    required this.correctAnswer,
    required this.options,
    required this.continent,
  });
}
