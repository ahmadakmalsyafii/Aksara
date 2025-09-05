// lib/widgets/incorrect_answer_popup.dart

import 'package:flutter/material.dart';

class IncorrectAnswerPopup extends StatelessWidget {
  final String correctAnswer;
  const IncorrectAnswerPopup({super.key, required this.correctAnswer});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red.shade50,

      ),
      child: Row(
        children: [
          const SizedBox(width: 4),
          Image.asset('assets/images/wrong_answer_mascot.png'),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Yahh :((",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Ayo coba lagi",
                  style: const TextStyle(color: Colors.black54),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}