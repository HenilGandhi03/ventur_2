import 'package:ventur_2/models/quiz_question.dart';
import 'package:ventur_2/models/quiz_state.dart';
import 'package:ventur_2/repositories/quiz_repository.dart';

class QuizController {
  final QuizRepository repository;

  QuizState? state;

  List<QuizQuestion> _questions = [];

  QuizController(this.repository);

  Future<void> startQuiz() async {
    _questions = await repository.getQuestions();

    if (_questions.isEmpty) return;

    state = QuizState(
      currentRound: 1,
      totalRounds: _questions.length,
      currentLevel: 1,
      coins: 120,
      hints: 3,
      question: _questions.first,

      // Always start from image 1.
      currentImageIndex: 0,
      maxUnlockedImageIndex: 0,
      wrongAttempts: 0,

      showOptions: false,
      showContinent: false,
      showAnswer: false,

      selectedAnswer: null,
      answered: false,
      isCorrect: false,
      gameOver: false,
    );
  }

  void submitAnswer(String answer) {
    final currentState = state;

    if (currentState == null || currentState.answered) {
      return;
    }

    final isCorrect =
        answer.trim().toLowerCase() ==
        currentState.question.correctAnswer.trim().toLowerCase();

    if (isCorrect) {
      state = currentState.copyWith(
        selectedAnswer: answer,
        answered: true,
        isCorrect: true,
        gameOver: false,
      );

      return;
    }

    _handleWrongAnswer();
  }

  void _handleWrongAnswer() {
    final currentState = state;

    if (currentState == null) return;

    final newAttempts = currentState.wrongAttempts + 1;

    // --------------------------------------------------
    // 3 WRONG ANSWERS = GAME OVER
    // --------------------------------------------------
    if (newAttempts >= 3) {
      state = currentState.copyWith(
        wrongAttempts: newAttempts,
        answered: true,
        isCorrect: false,
        gameOver: true,
      );

      return;
    }

    // --------------------------------------------------
    // WRONG ANSWER = REVEAL NEXT IMAGE
    // --------------------------------------------------
    final lastImageIndex = currentState.question.imageUrls.length - 1;

    if (currentState.currentImageIndex < lastImageIndex) {
      final nextImage = currentState.currentImageIndex + 1;

      state = currentState.copyWith(
        wrongAttempts: newAttempts,

        // Move to next image.
        currentImageIndex: nextImage,

        // Unlock next image.
        maxUnlockedImageIndex: nextImage,

        selectedAnswer: null,
        answered: false,
        isCorrect: false,
      );

      return;
    }

    // Safety fallback if there are fewer images.
    state = currentState.copyWith(
      wrongAttempts: newAttempts,
      answered: newAttempts >= 3,
      isCorrect: false,
      gameOver: newAttempts >= 3,
    );
  }

  void nextImage() {
    final currentState = state;

    if (currentState == null) return;

    if (currentState.currentImageIndex < currentState.maxUnlockedImageIndex) {
      state = currentState.copyWith(
        currentImageIndex: currentState.currentImageIndex + 1,
      );
    }
  }

  void previousImage() {
    final currentState = state;

    if (currentState == null) return;

    if (currentState.currentImageIndex > 0) {
      state = currentState.copyWith(
        currentImageIndex: currentState.currentImageIndex - 1,
      );
    }
  }

  // --------------------------------------------------
  // REVEAL MORE HINT
  // --------------------------------------------------

  void revealOptions() {
    final currentState = state;

    if (currentState == null) return;

    // No hints left.
    if (currentState.hints <= 0) return;

    // Already revealed.
    if (currentState.showOptions) return;

    state = currentState.copyWith(
      hints: currentState.hints - 1,
      showOptions: true,
    );
  }

  // --------------------------------------------------
  // CONTINENT HINT
  // --------------------------------------------------

  void revealContinent() {
    final currentState = state;

    if (currentState == null) return;

    // No hints left.
    if (currentState.hints <= 0) return;

    // Already revealed.
    if (currentState.showContinent) return;

    state = currentState.copyWith(
      hints: currentState.hints - 1,
      showContinent: true,
    );
  }

  // --------------------------------------------------
  // SKIP QUESTION
  // Costs 2 hints and moves to the next level.
  // Does NOT remove a life.
  // --------------------------------------------------

  bool skipQuestion() {
    final currentState = state;

    if (currentState == null) return false;

    // Need 2 hints to skip.
    if (currentState.hints < 2) return false;

    final nextQuestionIndex = currentState.currentLevel;

    // No more questions.
    if (nextQuestionIndex >= _questions.length) {
      return false;
    }

    final nextQuestion = _questions[nextQuestionIndex];

    state = QuizState(
      currentRound: currentState.currentRound + 1,
      totalRounds: _questions.length,
      currentLevel: currentState.currentLevel + 1,

      coins: currentState.coins,

      // Remove 2 hints.
      hints: currentState.hints - 2,

      question: nextQuestion,

      // New level starts from image 1.
      currentImageIndex: 0,
      maxUnlockedImageIndex: 0,

      // Reset lives/attempts for new question.
      wrongAttempts: 0,

      showOptions: false,
      showContinent: false,
      showAnswer: false,

      selectedAnswer: null,
      answered: false,
      isCorrect: false,
      gameOver: false,
    );

    return true;
  }
  // --------------------------------------------------
  // COMPLETE CURRENT LEVEL
  // --------------------------------------------------

  bool completeLevel() {
    final currentState = state;

    if (currentState == null) {
      return false;
    }

    final nextQuestionIndex = currentState.currentLevel;

    // No more questions.
    if (nextQuestionIndex >= _questions.length) {
      return false;
    }

    final nextQuestion = _questions[nextQuestionIndex];

    state = QuizState(
      currentRound: currentState.currentRound + 1,

      totalRounds: _questions.length,

      currentLevel: currentState.currentLevel + 1,

      coins: currentState.coins,

      hints: currentState.hints,

      question: nextQuestion,

      // ----------------------------------------------
      // IMPORTANT:
      // NEW LEVEL ALWAYS STARTS FROM IMAGE 1
      // ----------------------------------------------
      currentImageIndex: 0,
      maxUnlockedImageIndex: 0,

      wrongAttempts: 0,

      showOptions: false,
      showContinent: false,
      showAnswer: false,

      selectedAnswer: null,

      answered: false,
      isCorrect: false,
      gameOver: false,
    );

    return true;
  }

  // --------------------------------------------------
  // PLAY AGAIN AFTER LOSING
  // --------------------------------------------------

  void playAgain() {
    final currentState = state;

    if (currentState == null) return;

    state = currentState.copyWith(
      // Reset images to image 1.
      currentImageIndex: 0,
      maxUnlockedImageIndex: 0,

      // Reset attempts.
      wrongAttempts: 0,

      // Reset hints UI.
      showOptions: false,
      showContinent: false,
      showAnswer: false,

      selectedAnswer: null,

      answered: false,
      isCorrect: false,
      gameOver: false,
    );
  }
}
