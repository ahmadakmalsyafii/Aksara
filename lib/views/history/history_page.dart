import 'package:aksara/widgets/order_history_tab.dart';
import 'package:aksara/widgets/read_history_tab.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aksara/models/book_model.dart';
import 'package:aksara/models/history_model.dart';
import 'package:aksara/services/history_service.dart';
import 'package:aksara/services/chapter_service.dart';
import 'package:aksara/views/book/book_detail_page.dart';
import 'package:aksara/views/saloka/saloka_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // 0 untuk 'Membaca', 1 untuk 'Pesanan'
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat", style: TextStyle(fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // --- Tab Selector ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  _buildTabButton("Membaca", 0),
                  _buildTabButton("Pesanan", 1),
                ],
              ),
            ),
          ),

          // --- Konten Tab ---
          Expanded(
            child: _selectedTab == 0
                ? const ReadHistoryTab()
                : const OrdersHistoryTab(),
          ),
        ],
      ),
    );
  }

  // Widget untuk tombol tab
  Widget _buildTabButton(String title, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: _selectedTab == index ? Theme.of(context).primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _selectedTab == index ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}



