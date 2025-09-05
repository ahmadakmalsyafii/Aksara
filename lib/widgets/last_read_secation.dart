// lib/widgets/last_read_section.dart

import 'package:aksara/models/book_model.dart';
import 'package:aksara/models/history_model.dart';
import 'package:aksara/services/book_service.dart';
import 'package:aksara/services/history_service.dart';
import 'package:aksara/widgets/book_card_saloka.dart';
import 'package:aksara/widgets/book_card_wide.dart';
import 'package:flutter/material.dart';

class LastReadSection extends StatefulWidget {
  const LastReadSection({super.key});

  @override
  State<LastReadSection> createState() => _LastReadSectionState();
}

class _LastReadSectionState extends State<LastReadSection> {
  final HistoryService _historyService = HistoryService();
  final BookService _bookService = BookService();

  Future<BookModel?> _fetchLastReadBook() async {
    final List<HistoryModel> history = await _historyService.getHistory();

    if (history.isEmpty) {
      return null;
    }

    final String lastBookId = history.first.bookId;


    final List<BookModel> allBooks = await _bookService.getAllBooks();

    try {
      final lastBook = allBooks.firstWhere((book) => book.id == lastBookId);
      return lastBook;
    } catch (e) {
      // Jika buku tidak ditemukan (misalnya sudah dihapus)
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BookModel?>(
      future: _fetchLastReadBook(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox.shrink();
        }

        final lastBook = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Yuk, Baca Lagi",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            BookCardWide(book: lastBook),
            const SizedBox(height: 20), // Jarak ke bagian selanjutnya
          ],
        );
      },
    );
  }
}