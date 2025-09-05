import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:aksara/models/book_model.dart';

class BookDetailSalokaPage extends StatelessWidget {
  final BookModel book;

  const BookDetailSalokaPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
                  Text(book.judul, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  // DIGANTI: Menggunakan 'penerbit' karena 'penulis' tidak ada di BookModel
                  Text(book.penerbit, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                  const SizedBox(height: 12),
                  Text('Rp. ${book.harga}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                  const SizedBox(height: 24),

                  const Text("Informasi Buku", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8, right: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Penerbit", style: TextStyle(color: Colors.grey.shade600), textAlign: TextAlign.start),
                            Text(book.penerbit, style: const TextStyle(fontWeight: FontWeight.w500))
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Tahun", style: TextStyle(color: Colors.grey.shade600)),
                            // DIUBAH: Menggunakan 'tahun' dari book model
                            Text(book.tahun, style: const TextStyle(fontWeight: FontWeight.w500))
                          ],
                        )
                      ],
                    ),
                  ),
                  // DIHILANGKAN: Properti 'isbn' tidak ada di BookModel.
                  // Anda bisa menambahkannya di model jika diperlukan.
                  const SizedBox(height: 24),

                  const Text("Tag", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: -6,
                    children: book.kategori.map((tag) {
                      return Chip(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                        label: Text(tag, style: const TextStyle(color: Colors.black)), // Warna teks chip diubah agar terbaca
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        backgroundColor: Colors.blue.shade50, // Latar belakang chip lebih soft
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  const Text("Deskripsi Buku", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  // DIGANTI: Menggunakan teks placeholder karena 'deskripsi' tidak ada di BookModel
                  Text(
                    "Deskripsi lengkap untuk buku ini belum tersedia.",
                    style: TextStyle(color: Colors.grey.shade800, height: 1.5, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text("Keranjang"),
                  onPressed: () { /* Logika tambah keranjang */ },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () { /* Logika beli sekarang */ },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Beli sekarang"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}