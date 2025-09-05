// lib/widgets/chapter_card.dart

import 'package:flutter/material.dart';
import 'package:aksara/models/chapter_model.dart';

class ChapterCard extends StatelessWidget {
  final ChapterModel chapter;
  final VoidCallback onTap;

  const ChapterCard({
    super.key,
    required this.chapter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Menggunakan ListTile secara langsung untuk tampilan yang bersih
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(
        'BAB ${chapter.order}: ${chapter.judulBab}',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      trailing: Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.chevron_right,
          color: Colors.white,
          size: 20,
        ),
      ),
      onTap: onTap,
    );
  }
}