// lib/views/chapter/chapter_page.dart

import 'package:aksara/services/chapter_service.dart';
import 'package:aksara/views/chapter/chapter_content_page.dart';
import 'package:flutter/material.dart';
import 'package:aksara/models/book_model.dart';
import 'package:aksara/models/chapter_model.dart';
import 'package:aksara/widgets/chapter_card.dart';

class ChapterPage extends StatelessWidget {
  final BookModel book;
  final ChapterService chapterService = ChapterService();

  ChapterPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        // Tombol kembali standar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Judul buku
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                book.judul,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),

            FutureBuilder<List<ChapterModel>>(
              future: chapterService.getChapters(book.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Belum ada bab untuk buku ini."));
                }

                final chapters = snapshot.data!;

                // Container putih yang ukurannya mengikuti konten
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    itemCount: chapters.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final chapterItem = chapters[index];
                      return ChapterCard(
                        chapter: chapterItem,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChapterContentPage(chapter: chapterItem, bookId: book.id,),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 24), // Memberi jarak di bagian bawah
          ],
        ),
      ),
    );
  }
}