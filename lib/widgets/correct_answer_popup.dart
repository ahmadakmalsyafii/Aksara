// lib/widgets/correct_answer_popup.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CorrectAnswerPopup extends StatelessWidget {
  const CorrectAnswerPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
      ),
      child: Row(
        children: [
          const SizedBox(width: 4),
          Image.asset('assets/images/correct_answer_mascot.png'),
          const SizedBox(width: 16),
          const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Excellent!!",
                style: TextStyle(
                  color: Color(0xFF338EC6),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Jawaban kamu benar!",
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}