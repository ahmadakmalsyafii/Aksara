// main_page.dart
import 'package:flutter/material.dart';
import 'package:aksara/views/home/home_page.dart';
import 'package:aksara/views/saloka/saloka_page.dart';
import 'package:aksara/views/history/history_page.dart';
import 'package:aksara/widgets/custom_buttom_navbar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const SalokaPage(),
    const HistoryPage(),
    // Tambahkan halaman profil di sini jika ada
  ];

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
      ),
    );
  }
}