// import '../models/quiz_model.dart';
// import '../models/book_model.dart';
// import 'gemini_service.dart';
// import 'progress_repository.dart';
//
//
// class QuizRepository {
//   final GeminiService gemini;
//   final ProgressRepository progress;
//
//
//   QuizRepository({required this.gemini, required this.progress});
//
//
//   Future<List<QuizQuestion>> buildQuestionsFromChapter(Chapter chapter, {int n = 5}) async {
//     return gemini.generateQuiz(chapterTitle: chapter.title, chapterContent: chapter.content, n: n);
//   }
// }