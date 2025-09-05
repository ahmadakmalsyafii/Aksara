// lib/views/quiz/quiz_page.dart

import 'package:aksara/models/chapter_model.dart';
import 'package:aksara/models/quiz_model.dart';
import 'package:aksara/services/quiz_service.dart';
import 'package:aksara/services/user_stats_service.dart';
import 'package:aksara/views/quiz/quiz_result_page.dart';
import 'package:aksara/widgets/correct_answer_popup.dart';
import 'package:aksara/widgets/incorrect_answer_popup.dart';
import 'package:flutter/material.dart';

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

  int _currentQuestionIndex = 0;
  int? _selectedOptionIndex;
  bool _isAnswered = false;
  final List<int> _correctAnswers = [];

  @override
  void dispose() {
    quizService.deleteQuiz(widget.chapter.id);
    super.dispose();
  }

  void _handleNext() {
    final quiz = widget.quizzes[_currentQuestionIndex];
    final isCorrect = _selectedOptionIndex == quiz.answerIndex;

    if (isCorrect) {
      _correctAnswers.add(_currentQuestionIndex);
    }

    setState(() {
      _isAnswered = true;
    });

    _showCorrectionPopup(isCorrect, quiz.options[quiz.answerIndex]);

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.of(context).pop();

      if (_currentQuestionIndex < widget.quizzes.length - 1) {
        setState(() {
          _currentQuestionIndex++;
          _selectedOptionIndex = null;
          _isAnswered = false;
        });
      } else {
        _navigateToResultPage();
      }
    });
  }

  void _showCorrectionPopup(bool isCorrect, String correctAnswer) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return isCorrect
            ? const CorrectAnswerPopup()
            : IncorrectAnswerPopup(correctAnswer: correctAnswer);
      },
    );
  }

  void _navigateToResultPage() async {
    final score = (_correctAnswers.length / widget.quizzes.length * 100).round();
    if (score >= 60) {
      await statsService.addPoints(500);
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => QuizResultPage(
          totalQuestions: widget.quizzes.length,
          correctAnswers: _correctAnswers.length,
        ),
      ),
    );
  }

  Color _getOptionColor(int optionIndex, int correctIndex) {
    if (!_isAnswered) {
      return _selectedOptionIndex == optionIndex ? Colors.blue.shade50 : Colors.white;
    }
    if (optionIndex == correctIndex) {
      return Colors.green.shade50;
    }
    if (optionIndex == _selectedOptionIndex && optionIndex != correctIndex) {
      return Colors.red.shade50;
    }
    return Colors.white;
  }

  Color _getBorderColor(int optionIndex) {
    if(!_isAnswered){
      return _selectedOptionIndex == optionIndex ? Colors.blue : Colors.grey.shade300;
    }
    if(optionIndex == widget.quizzes[_currentQuestionIndex].answerIndex){
      return Colors.green;
    }
    if(optionIndex == _selectedOptionIndex && optionIndex != widget.quizzes[_currentQuestionIndex].answerIndex){
      return Colors.red;
    }
    return Colors.grey.shade300;
  }


  @override
  Widget build(BuildContext context) {
    final quiz = widget.quizzes[_currentQuestionIndex];
    final progressValue = (_currentQuestionIndex + 1) / widget.quizzes.length;

    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: progressValue,
            minHeight: 10,
            backgroundColor: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Soal ${_currentQuestionIndex + 1} / ${widget.quizzes.length}",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quiz.question,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                    const SizedBox(height: 20),
                    ...List.generate(quiz.options.length, (index) {
                      // Gunakan RadioListTile untuk tata letak yang lebih mudah
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _getOptionColor(index, quiz.answerIndex),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _getBorderColor(index), width: 1.5),
                          ),
                          child: RadioListTile<int>(
                            value: index,
                            groupValue: _selectedOptionIndex,
                            onChanged: _isAnswered ? null : (value) {
                              setState(() {
                                _selectedOptionIndex = value;
                              });
                            },
                            title: Text(quiz.options[index]),
                            activeColor: _isAnswered
                                ? (_getBorderColor(index) == Colors.grey.shade300
                                ? Colors.blue
                                : _getBorderColor(index))
                                : Colors.blue,
                            // Menempatkan radio button di sebelah kanan
                            controlAffinity: ListTileControlAffinity.trailing,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: (_selectedOptionIndex != null && !_isAnswered) ? _handleNext : null,
          child: Text(_isAnswered ? "..." : "Lanjut", style: const TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}