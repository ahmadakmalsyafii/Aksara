// --- WIDGET UNTUK TAB MEMBACA ---
import 'package:aksara/models/book_model.dart';
import 'package:aksara/models/history_model.dart';
import 'package:aksara/services/chapter_service.dart';
import 'package:aksara/services/history_service.dart';
import 'package:aksara/views/book/book_detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReadHistoryTab extends StatefulWidget {
  const ReadHistoryTab({super.key});

  @override
  State<ReadHistoryTab> createState() => _ReadHistoryTabState();
}

class _ReadHistoryTabState extends State<ReadHistoryTab> {
  final HistoryService _historyService = HistoryService();
  final ChapterService _chapterService = ChapterService();
  final Map<String, BookModel> _booksCache = {};
  final Map<String, int> _chaptersCountCache = {};

  Future<BookModel?> _fetchBook(String bookId) async {
    if (_booksCache.containsKey(bookId)) return _booksCache[bookId];
    final doc = await FirebaseFirestore.instance.collection("books").doc(bookId).get();
    if (doc.exists) {
      final book = BookModel.fromJson(doc.data()!, doc.id);
      _booksCache[bookId] = book;
      return book;
    }
    return null;
  }

  Future<int> _fetchChaptersCount(String bookId) async {
    if (_chaptersCountCache.containsKey(bookId)) return _chaptersCountCache[bookId]!;
    final count = await _chapterService.getChaptersCount(bookId);
    _chaptersCountCache[bookId] = count;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<HistoryModel>>(
      stream: _historyService.getHistoryStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Belum ada riwayat membaca."));
        }

        final historyList = snapshot.data!;
        final uniqueBookIds = historyList.map((h) => h.bookId).toSet().toList();

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: uniqueBookIds.length,
          itemBuilder: (context, index) {
            final bookId = uniqueBookIds[index];
            final completedChapters = historyList
                .where((h) => h.bookId == bookId && h.score >= 60)
                .length;

            return FutureBuilder(
              future: Future.wait([_fetchBook(bookId), _fetchChaptersCount(bookId)]),
              builder: (context, AsyncSnapshot<List<dynamic>> combinedSnapshot) {
                if (!combinedSnapshot.hasData) {
                  return const SizedBox(); // Atau placeholder
                }

                final BookModel? book = combinedSnapshot.data![0];
                final int totalChapters = combinedSnapshot.data![1];
                final double progress = totalChapters > 0 ? completedChapters / totalChapters : 0.0;

                if (book == null) return const SizedBox();

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailPage(book: book),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              book.coverUrl,
                              width: 60,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 60,
                                  height: 80,
                                  color: Colors.grey.shade300,
                                  child: const Icon(Icons.broken_image),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(book.judul, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 4),
                                Text("${book.penerbit} • ${book.tahun}", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                                const SizedBox(height: 8),
                                LinearProgressIndicator(
                                  value: progress,
                                  backgroundColor: Colors.grey.shade200,
                                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                ),
                                const SizedBox(height: 4),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text("$completedChapters/$totalChapters", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(50)),
                            child: Icon(Icons.arrow_forward_ios, size: 12, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}