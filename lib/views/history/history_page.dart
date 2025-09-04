// lib/views/history/history_page.dart

import 'package:aksara/services/history_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aksara/models/book_model.dart';
import 'package:aksara/models/history_model.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final HistoryService historyService = HistoryService();
  final Map<String, BookModel> _booksCache = {};

  // Method untuk mengambil data buku dari Firestore dan menyimpannya di cache
  Future<BookModel?> _fetchBook(String bookId) async {
    if (_booksCache.containsKey(bookId)) {
      return _booksCache[bookId];
    }

    final doc = await FirebaseFirestore.instance.collection("books").doc(bookId).get();
    if (doc.exists) {
      final book = BookModel.fromJson(doc.data()!, doc.id);
      _booksCache[bookId] = book;
      return book;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat Bacaan")),
      body: StreamBuilder<List<HistoryModel>>(
        stream: historyService.getHistoryStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
            // Tampilkan loading indicator hanya saat pertama kali memuat
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Terjadi kesalahan."));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Anda belum memiliki riwayat bacaan."));
          }

          final historyList = snapshot.data!;
          // Gunakan Set untuk mendapatkan bookId unik dan ubah kembali ke List
          final uniqueBookIds = historyList.map((h) => h.bookId).toSet().toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: uniqueBookIds.length,
            itemBuilder: (context, index) {
              final bookId = uniqueBookIds[index];
              final chaptersCompleted = historyList
                  .where((h) => h.bookId == bookId && h.score >= 60)
                  .length;

              return FutureBuilder<BookModel?>(
                future: _fetchBook(bookId),
                builder: (context, bookSnapshot) {
                  if (!bookSnapshot.hasData) {
                    // Tampilkan placeholder card saat data buku sedang dimuat
                    return _buildPlaceholderCard();
                  }

                  final book = bookSnapshot.data!;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              book.coverUrl,
                              width: double.infinity,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 60,
                                  height: 50,
                                  color: Colors.grey.shade300,
                                  child: const Icon(Icons.broken_image),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book.judul,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${book.penerbit} • ${book.tahun}",
                                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Bab selesai: $chaptersCompleted",
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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

  // Widget untuk placeholder card
  Widget _buildPlaceholderCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: double.infinity,
                    color: Colors.grey.shade200,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 12,
                    width: 100,
                    color: Colors.grey.shade200,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}