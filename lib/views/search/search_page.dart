// lib/views/search/search_page.dart

import 'package:aksara/views/search/search_result_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  void _performSearch(BuildContext context, String query) {
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SearchResultPage(query: query),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> recentSearches = ["Matematika", "Bahasa Indonesia", "IPA", "Kelas 11", "SMA"];
    final List<String> popularSearches = ["Matematika", "IPA", "IPS", "Seni Budaya", "Kelas 12"];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Field
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Mau belajar buku apa hari ini?",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: SvgPicture.asset(
                      "assets/icons/search_icon.svg",
                      height: 20,
                      width: 20,
                      color: Colors.black,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (val) => _performSearch(context, val),
              ),
              const SizedBox(height: 20),


              const Text("Terakhir Dicari", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: recentSearches.map((term) {
                  return ActionChip(
                    label: Text(term),
                    onPressed: () => _performSearch(context, term),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),


              const Text("Pencarian Populer", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Expanded(
                child: ListView(
                  children: popularSearches.map((term) {
                    return ListTile(
                      leading: const Icon(Icons.search),
                      title: Text(term),
                      onTap: () => _performSearch(context, term),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}