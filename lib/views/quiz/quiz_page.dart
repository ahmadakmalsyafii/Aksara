// quiz_page.dart
import 'package:aksara/services/quiz_service.dart';
import 'package:flutter/material.dart';
import '../../models/chapter_model.dart';
import '../../models/quiz_model.dart';
import '../../services/gemini_service.dart';

class QuizPage extends StatefulWidget {
  final ChapterModel chapter;
  QuizPage({required this.chapter});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final GeminiService gemini = GeminiService();
  final QuizService firestore = QuizService();
  List<QuizModel> quizzes = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _generateQuiz();
  }

  Future<void> _generateQuiz() async {
    final result = await gemini.generateQuiz(widget.chapter.konten);
    await firestore.saveQuiz(widget.chapter.id, {
      "quiz": result.map((q) => {
        "question": q.question,
        "options": q.options,
        "answer": q.answer
      }).toList()
    });

    setState(() {
      quizzes = result;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quiz ${widget.chapter.judulBab}")),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: quizzes.length,
        itemBuilder: (context, i) {
          final quiz = quizzes[i];
          return Card(
            child: ListTile(
              title: Text(quiz.question),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: quiz.options.map((opt) => Text("- $opt")).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
