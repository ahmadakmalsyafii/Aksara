import 'package:flutter/material.dart';
import 'package:aksara/models/book_model.dart';
import 'package:aksara/views/chapter/chapter_page.dart';

class BookDetailPage extends StatelessWidget {
  final BookModel book;
  const BookDetailPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.judul),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  book.coverUrl,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.broken_image),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Judul & Penulis
            Text(
              book.judul,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (book.penerbit != null) ...[
              const SizedBox(height: 4),
              Text(
                book.penerbit!,
                style: const TextStyle(color: Colors.black54),
              ),
            ],

            const SizedBox(height: 20),

            // Informasi Buku
            const Text(
              "Informasi Buku",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Penerbit: ${book.penerbit}"),
                Text("Tahun: ${book.tahun}"),
              ],
            ),
            // if (book.isbn != null) Text("ISBN: ${book.isbn}"),
            // if (book.halaman != null) Text("${book.halaman} halaman"),

            const SizedBox(height: 16),

            // Tag
            Wrap(
              spacing: 8,
              children: book.kategori.map((tag) {
                return Chip(
                  label: Text(tag),
                  backgroundColor: Colors.blue.shade50,
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Deskripsi
            const Text(
              "Deskripsi Buku",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            // Text(book.deskripsi ?? "-"),

            const SizedBox(height: 80), // biar ga ketutup tombol
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChapterPage(book: book),
                  ),
                );
              },
              child: const Text(
                "Baca sekarang",
                style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
