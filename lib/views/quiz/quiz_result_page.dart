// lib/views/quiz/quiz_result_page.dart

import 'package:aksara/widgets/result_card.dart'; // Import widget baru
import 'package:flutter/material.dart';

class QuizResultPage extends StatelessWidget {
  final int totalQuestions;
  final int correctAnswers;

  const QuizResultPage({
    super.key,
    required this.totalQuestions,
    required this.correctAnswers,
  });

  @override
  Widget build(BuildContext context) {
    final int incorrectAnswers = totalQuestions - correctAnswers;
    final int accuracy = totalQuestions > 0
        ? ((correctAnswers / totalQuestions) * 100).round()
        : 0;

    final bool isPassed = accuracy >= 60;

    final String imagePath = isPassed
        ? "assets/images/result_quiz_mascot.png"
        : "assets/images/result_quiz_failed_mascot.png";

    final String titleText = isPassed ? "Yayy, Selamat!" : "Mohon Maaf, Coba Lagi";
    final String subtitleText = isPassed
        ? "Kamu telah menyelesaikan quiz dengan baik!"
        : "Jangan menyerah, coba lagi sampai kamu berhasil!";

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 48),
                    Image.asset(imagePath, width: double.infinity,),
                    const SizedBox(height: 16),
                    Text(
                      titleText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF338EC6),),
                    ),
                    Text(
                      subtitleText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.black54),
                    ),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Akurasi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: accuracy / 100,
                            minHeight: 10,
                            borderRadius: BorderRadius.circular(10),
                            backgroundColor: Colors.grey.shade200,
                            color: Color(0xFF338EC6),
                          ),
                        ),
                        Text("$accuracy%", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ResultCard(
                            icon: Icons.check_circle,
                            color: Colors.green,
                            title: "Jawaban Benar",
                            count: correctAnswers,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ResultCard(
                            icon: Icons.cancel,
                            color: Colors.red,
                            title: "Jawaban Salah",
                            count: incorrectAnswers,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Kembali", style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),
              onPressed: () {
                int count = 0;
                Navigator.of(context).popUntil((_) => count++ >= 2);
              },
            ),
          ],
        ),
      ),
    );
  }

}