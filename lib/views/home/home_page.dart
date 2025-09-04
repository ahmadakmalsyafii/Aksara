import 'package:aksara/models/book_model.dart';
import 'package:aksara/services/book_service.dart';
import 'package:aksara/views/auth/login_page.dart';
import 'package:aksara/views/book/book_detail_page.dart';
import 'package:aksara/views/search/search_page.dart';
import 'package:aksara/widgets/block_category.dart';
import 'package:aksara/widgets/book_card_wide.dart';
import 'package:aksara/widgets/custom_buttom_navbar.dart';
import 'package:aksara/widgets/custom_navbar.dart';
import 'package:aksara/widgets/home_banner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aksara/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // TODO: Navigasi ke halaman lain berdasarkan index
      // contoh: if (index == 1) Navigator.push(... RiwayatPage());
      // if (index == 1) {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (_) => ()),
      //   );
      // }
    });
  }


  final bookService = BookService();
  final AuthService authService = AuthService();
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Beranda", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
          )
        ],
      ),
      body:
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomNavbar(username: "${user?.email ?? 'User'}" , streak: 10),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 2,
                      spreadRadius: 1,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return DraggableScrollableSheet(
                          expand: false,
                          initialChildSize: 0.95,
                          maxChildSize: 0.95,
                          minChildSize: 0.95,
                          builder: (_, controller) => const SearchPage(),
                        );
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 2,
                          spreadRadius: 1,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/search_icon.svg",
                          height: 20,
                          width: 20,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Mau belajar buku apa hari ini?",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text("Mata Pelajaran, Nih", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              BlockCategory(),
              SizedBox(height: 20),
              HomeBanner(),
              Text("Cocok Buat Kamu", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              FutureBuilder<List<BookModel>>(
                future: bookService.getAllBooks(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text("Belum ada buku tersedia.");
                  }
                  return Column(
                    children: snapshot.data!.map((book) =>
                        BookCardWide(book: book)).toList(),
                    spacing: 8,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
      ),
    );
  }
}
