import 'package:ventur_2/models/quiz_question.dart';

class QuizState {
  final int currentRound;
  final int totalRounds;
  final int coins;
  final QuizQuestion question;
  final String? selectedAnswer;
  final bool answered;
  final bool showHint;
  final bool showContinent;

  const QuizState({
    required this.currentRound,
    required this.totalRounds,
    required this.coins,
    required this.question,
    this.selectedAnswer,
    this.answered = false,
    this.showHint = false,
    this.showContinent = false,
  });
}
