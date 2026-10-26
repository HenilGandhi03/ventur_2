import 'dart:async';

import 'package:ventur_2/models/game_save.dart';
import 'package:ventur_2/models/quiz_progress.dart';
import 'package:ventur_2/models/quiz_question.dart';
import 'package:ventur_2/models/quiz_state.dart';
import 'package:ventur_2/models/user.dart';
import 'package:ventur_2/repositories/composite_progress_storage.dart';
import 'package:ventur_2/repositories/progress_storage.dart';
import 'package:ventur_2/repositories/quiz_repository.dart';

class QuizController {
  final QuizRepository repository;

  QuizState? state;

  List<QuizQuestion> _questions = [];

  final ProgressStorage storage;

  // Persisted player data. QuizState (below) is the per-screen view of it.
  User _user = User.newPlayer();
  List<QuizProgress> _progress = [];

  User get user => _user;
  List<QuizProgress> get progress => List.unmodifiable(_progress);

  QuizController(this.repository, {ProgressStorage? storage})
    : storage = storage ?? CompositeProgressStorage();

  // --------------------------------------------------
  // PERSISTENCE
  // --------------------------------------------------

  Future<void> startQuiz() async {
    _questions = await repository.getQuestions();

    if (_questions.isEmpty) return;

    final saved = await storage.load();

    // No save (or unreadable one) = brand new player.
    _user = saved?.user ?? User.newPlayer();
    _progress = List.of(saved?.progress ?? const []);
    final session = saved?.session ?? const LevelSession();

    final level = _user.currentLevel.clamp(1, _questions.length);
    final question = _questions[level - 1];
    final lastImage = question.imageUrls.length - 1;

    state = QuizState(
      currentRound: level,
      totalRounds: _questions.length,
      currentLevel: level,
      coins: _user.coins,
      hints: _user.hints,
      question: question,

      currentImageIndex: session.currentImageIndex.clamp(0, lastImage),
      maxUnlockedImageIndex: session.maxUnlockedImageIndex.clamp(0, lastImage),
      wrongAttempts: (User.maxLives - _user.lives).clamp(0, User.maxLives - 1),

      showOptions: session.showOptions,
      showContinent: session.showContinent,
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

    _user = _user.copyWith(
      coins: s.coins,
      hints: s.hints,
      lives: midLevel ? User.maxLives - s.wrongAttempts : User.maxLives,
      currentLevel: level,
      highestLevel: level > _user.highestLevel ? level : _user.highestLevel,
    );

    unawaited(
      storage.save(
        GameSave(
          user: _user,
          progress: _progress,
          session: midLevel
              ? LevelSession(
                  currentImageIndex: s.currentImageIndex,
                  maxUnlockedImageIndex: s.maxUnlockedImageIndex,
                  showOptions: s.showOptions,
                  showContinent: s.showContinent,
                )
              : const LevelSession(),
        ),
      ),
    );
  }

  // Stars: 3 for no wrong guesses, 2 for one, 1 for two. Replays only ever
  // improve the stored result.
  void _recordCompletion(QuizState s) {
    final stars = (User.maxLives - s.wrongAttempts).clamp(1, 3);
    final mode = s.question.mode;
    final i = _progress.indexWhere(
      (p) => p.mode == mode && p.level == s.currentLevel,
    );
    final best = i == -1 || stars > _progress[i].stars
        ? stars
        : _progress[i].stars;
    final entry = QuizProgress(
      mode: mode,
      level: s.currentLevel,
      completed: true,
      stars: best,
    );

    if (i == -1) {
      _progress.add(entry);
    } else {
      _progress[i] = entry;
    }
  }

  void submitAnswer(String answer) {
    final before = state;
    _submitAnswer(answer);
    final after = state;

    if (before != null && after != null) {
      var stats = _user.statistics;

      if (after.wrongAttempts > before.wrongAttempts) {
        stats = stats.copyWith(totalWrong: stats.totalWrong + 1);
      }
      if (after.gameOver && !before.gameOver) {
        stats = stats.copyWith(gamesLost: stats.gamesLost + 1);
      }
      if (after.isCorrect && !before.isCorrect) {
        stats = stats.copyWith(totalCorrect: stats.totalCorrect + 1);
        _recordCompletion(after);
      }

      _user = _user.copyWith(statistics: stats);
    }

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
    _user = _user.copyWith(
      statistics: _user.statistics.copyWith(
        totalSkipped: _user.statistics.totalSkipped + 1,
      ),
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
