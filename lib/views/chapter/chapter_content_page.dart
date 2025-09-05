// lib/views/chapter/chapter_content_page.dart

import 'package:aksara/services/user_stats_service.dart';
import 'package:flutter/material.dart';
import 'package:aksara/models/chapter_model.dart';
import 'package:aksara/models/quiz_model.dart';
import 'package:aksara/services/quiz_service.dart';
import 'package:aksara/services/gemini_service.dart';
import 'package:aksara/views/quiz/quiz_page.dart';
import 'package:aksara/services/progress_service.dart';
import 'package:flutter_svg/svg.dart';
// ... import lainnya

class ChapterContentPage extends StatefulWidget {
  // ... constructor tidak berubah
  final String bookId;
  final ChapterModel chapter;

  const ChapterContentPage({
    super.key,
    required this.bookId,
    required this.chapter,
  });

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

  @override
  void dispose() {
    quizService.deleteQuiz(widget.chapter.id);
    _pageController.dispose();
    super.dispose();
  }

  void _splitContent() {
    const chunkSize = 6;
    final text = widget.chapter.konten;
    if (text.isEmpty) {
      pages.add("Konten bab ini kosong.");
      return;
    }
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
      // Perbaikan path jika struktur data quiz tersimpan dalam sub-map
      final quizData = existing['quiz'] is Map ? existing['quiz']['quiz'] : existing['quiz'];
      if (quizData is List) {
        setState(() {
          quizzes = quizData
              .map((q) => QuizModel.fromJson(q))
              .toList();
          generating = false;
        });
        return;
      }
    }

    final result = await gemini.generateQuiz(widget.chapter.konten);

    await quizService.saveQuiz(widget.chapter.id, {
      "quiz": result.map((q) => q.toJson()).toList(),
    });
    if(mounted){
      setState(() {
        quizzes = result;
        generating = false;
      });
    }
  }


  Future<void> _loadReadingProgress() async {
    final progress = await progressService.getProgress(widget.chapter.id);
    if (progress != null && progress.lastPage < pages.length) {
      // Menggunakan addPostFrameCallback untuk memastikan widget sudah terbangun
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController.hasClients) {
          _pageController.jumpToPage(progress.lastPage);
          setState(() {
            currentPage = progress.lastPage;
          });
        }
      });
    }
  }

  void _navigateToQuiz() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizPage(
          bookId: widget.bookId,
          chapter: widget.chapter,
          quizzes: quizzes,
        ),
      ),
    );

    if (result == true && mounted) {
      setState(() {
        generating = true;
        quizzes.clear();
      });
      await _prepareQuiz();
    }
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
      // PERUBAHAN: Mengganti Stack dengan Scaffold dan FloatingActionButton
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
                return SingleChildScrollView( // Menambahkan scroll untuk konten yang panjang
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    pages[index],
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: currentPage > 0
                        ? () => _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Text("Halaman ${currentPage + 1} dari ${pages.length}"),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: currentPage < pages.length - 1
                        ? () => _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton:  Visibility(
        visible: currentPage == pages.length - 1,
        child: FloatingActionButton(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          onPressed: generating ? null : _navigateToQuiz,
          child: generating
              ? SvgPicture.asset('assets/icons/ai_icon.svg', color: Colors.grey,)
              : SvgPicture.asset('assets/icons/ai_icon.svg'),
        ),
      ),
    );
  }
}