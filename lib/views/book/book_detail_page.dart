import 'dart:ui';

import 'package:aksara/services/bookmark_service.dart';
import 'package:aksara/services/history_service.dart';
import 'package:aksara/services/unlock_service.dart';
import 'package:aksara/services/user_stats_service.dart';
import 'package:aksara/widgets/unlock_book_popup.dart';
import 'package:flutter/material.dart';
import 'package:aksara/models/book_model.dart';
import 'package:aksara/views/chapter/chapter_page.dart';

class BookDetailPage extends StatelessWidget {
  final BookModel book;
  final BookmarkService _bookmarkService = BookmarkService();
  final UnlockService _unlockService = UnlockService();
  final StatsService _statsService = StatsService();

  BookDetailPage({super.key, required this.book});

  void _showUnlockPopup(BuildContext context, int userPoints) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // Membuat latar belakang transparan
      isScrollControlled: true,
      builder: (context) {
        return UnlockBookPopup(
          userPoints: userPoints,
          onUnlock: () async {
            if (userPoints >= 2000) {
              await _statsService.deductPoints(2000);
              await _unlockService.unlockBook(book.id);
              Navigator.of(context).pop(); // Tutup bottom sheet
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => ChapterPage(book: book),
                ),
              );
            } else {
              Navigator.of(context).pop(); // Tutup bottom sheet
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Poin kamu tidak cukup!')),
              );
            }
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final HistoryService historyService = HistoryService();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          StreamBuilder<bool>(
            stream: _bookmarkService.isBookmarked(book.id),
            builder: (context, snapshot) {
              final isBookmarked = snapshot.data ?? false;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: isBookmarked ? Theme.of(context).primaryColor : Colors.grey,
                    ),
                    onPressed: () {
                      if (isBookmarked) {
                        _bookmarkService.removeBookmark(book.id);
                      } else {
                        _bookmarkService.addBookmark(book.id);
                      }
                    },
                  ),
                ),
              );
            },
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
                      height: 176,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(book.coverUrl, fit: BoxFit.fitHeight),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                    padding: const EdgeInsets.only(bottom: 8,right: 32),
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
                        backgroundColor: Color(0xff338EC6),
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

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: StreamBuilder<List<String>>(
            stream: _unlockService.getUnlockedBooksStream(),
            builder: (context, unlockedSnapshot) {
              if (unlockedSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final unlockedBooks = unlockedSnapshot.data ?? [];
              final isBookUnlocked = unlockedBooks.contains(book.id);
              final isBookFree = book.level == 'Basic';

              // Buku dapat diakses jika gratis ATAU sudah di-unlock
              final canAccess = isBookFree || isBookUnlocked;

              return SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: !canAccess
                      ? const Icon(Icons.lock, color: Colors.white)
                      : const Icon(Icons.menu_book, color: Colors.white),
                  label: Text(
                    !canAccess ? "Buka Buku (2000 Poin)" : "Baca Sekarang",
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w900),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  onPressed: () async {
                    if (canAccess) {
                      await historyService.saveOrUpdateHistory(
                        bookId: book.id,
                        chapterId: '-',
                        score: 0,
                      );
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChapterPage(book: book),
                          ),
                        );
                      }
                    } else {
                      // Jika tidak bisa akses, tunjukkan popup
                      final statsData = await _statsService.getStats();
                      final userPoints = statsData?['points'] ?? 0;
                      _showUnlockPopup(context, userPoints);
                    }
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}