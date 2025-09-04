// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../models/book_model.dart';
// import '../models/quiz_model.dart';
// import '../services/quiz_repository.dart';
// import 'result_view.dart';
//
//
// class QuizArgs {
//   final String bookId;
//   final Chapter chapter;
//   QuizArgs({required this.bookId, required this.chapter});
// }
//
//
// class QuizView extends StatefulWidget {
//   static const route = '/quiz';
//   final String bookId;
//   final Chapter chapter;
//   const QuizView({super.key, required this.bookId, required this.chapter});
//   factory QuizView.fromArgs(Object? args) {
//     final a = args as QuizArgs;
//     return QuizView(bookId: a.bookId, chapter: a.chapter);
//   }
//
//
//   @override
//   State<QuizView> createState() => _QuizViewState();
// }
//
//
// class _QuizViewState extends State<QuizView> {
//   List<QuizQuestion>? _questions;
//   final Map<String, int> _answers = {};
//   bool _loading = true;
//   String? _error;
//
//
//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }
//
//
//   Future<void> _load() async {
//     setState(() {
//       _loading = true;
//       _error = null;
//     });
//     try {
//       final repo = context.read<QuizRepository>();
//       final qs = await repo.buildQuestionsFromChapter(widget.chapter, n: 5);
//       setState(() {
//         _questions = qs;
//       });
//     } catch (e) {
//       setState(() {
//         _error = 'Gagal membuat soal: $e';
//       });
//     } finally {
//       setState(() {
//         _loading = false;
//       });
//     }
//   }
//
//
//   void _submit() {
//     final questions = _questions!;
//     int correct = 0;
//     for (final q in questions) {
//       if (_answers[q.id] == q.correctIndex) correct++;
//     }
//
//
//     Navigator.pushReplacementNamed(
//       context,
//       ResultView.route,
//       arguments: ResultArgs(
//         bookId: widget.bookId,
//         chapterId: widget.chapter.id,
//         total: questions.length,
//         correct: correct,
//       ),
//     );
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Kuis Bab ${widget.chapter.id}')),
//       body: _loading
//           ? const Center(child: CircularProgressIndicator())
//           : _error != null
//           ? Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(_error!),
//             const SizedBox(height: 8),
//             ElevatedButton(onPressed: _load, child: const Text('Coba Lagi')),
//           ],
//         ),
//       )
//           : ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           for (final q in _questions!) ...[
//             Text(q.question, style: Theme
//                 .of(context)
//                 .textTheme
//                 .titleMedium),
//             const SizedBox(height: 8),
//             for (int i = 0; i < q.options.length; i++)
//               RadioListTile<int>(
//                 value: i,
//                 groupValue: _answers[q.id],
//                 onChanged: (v) => setState(() => _answers[q.id] = v!),
//                 title: Text(q.options[i]),
//               ),
//             const Divider(height: 32),
//           ],
//           FilledButton(
//             onPressed: _answers.length == _questions!.length ? _submit : null,
//             child: const Text('Kumpulkan Jawaban'),
//           ),
//         ],
//       ),
//     );
//   }
// }