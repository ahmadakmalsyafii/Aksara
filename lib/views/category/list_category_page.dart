// lib/views/list_category_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:aksara/models/book_model.dart';
import 'package:aksara/services/book_service.dart';
import 'package:aksara/widgets/book_card_wide.dart';
import 'package:aksara/widgets/filter_list.dart';
import 'package:aksara/widgets/popup_filter.dart';

class ListCategoryPage extends StatefulWidget {
  final String categoryTitle;

  const ListCategoryPage({super.key, required this.categoryTitle});

  @override
  State<ListCategoryPage> createState() => _ListCategoryPageState();
}

class _ListCategoryPageState extends State<ListCategoryPage> {
  final BookService _bookService = BookService();
  String? _selectedClass;

  void _openFilterPopup() async {
    final result = await showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return PopupFilter(
          selectedClass: _selectedClass,
        );
      },
    );

    if (mounted && result != null) {
      setState(() => _selectedClass = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kategori Buku'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(
                hintText: "Cari disini",
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                GestureDetector(
                  onTap: _openFilterPopup,
                  child: Container(
                    height: 44,
                    width: 44,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/filter_icon.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: FilterList(
                    selectedClass: _selectedClass,
                    onSelected: (val) => setState(() => _selectedClass = val),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Expanded(
              child: FutureBuilder<List<BookModel>>(
                future: _bookService.getBooksByCategory(widget.categoryTitle),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("Tidak ada buku dalam kategori '${widget.categoryTitle}'."));
                  }

                  var books = snapshot.data!;
                  if (_selectedClass != null) {
                    books = books.where((book) => book.kelas == _selectedClass).toList();
                  }

                  if (books.isEmpty) {
                    return Center(child: Text("Tidak ada buku untuk kelas ${_selectedClass} di kategori ini."));
                  }

                  return ListView.separated(
                    itemCount: books.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return BookCardWide(book: books[index]);
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