// import 'package:flutter/material.dart';
// import '../models/book_model.dart';
// import 'quiz_view.dart';
//
//
// class ReaderArgs {
//   final Book book;
//   final Chapter chapter;
//   ReaderArgs({required this.book, required this.chapter});
// }
//
//
// class ReaderView extends StatelessWidget {
//   static const route = '/reader';
//   final Book book;
//   final Chapter chapter;
//
//
//   const ReaderView({super.key, required this.book, required this.chapter});
//   factory ReaderView.fromArgs(Object? args) {
//     final a = args as ReaderArgs;
//     return ReaderView(book: a.book, chapter: a.chapter);
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('${book.title} — Bab ${chapter.id}')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(chapter.title, style: Theme.of(context).textTheme.headlineSmall),
//             const SizedBox(height: 8),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Text(
//                   chapter.content,
//                   style: Theme.of(context).textTheme.bodyLarge,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 12),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 icon: const Icon(Icons.quiz_outlined),
//                 label: const Text('Mulai Kuis Bab Ini'),
//                 onPressed: () {
//                   Navigator.pushNamed(
//                     context,
//                     QuizView.route,
//                     arguments: QuizArgs(bookId: book.id, chapter: chapter),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }