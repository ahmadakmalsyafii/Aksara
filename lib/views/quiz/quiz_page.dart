import 'package:aksara/services/user_stats_service.dart';
import 'package:flutter/material.dart';
import '../../models/chapter_model.dart';
import '../../models/quiz_model.dart';
import '../../services/quiz_service.dart';

class QuizPage extends StatefulWidget {
  final ChapterModel chapter;
  final List<QuizModel> quizzes;

  const QuizPage({
    super.key,
    required this.chapter,
    required this.quizzes,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final QuizService quizService = QuizService();
  final StatsService statsService = StatsService();

  late List<QuizModel> quizzes;
  Map<int, String> answers = {};
  bool loading = false;

  @override
  void initState() {
    super.initState();
    quizzes = widget.quizzes;
  }

  @override
  void dispose() {
    print("❌ Halaman quiz ditutup, hapus quiz ${widget.chapter.id}");
    quizService.deleteQuiz(widget.chapter.id);
    super.dispose();
  }

  void _submitQuiz() async {
    print("➡️ Submit quiz dipanggil");

    int correct = 0;
    for (int i = 0; i < quizzes.length; i++) {
      final quiz = quizzes[i];
      final selectedAnswer = answers[i];
      if (selectedAnswer == quiz.options[quiz.answerIndex]) {
        correct++;
      }
    }

    final score = (correct / quizzes.length * 100).round();
    print("✅ Score: $score, akan hapus quiz untuk chapter ${widget.chapter.id}");
    if(score >= 60){
      await statsService.addPoints(500);
    }

    // hapus quiz di Firestore
    await quizService.deleteQuiz(widget.chapter.id);

    // dialog hasil
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hasil Quiz"),
        content: Text("Nilai kamu: $score"),
        actions: [
          TextButton(
            child: Text(score >= 60 ? "Lanjut Bab" : "Baca Ulang"),
            onPressed: () {
              Navigator.pop(context); // tutup dialog
              Navigator.pop(context, true); // kirim sinyal refresh
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quiz ${widget.chapter.judulBab}")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: quizzes.length,
        itemBuilder: (context, i) {
          final quiz = quizzes[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${i + 1}. ${quiz.question}",
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  ...quiz.options.map((opt) {
                    return RadioListTile<String>(
                      title: Text(opt),
                      value: opt,
                      groupValue: answers[i],
                      onChanged: (val) {
                        setState(() {
                          answers[i] = val!;
                        });
                      },
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: !loading
          ? Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed:
          answers.length == quizzes.length ? _submitQuiz : null,
          child: const Text("Submit"),
        ),
      )
          : null,
    );
  }
}
