import 'package:flutter/material.dart';

class QuizProgressBar extends StatelessWidget {
  final int current;
  final int total = 3;

  const QuizProgressBar({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (index) {
        final isCompleted = index < current;

        return Expanded(
          child: Container(
            height: 12,
            margin: EdgeInsets.only(right: index == total - 1 ? 0 : 4),
            decoration: BoxDecoration(
              color: isCompleted ? Colors.blue : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      }),
    );
  }
}
