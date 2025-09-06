import 'package:flutter/material.dart';
import 'package:aksara/models/book_model.dart';
import 'package:aksara/services/bookmark_service.dart';
import 'package:aksara/widgets/book_card_saloka.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  final BookmarkService _bookmarkService = BookmarkService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookmark"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar (opsional, bisa ditambahkan nanti)
            TextField(
              decoration: InputDecoration(
                hintText: "Cari buku simpananmu",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<List<BookModel>>(
                stream: _bookmarkService.getBookmarkedBooks(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text("Gagal memuat data."));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "Kamu belum menyimpan buku apapun.",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  final books = snapshot.data!;
                  return GridView.builder(
                    itemCount: books.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.6,
                    ),
                    itemBuilder: (context, index) {
                      // Tampilkan buku dengan BookCardSaloka atau widget kartu lainnya
                      return BookCardSaloka(book: books[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}