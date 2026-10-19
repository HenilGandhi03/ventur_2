import 'dart:async';

import 'package:ventur_2/models/quiz_question.dart';
import 'package:ventur_2/models/quiz_state.dart';
import 'package:ventur_2/models/user_progress.dart';
import 'package:ventur_2/repositories/progress_storage.dart';
import 'package:ventur_2/repositories/quiz_repository.dart';

class QuizController {
  final QuizRepository repository;

  QuizState? state;

  List<QuizQuestion> _questions = [];

  final ProgressStorage storage;

  QuizController(this.repository, {ProgressStorage? storage})
    : storage = storage ?? SharedPrefsProgressStorage();

  // --------------------------------------------------
  // PERSISTENCE
  // --------------------------------------------------

  Future<void> startQuiz() async {
    _questions = await repository.getQuestions();

    if (_questions.isEmpty) return;

    final saved = await storage.load();

    // Defaults for a brand new player.
    final level = (saved?.currentLevel ?? 1).clamp(1, _questions.length);
    final question = _questions[level - 1];
    final lastImage = question.imageUrls.length - 1;

    state = QuizState(
      currentRound: level,
      totalRounds: _questions.length,
      currentLevel: level,
      coins: saved?.coins ?? 120,
      hints: saved?.hints ?? 3,
      question: question,

      currentImageIndex: (saved?.currentImageIndex ?? 0).clamp(0, lastImage),
      maxUnlockedImageIndex: (saved?.maxUnlockedImageIndex ?? 0).clamp(
        0,
        lastImage,
      ),
      wrongAttempts: (saved?.wrongAttempts ?? 0).clamp(0, 2),

      showOptions: saved?.showOptions ?? false,
      showContinent: saved?.showContinent ?? false,
      showAnswer: false,

      selectedAnswer: null,
      answered: false,
      isCorrect: false,
      gameOver: false,
    );
  }

  /// Wipes saved progress and restarts from level 1.
  Future<void> resetProgress() async {
    await storage.clear();
    await startQuiz();
  }

  // Saves what a restart should resume from. An answered/skipped level is
  // saved as the *next* level (the player has already earned it), and a lost
  // level is saved as a fresh retry of the same level.
  void _save() {
    final s = state;
    if (s == null) return;

    final cleared = s.answered && !s.gameOver;
    final level = cleared
        ? (s.currentLevel + 1).clamp(1, _questions.length)
        : s.currentLevel;
    final midLevel = !s.answered && !s.gameOver;

    unawaited(
      storage.save(
        UserProgress(
          currentLevel: level,
          coins: s.coins,
          hints: s.hints,
          wrongAttempts: midLevel ? s.wrongAttempts : 0,
          currentImageIndex: midLevel ? s.currentImageIndex : 0,
          maxUnlockedImageIndex: midLevel ? s.maxUnlockedImageIndex : 0,
          showOptions: midLevel && s.showOptions,
          showContinent: midLevel && s.showContinent,
        ),
      ),
    );
  }

  void submitAnswer(String answer) {
    _submitAnswer(answer);
    _save();
  }

  void _submitAnswer(String answer) {
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
    _save();
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
    _save();
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

    // Mark as answered (not correct, not game over) so the result screen
    // reveals the answer; its "Next Question" button advances the level.
    state = currentState.copyWith(
      hints: currentState.hints - 2,
      selectedAnswer: null,
      answered: true,
      isCorrect: false,
      gameOver: false,
    );
    _save();

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
    _save();

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
    _save();
  }
}
