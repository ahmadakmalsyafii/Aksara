import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  final int points;
  final int streak;
  final int booksRead;

  const StatsCard({
    super.key,
    required this.points,
    required this.streak,
    required this.booksRead,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('Poin', points.toString(), Icons.monetization_on),
            _buildStatItem('Streak', streak.toString(), Icons.local_fire_department),
            _buildStatItem('Baca Buku', booksRead.toString(), Icons.menu_book),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}