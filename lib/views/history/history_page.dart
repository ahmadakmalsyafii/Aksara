import 'package:aksara/services/history_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aksara/models/book_model.dart';
import 'package:aksara/models/history_model.dart';
import 'package:aksara/services/user_service.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final UserService userService = UserService();
  final HistoryService historyService = HistoryService();
  List<HistoryModel> history = [];
  Map<String, BookModel> books = {};

  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final h = await historyService.getHistory();

    // ambil semua book yang direferensikan
    for (var item in h) {
      if (!books.containsKey(item.bookId)) {
        final doc = await FirebaseFirestore.instance.collection("books").doc(item.bookId).get();
        books[item.bookId] = BookModel.fromJson(doc.data()!, doc.id);
      }
    }

    setState(() {
      history = h;
      loading = false;
    });
  }

  int _countCompletedChapters(String bookId) {
    return history.where((h) => h.bookId == bookId && h.score >= 60).length;
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat Bacaan")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books.values.toList()[index];
          final completedChapters = _countCompletedChapters(book.id!);
          // final totalChapters = book.chapters.length;

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Image.network(book.coverUrl, width: 50, height: 70, fit: BoxFit.cover),
                  title: Text(book.judul),
                  subtitle: Text("${book.judul}\nPenerbit: ${book.penerbit ?? 'N/A'} - ${book.tahun ?? 'N/A'}"),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(12),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       LinearProgressIndicator(
                //         value: totalChapters > 0 ? completedChapters / totalChapters : 0,
                //       ),
                //       const SizedBox(height: 8),
                //       Text("Bab selesai: $completedChapters / $totalChapters"),
                //     ],
                //   ),
                // )
              ],
            ),
          );
        },
      ),
    );
  }
}
