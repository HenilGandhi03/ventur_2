import 'quiz_question.dart';

class QuizState {
  final int currentRound;
  final int totalRounds;
  final int currentLevel;
  final int coins;
  final int hints;

  final bool isCorrect;
  final bool gameOver;

  final QuizQuestion question;

  final int currentImageIndex;
  final int maxUnlockedImageIndex;
  final int wrongAttempts;

  final bool showOptions;
  final bool showContinent;
  final bool showAnswer;

  final String? selectedAnswer;
  final bool answered;

  const QuizState({
    required this.currentRound,
    required this.totalRounds,
    required this.currentLevel,
    required this.coins,
    required this.hints,
    required this.question,

    this.isCorrect = false,
    this.gameOver = false,

    this.currentImageIndex = 0,
    this.maxUnlockedImageIndex = 0,
    this.wrongAttempts = 0,

    this.showOptions = false,
    this.showContinent = false,
    this.showAnswer = false,

    this.selectedAnswer,
    this.answered = false,
  });

  QuizState copyWith({
    int? currentRound,
    int? totalRounds,
    int? currentLevel,
    int? coins,
    int? hints,

    bool? isCorrect,
    bool? gameOver,

    QuizQuestion? question,

    int? currentImageIndex,
    int? maxUnlockedImageIndex,
    int? wrongAttempts,

    bool? showOptions,
    bool? showContinent,
    bool? showAnswer,

    String? selectedAnswer,
    bool? answered,
  }) {
    return QuizState(
      currentRound: currentRound ?? this.currentRound,
      totalRounds: totalRounds ?? this.totalRounds,
      currentLevel: currentLevel ?? this.currentLevel,
      coins: coins ?? this.coins,
      hints: hints ?? this.hints,

      isCorrect: isCorrect ?? this.isCorrect,
      gameOver: gameOver ?? this.gameOver,

      question: question ?? this.question,

      currentImageIndex: currentImageIndex ?? this.currentImageIndex,

      maxUnlockedImageIndex:
          maxUnlockedImageIndex ?? this.maxUnlockedImageIndex,

      wrongAttempts: wrongAttempts ?? this.wrongAttempts,

      showOptions: showOptions ?? this.showOptions,

      showContinent: showContinent ?? this.showContinent,

      showAnswer: showAnswer ?? this.showAnswer,

      selectedAnswer: selectedAnswer ?? this.selectedAnswer,

      answered: answered ?? this.answered,
    );
  }
}
