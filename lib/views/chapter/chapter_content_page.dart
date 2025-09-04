import 'package:aksara/services/user_stats_service.dart';
import 'package:flutter/material.dart';
import 'package:aksara/models/chapter_model.dart';
import 'package:aksara/models/quiz_model.dart';
import 'package:aksara/services/quiz_service.dart';
import 'package:aksara/services/gemini_service.dart';
import 'package:aksara/views/quiz/quiz_page.dart';
import 'package:aksara/services/progress_service.dart';
import 'package:aksara/models/read_progress_model.dart';

class ChapterContentPage extends StatefulWidget {
  final ChapterModel chapter;

  const ChapterContentPage({super.key, required this.chapter});

  @override
  State<ChapterContentPage> createState() => _ChapterContentPageState();
}

class _ChapterContentPageState extends State<ChapterContentPage> {
  final GeminiService gemini = GeminiService();
  final QuizService quizService = QuizService();
  final ProgressService progressService = ProgressService();
  final StatsService statsService = StatsService();

  bool loading = false;
  bool generating = true;
  List<QuizModel> quizzes = [];

  List<String> pages = [];
  int currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _splitContent();
    _prepareQuiz();
    _loadReadingProgress();
    statsService.recordDailyRead();
  }

  void _splitContent() {
    const chunkSize = 6; // jumlah karakter per halaman
    final text = widget.chapter.konten;
    for (var i = 0; i < text.length; i += chunkSize) {
      pages.add(text.substring(
        i,
        i + chunkSize > text.length ? text.length : i + chunkSize,
      ));
    }
  }

  Future<void> _prepareQuiz() async {
    final existing = await quizService.getQuiz(widget.chapter.id);
    if (existing != null && existing['quiz'] != null) {
      setState(() {
        quizzes = (existing['quiz'] as List)
            .map((q) => QuizModel.fromJson(q))
            .toList();
        generating = false;
      });
      return;
    }

    final result = await gemini.generateQuiz(widget.chapter.konten);

    await quizService.saveQuiz(widget.chapter.id, {
      "quiz": result.map((q) => q.toJson()).toList(),
    });

    setState(() {
      quizzes = result;
      generating = false;
    });
  }

  Future<void> _loadReadingProgress() async {
    final progress = await progressService.getProgress(widget.chapter.id);
    if (progress != null && progress.lastPage < pages.length) {
      _pageController.jumpToPage(progress.lastPage);
      setState(() {
        currentPage = progress.lastPage;
      });
    }
  }

  Future<void> _reloadChapterContent() async {
    setState(() {
      loading = true;
    });

    await Future.delayed(const Duration(milliseconds: 300)); // bisa ganti ambil data Firestore

    setState(() {
      loading = false;
      _splitContent(); // misalnya fungsi untuk rebuild pages
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("BAB ${widget.chapter.order}: ${widget.chapter.judulBab}"),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: pages.length,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
                progressService.saveProgress(widget.chapter.id, index);
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    pages[index],
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                );
              },
            ),
          ),

          // Indicator + tombol quiz di akhir halaman
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Text("Halaman ${currentPage + 1} dari ${pages.length}"),
                  const SizedBox(height: 8),

                  if (currentPage == pages.length - 1)
                    ElevatedButton.icon(
                      icon: const Icon(Icons.quiz),
                      label: generating
                          ? const Text("Menyiapkan Quiz...")
                          : const Text("Kerjakan Quiz"),
                      onPressed: generating
                          ? null
                          : () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QuizPage(
                              chapter: widget.chapter,
                              quizzes: quizzes,
                            ),
                          ),
                        );

                        if (result == true) {
                          setState(() {
                            generating = true;
                            quizzes.clear();
                          });
                          await _prepareQuiz();
                        }
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
