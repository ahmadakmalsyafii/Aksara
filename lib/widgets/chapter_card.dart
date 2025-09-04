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
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          chapter.judulBab,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
