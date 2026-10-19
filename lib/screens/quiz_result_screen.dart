import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:ventur_2/controllers/quiz_controller.dart';
import 'package:ventur_2/models/quiz_state.dart';

class QuizResultScreen extends StatefulWidget {
  final QuizState quizState;
  final QuizController controller;

  const QuizResultScreen({
    super.key,
    required this.quizState,
    required this.controller,
  });

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );

    // Only celebrate correct answers.
    if (widget.quizState.isCorrect) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _confettiController.play();
      });
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _nextQuestion() {
    final currentLevel = widget.quizState.currentLevel;
    final totalRounds = widget.quizState.totalRounds;

    // Last question completed.
    if (currentLevel >= totalRounds) {
      Navigator.pop(context);
      return;
    }

    widget.controller.completeLevel();

    Navigator.pop(context);
  }

  void _playAgain() {
    widget.controller.playAgain();

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final quizState = widget.quizState;
    final isCorrect = quizState.isCorrect;

    return Scaffold(
      backgroundColor: isCorrect
          ? const Color(0xFFFDFEFE)
          : const Color(0xFFFFF7F8),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: Column(
                children: [
                  const SizedBox(height: 15),

                  // Result title
                  Text(
                    isCorrect ? 'Correct!' : 'Not quite!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: isCorrect
                          ? const Color(0xFF129447)
                          : const Color(0xFFD51F3A),
                    ),
                  ),

                  if (!isCorrect) ...[
                    const SizedBox(height: 8),

                    const Text(
                      "Here's the full view:",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(
                      quizState.question.imageUrls.last,
                      width: double.infinity,
                      height: 260,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Answer
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        // Simple country indicator
                        Container(
                          width: 58,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade200,
                          ),
                          child: Center(
                            child: Text(
                              _countryEmoji(quizState.question.correctAnswer),
                              style: const TextStyle(fontSize: 28),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Text(
                            quizState.question.correctAnswer,
                            style: const TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Description
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      quizState.question.description ?? '',
                      style: const TextStyle(
                        fontSize: 17,
                        height: 1.45,
                        color: Color(0xFF424242),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Fun fact
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: isCorrect
                          ? const Color(0xFFFFF8E8)
                          : const Color(0xFFFFE7EB),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('💡', style: TextStyle(fontSize: 28)),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Fun Fact',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                quizState.question.funfact ?? '',
                                style: const TextStyle(
                                  fontSize: 15,
                                  height: 1.4,
                                  color: Color(0xFF555555),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Button
                  SizedBox(
                    width: double.infinity,
                    height: 62,
                    child: ElevatedButton(
                      onPressed: isCorrect ? _nextQuestion : _playAgain,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isCorrect
                            ? const Color(0xFF12A957)
                            : const Color(0xFFF52F4D),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isCorrect ? 'Next Question' : 'Play Again',
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          const SizedBox(width: 12),

                          const Icon(Icons.chevron_right, size: 32),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Confetti
            if (isCorrect)
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  numberOfParticles: 35,
                  gravity: 0.25,
                  emissionFrequency: 0.05,
                  maxBlastForce: 25,
                  minBlastForce: 10,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _countryEmoji(String country) {
    switch (country.toLowerCase()) {
      case 'italy':
        return '🇮🇹';
      case 'france':
        return '🇫🇷';
      case 'spain':
        return '🇪🇸';
      case 'greece':
        return '🇬🇷';
      case 'portugal':
        return '🇵🇹';
      default:
        return '🌍';
    }
  }
}
