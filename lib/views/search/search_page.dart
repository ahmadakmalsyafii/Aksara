import 'package:aksara/views/search/search_result_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔍 Search Field
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
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
                  onSubmitted: (val) {
                    if (val.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SearchResultPage(query: val),
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),

              // 🔄 Terakhir Dicari
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Terakhir Dicari", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text("Hapus Semua", style: TextStyle(color: Colors.blue)),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(label: Text("Matematika"), deleteIcon: Icon(Icons.close)),
                  Chip(label: Text("Bahasa Indonesia"), deleteIcon: Icon(Icons.close)),
                  Chip(label: Text("IPA"), deleteIcon: Icon(Icons.close)),
                  Chip(label: Text("Kelas 11"), deleteIcon: Icon(Icons.close)),
                  Chip(label: Text("SMA"), deleteIcon: Icon(Icons.close)),
                ],
              ),

              const SizedBox(height: 20),
              const Text("Pencarian Populer", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              Expanded(
                child: ListView(
                  children: const [
                    ListTile(leading: Icon(Icons.search), title: Text("Matematika")),
                    ListTile(leading: Icon(Icons.search), title: Text("IPA")),
                    ListTile(leading: Icon(Icons.search), title: Text("IPS")),
                    ListTile(leading: Icon(Icons.search), title: Text("Seni Budaya")),
                    ListTile(leading: Icon(Icons.search), title: Text("Kelas 12")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
