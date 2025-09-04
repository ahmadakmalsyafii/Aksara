// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../models/book_model.dart';
// import '../services/book_repository.dart';
// import '../services/auth_service.dart';
// import '../services/progress_repository.dart';
// import '../widgets/chapter_card.dart';
// import 'reader_view.dart';
//
//
// class HomeView extends StatelessWidget {
//   const HomeView({super.key});
//
//
//   @override
//   Widget build(BuildContext context) {
//     final book = context.read<BookRepository>().getSampleBook();
//     return Scaffold(
//       appBar: AppBar(title: const Text('Perpustakaan Pintar')),
//       body: FutureBuilder<int>(
//         future: context.read<ProgressRepository>().getCurrentChapter(
//           uid: context.read<AuthService>().user!.uid,
//           bookId: book.id,
//         ),
//         builder: (context, snap) {
//           final current = snap.data ?? 1;
//           return ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: book.chapters.length,
//             itemBuilder: (context, i) {
//               final ch = book.chapters[i];
//               final idx = int.parse(ch.id);
//               final locked = idx > current;
//               return ChapterCard(
//                 chapter: ch,
//                 locked: locked,
//                 onTap: locked
//                     ? null
//                     : () {
//                   Navigator.pushNamed(context, ReaderView.route, arguments: ReaderArgs(book: book, chapter: ch));
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }