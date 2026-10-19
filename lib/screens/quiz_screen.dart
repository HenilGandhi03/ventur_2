import 'package:flutter/material.dart';
import 'package:ventur_2/controllers/quiz_controller.dart';
import 'package:ventur_2/repositories/quiz_repository.dart';
import 'package:ventur_2/screens/quiz_result_screen.dart';
import 'package:ventur_2/widgets/hint_card.dart';
import 'package:ventur_2/widgets/options_card.dart';
import 'package:ventur_2/widgets/progress_bar.dart';
import 'package:ventur_2/widgets/text_field.dart';
import 'package:ventur_2/widgets/zoomable_image.dart';

class QuizScreen extends StatefulWidget {
  final QuizRepository repository;

  const QuizScreen({super.key, required this.repository});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final QuizController controller;

  final TextEditingController answerController = TextEditingController();

  @override
  void initState() {
    super.initState();

    controller = QuizController(widget.repository);
    _startQuiz();
  }

  @override
  void dispose() {
    answerController.dispose();
    super.dispose();
  }

  Future<void> _startQuiz() async {
    await controller.startQuiz();

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _submitAnswer(String answer) async {
    controller.submitAnswer(answer);

    final state = controller.state;

    if (state == null) return;

    if (state.answered) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              QuizResultScreen(quizState: state, controller: controller),
        ),
      );

      // Result screen mutated the controller (next level / play again);
      // rebuild so this screen shows the new state.
      if (mounted) {
        answerController.clear();
        setState(() {});
      }

      return;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final quizState = controller.state;

    // Still loading questions
    if (quizState == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Level ${quizState.currentLevel}'),
        leading: const BackButton(),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Image.asset('assets/images/coin.png', width: 24, height: 24),
                SizedBox(width: 2),
                Text('${quizState.coins}'),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 0),

        child: Column(
          children: [
            QuizProgressBar(current: quizState.currentImageIndex + 1),

            SizedBox(height: 16),
            //
            Stack(
              children: [
                ZoomableImage(
                  imagePath:
                      quizState.question.imageUrls[quizState.currentImageIndex],
                  height: 300,
                  borderRadius: 16,
                ),

                // ❤️ Lives + 💡 Hints overlay
                Positioned(
                  top: 6,
                  left: 6,
                  right: 6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Lives
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(3, (index) {
                            final isAlive =
                                index < (3 - quizState.wrongAttempts);

                            return Padding(
                              padding: EdgeInsets.only(
                                right: index == 2 ? 0 : 8,
                              ),
                              child: Icon(
                                isAlive
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isAlive
                                    ? Colors.redAccent
                                    : Colors.white70,
                                size: 20,
                              ),
                            );
                          }),
                        ),
                      ),

                      // Hints
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.lightbulb_outline,
                              color: Colors.amber,
                              size: 20,
                            ),

                            const SizedBox(width: 8),

                            Text(
                              '${quizState.hints} hints',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Left arrow
                Positioned(
                  left: 8,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: IconButton(
                      onPressed: quizState.currentImageIndex > 0
                          ? () {
                              controller.previousImage();
                              setState(() {});
                            }
                          : null,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black54,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.chevron_left),
                    ),
                  ),
                ),

                // Right arrow
                Positioned(
                  right: 8,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: IconButton(
                      onPressed:
                          quizState.currentImageIndex <
                              quizState.maxUnlockedImageIndex
                          ? () {
                              controller.nextImage();
                              setState(() {});
                            }
                          : null,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black54,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            Column(
              children: [
                // -----------------------------------------
                // HINT BUTTONS
                // -----------------------------------------
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: HintCard(
                        title: 'Reveal more',
                        description: '(-1 hint)',
                        imagePath: 'assets/images/hint.png',
                        onTap: () {
                          controller.revealOptions();
                          setState(() {});
                        },
                      ),
                    ),

                    Expanded(
                      child: HintCard(
                        title: 'Continent',
                        description: '(-1 hint)',
                        imagePath: 'assets/images/continent.png',
                        onTap: () {
                          if (quizState.hints <= 0) return;
                          if (quizState.showContinent) return;

                          controller.revealContinent();
                          setState(() {});
                        },
                      ),
                    ),

                    Expanded(
                      child: HintCard(
                        title: 'Skip',
                        description: '(-2 hints)',
                        imagePath: 'assets/images/next.png',
                        onTap: () async {
                          if (!controller.skipQuestion()) return;

                          final state = controller.state;
                          if (state == null) return;

                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizResultScreen(
                                quizState: state,
                                controller: controller,
                              ),
                            ),
                          );

                          if (mounted) {
                            answerController.clear();
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  ],
                ),

                // -----------------------------------------
                // CONTINENT RESULT
                // -----------------------------------------
                if (quizState.showContinent) ...[
                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF7FF),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.public, color: Colors.blue, size: 24),

                        const SizedBox(width: 10),

                        const Text(
                          'Continent:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey,
                          ),
                        ),

                        const SizedBox(width: 6),

                        Text(
                          quizState.question.continent,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: 16),

            const Text(
              'Guess the country from the image above',
              style: TextStyle(
                fontSize: 15,
                color: Colors.blueGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),

            InputField(
              hintText: "Type Your Answer...",
              controller: answerController,
              onSend: () {
                final answer = answerController.text.trim();

                if (answer.isEmpty) return;

                _submitAnswer(answer);

                answerController.clear();
              },
            ),
            SizedBox(height: 8),

            if (quizState.showOptions)
              Column(
                children: [
                  const Text(
                    'or choose from options',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: OptionCard(
                          optionText: quizState.question.options[0],
                          onTap: () {
                            _submitAnswer(quizState.question.options[0]);
                          },
                        ),
                      ),

                      Expanded(
                        child: OptionCard(
                          optionText: quizState.question.options[1],
                          onTap: () {
                            _submitAnswer(quizState.question.options[1]);
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Expanded(
                        child: OptionCard(
                          optionText: quizState.question.options[2],
                          onTap: () {
                            _submitAnswer(quizState.question.options[2]);
                          },
                        ),
                      ),

                      Expanded(
                        child: OptionCard(
                          optionText: quizState.question.options[3],
                          onTap: () {
                            _submitAnswer(quizState.question.options[3]);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
