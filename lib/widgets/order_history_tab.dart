import 'package:aksara/views/saloka/saloka_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrdersHistoryTab extends StatelessWidget {
  const OrdersHistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/cry_mascot.png', height: 200),
          const SizedBox(height: 16),
          const Text("Kamu Belum Pesan Apapun", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            "Hmm, belum ada catatan pesanan di sini. Saatnya isi dengan buku pelajaran dari Saloka Store!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SalokaPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              foregroundColor: Colors.white,
            ),
            child: const Text("Buat pesanan"),
          ),
        ],
      ),
    );
  }
}