import 'package:flutter/material.dart';
import 'package:aksara/services/book_service.dart';
import 'package:aksara/models/book_model.dart';
import 'package:aksara/widgets/book_card_wide.dart';
import 'package:aksara/widgets/filter_list.dart';
import 'package:aksara/widgets/popup_filter.dart';
import 'package:flutter_svg/flutter_svg.dart'; // widget baru untuk pop up filter

class SearchResultPage extends StatefulWidget {
  final String query;
  const SearchResultPage({super.key, required this.query});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  String? selectedClass;
  final TextEditingController _controller = TextEditingController();
  final BookService _bookService = BookService();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.query;
  }

  void _openFilterPopup() async {
    final result = await showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return PopupFilter(
          selectedClass: selectedClass,
        );
      },
    );

    if (result != null) {
      setState(() => selectedClass = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hasil Pencarian Buku")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search bar
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Cari disini",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (val) => setState(() {}),
            ),
            const SizedBox(height: 12),

            // Filter Row (icon + chips)
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
                    selectedClass: selectedClass,
                    onSelected: (val) => setState(() => selectedClass = val),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // List buku
            Expanded(
              child: FutureBuilder<List<BookModel>>(
                future: _bookService.searchBooks(_controller.text),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("Tidak ada buku ditemukan"));
                  }

                  var books = snapshot.data!;
                  if (selectedClass != null) {
                    books = books
                        .where((b) =>
                    b.kelas.toLowerCase() ==
                        selectedClass!.toLowerCase())
                        .toList();
                  }

                  return ListView.separated(
                    itemCount: books.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
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
