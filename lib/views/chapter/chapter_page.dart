import 'package:aksara/services/chapter_service.dart';
import 'package:aksara/views/chapter/chapter_content_page.dart';
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChapterContentPage(chapter: chapters[index]),
                    ),
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
