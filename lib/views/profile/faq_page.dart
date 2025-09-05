import 'package:flutter/material.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Frequently Asked Questions"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(
              'assets/images/faq_mascot.png', // Pastikan path gambar benar
              height: 200,
            ),
            const SizedBox(height: 24),
            _buildFaqItem(
              "Apa itu Aksara?",
              "Aksara adalah platform pembelajaran digital yang menyediakan akses mudah ke berbagai buku pelajaran sekolah. Kami bertujuan untuk membuat belajar lebih menyenangkan dan efektif dengan fitur-fitur interaktif seperti kuis AI dan pelacakan progres.",
            ),
            const SizedBox(height: 12),
            _buildFaqItem(
              "Bagaimana cara kerja Aksara?",
              "Anda dapat menjelajahi buku berdasarkan mata pelajaran atau kelas, membaca bab per bab secara online, dan menguji pemahaman Anda dengan kuis yang dibuat secara otomatis oleh AI. Setiap aktivitas membaca dan kuis akan tercatat dalam riwayat Anda.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      child: ExpansionTile(
        shape: const Border(),
        title: Text(question, style: const TextStyle(fontWeight: FontWeight.w600)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: TextStyle(color: Colors.grey.shade700, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}