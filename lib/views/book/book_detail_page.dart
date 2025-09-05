import 'dart:ui';

import 'package:aksara/services/history_service.dart';
import 'package:flutter/material.dart';
import 'package:aksara/models/book_model.dart';
import 'package:aksara/views/chapter/chapter_page.dart';

class BookDetailPage extends StatelessWidget {
  final BookModel book;
  const BookDetailPage({super.key, required this.book});


  @override
  Widget build(BuildContext context) {
    final HistoryService historyService = HistoryService();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 300,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(book.coverUrl, fit: BoxFit.cover),
                  ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(color: Colors.black.withOpacity(0.2)),
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      height: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(book.coverUrl),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(book.judul, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(book.penulis, style: TextStyle(fontSize: 12, color: Colors.grey.shade700, )),
                    ],
                  ),
                  const SizedBox(height: 12),

                  const Text("Informasi Buku", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8,right: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Penerbit", style: TextStyle(color: Colors.grey.shade600), textAlign: TextAlign.start,),
                            Text(book.penerbit, style: const TextStyle(fontWeight: FontWeight.w500))
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Tanggal", style: TextStyle(color: Colors.grey.shade600)),
                            Text("10 April 2025", style: const TextStyle(fontWeight: FontWeight.w500))
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("ISBN", style: TextStyle(color: Colors.grey.shade600)),
                            Text(book.isbn, style: const TextStyle(fontWeight: FontWeight.w500)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Halaman", style: TextStyle(color: Colors.grey.shade600)),
                            Text(book.isbn, style: const TextStyle(fontWeight: FontWeight.w500)),
                          ],
                        )
                      ],
                    ),
                  ),
                  // Anda bisa menambahkan data lain seperti ISBN dan Halaman di sini
                  const SizedBox(height: 24),

                  // --- Tag ---
                  const Text("Tag", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: -6,
                    children: book.kategori.map((tag) {
                      return Chip(shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(50)),
                        label: Text(tag, style: TextStyle(color: Colors.white),),
                        materialTapTargetSize:
                        MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        backgroundColor: Colors.blue,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // --- Deskripsi ---
                  const Text("Deskripsi Buku", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    book.deskripsi,
                    style: TextStyle(color: Colors.grey.shade800, height: 1.5, fontSize: 14),
                  ),
                ],
              ),
            ), // biar ga ketutup tombol
          ],
        ),
      ),

      // Tombol melayang di bawah
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              onPressed: () async {
                await historyService.saveHistory(
                  bookId: book.id,
                  chapterId: 'mulai_baca',
                  score: 0,
                );

                // Arahkan ke halaman daftar bab
                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChapterPage(book: book),
                    ),
                  );
                }
              },
              child: const Text(
                "Baca Sekarang",
                style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
