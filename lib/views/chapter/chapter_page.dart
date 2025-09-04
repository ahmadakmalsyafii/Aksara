// import 'package:flutter/material.dart';
// import 'package:aksara/models/book_model.dart';
//
// class ChapterPage extends StatelessWidget {
//   final BookModel book;
//   const ChapterPage({super.key, required this.book});
//
//   @override
//   Widget build(BuildContext context) {
//     final List<String> chapters = List.generate(8, (index) => "BAB ${index + 1}");
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(book.judul),
//       ),
//       body: ListView.separated(
//         padding: const EdgeInsets.all(16),
//         itemCount: chapters.length,
//         separatorBuilder: (_, __) => const SizedBox(height: 8),
//         itemBuilder: (context, index) {
//           return Card(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: ListTile(
//               title: Text(
//                 chapters[index],
//                 style: const TextStyle(fontWeight: FontWeight.w500),
//               ),
//               trailing: const Icon(Icons.chevron_right),
//               onTap: () {
//                 // TODO: navigate ke halaman detail bab / quiz
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }



//
// class ChapterPage extends StatelessWidget {
//   final String bookId;
//   final ChapterService chapter = ChapterService();
//
//   ChapterPage({required this.bookId});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Daftar Bab")),
//       body: FutureBuilder<List<ChapterModel>>(
//         future: chapter.getChapters(bookId),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
//           final chapters = snapshot.data!;
//           return ListView.builder(
//             itemCount: chapters.length,
//             itemBuilder: (context, i) {
//               return ListTile(
//                 title: Text(chapters[i].judulBab),
//                 onTap: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => QuizPage(chapter: chapters[i])),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:aksara/services/chapter_service.dart';
import 'package:flutter/material.dart';
import 'package:aksara/models/book_model.dart';
import 'package:aksara/models/chapter_model.dart';
import 'package:aksara/widgets/chapter_card.dart';

class ChapterPage extends StatelessWidget {
  final BookModel book;
  final ChapterService chapter = ChapterService();

  ChapterPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.judul)),
      body: FutureBuilder<List<ChapterModel>>(
        future: chapter.getChapters(book.id!), // ambil bab dari Firestore
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada bab tersedia"));
          }

          final chapters = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: chapters.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              return ChapterCard(
                chapter: chapters[index],
                onTap: () {
                  // TODO: Navigate ke halaman detail bab atau quiz
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Buka ${chapters[index].judulBab}")),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
