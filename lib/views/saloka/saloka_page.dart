// lib/views/saloka/saloka_page.dart
import 'package:flutter/material.dart';
import 'package:aksara/models/book_model.dart';
import 'package:aksara/services/book_service.dart';
import 'package:aksara/widgets/book_card_saloka.dart';
import 'package:aksara/views/coming_soon_page.dart'; // Import halaman ComingSoon

class SalokaPage extends StatelessWidget {
  const SalokaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final BookService bookService = BookService();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Mengganti AppBar dengan Row
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Saloka Store",
                      style:
                      TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        _buildCircleIcon(
                          context,
                          icon: Icons.shopping_cart_outlined,
                          page: const ComingSoonPage(title: 'Keranjang'),
                        ),
                        const SizedBox(width: 12),
                        _buildCircleIcon(
                          context,
                          icon: Icons.notifications_outlined,
                          page: const ComingSoonPage(title: 'Notifikasi'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Search Bar
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                    Text("Mau beli buku apa?",
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Grid Buku
              Expanded(
                child: FutureBuilder<List<BookModel>>(
                  future: bookService.getAllBooks(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text("Belum ada buku tersedia"));
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
                        final book = books[index];
                        return BookCardSaloka(book: book);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircleIcon(BuildContext context,
      {required IconData icon, required Widget page}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              blurRadius: 10,
            )
          ],
        ),
        child: Icon(icon, color: Colors.black, size: 24),
      ),
    );
  }
}