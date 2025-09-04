// lib/views/saloka/saloka_page.dart

import 'package:flutter/material.dart';
import 'package:aksara/models/book_model.dart';
import 'package:aksara/services/book_service.dart';
import 'package:aksara/widgets/book_card_saloka.dart'; // Import widget baru

class SalokaPage extends StatelessWidget {
  const SalokaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final BookService bookService = BookService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Saloka Store", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: const [
          Icon(Icons.shopping_cart_outlined),
          SizedBox(width: 12),
          Icon(Icons.notifications_outlined),
          SizedBox(width: 12),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔍 Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 10),
                  Text("Mau beli buku apa?", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 📚 Grid Buku dari Firestore
            Expanded(
              child: FutureBuilder<List<BookModel>>(
                future: bookService.getAllBooks(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("Belum ada buku tersedia"));
                  }

                  final books = snapshot.data!;

                  return GridView.builder(
                    itemCount: books.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.6, // Sesuaikan aspect ratio jika perlu
                    ),
                    itemBuilder: (context, index) {
                      final book = books[index];
                      // Ganti Container dengan widget BookCardSaloka
                      return BookCardSaloka(book: book);
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