// lib/services/user_stats_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StatsService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String _dateOnlyString(DateTime dt) {
    final d = dt.toUtc();
    return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  Future<void> recordDailyRead({int streakIncrementIfNewDay = 1}) async {
    final user = _auth.currentUser;
    if (user == null) return;
    final ref = _db
        .collection('users')
        .doc(user.uid)
        .collection('stats')
        .doc('stats');

    await _db.runTransaction((tx) async {
      final snapshot = await tx.get(ref);
      final today = _dateOnlyString(DateTime.now());
      if (!snapshot.exists) {
        tx.set(ref, {
          'points': 0,
          'streak': 1,
          'lastReadDate': today,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        return;
      }

      final data = snapshot.data()!;
      final lastRead = (data['lastReadDate'] as String?) ?? '';
      if (lastRead == today) {
        // sudah terhitung hari ini -> nothing
        return;
      }

      // parse lastRead and compare
      try {
        final last = DateTime.tryParse(lastRead);
        if (last != null) {
          final yesterday =
          DateTime.now().toUtc().subtract(const Duration(days: 1));
          final yesterdayStr = _dateOnlyString(yesterday);
          if (lastRead == yesterdayStr) {
            // lanjut streak
            final newStreak = (data['streak'] ?? 0) as int;
            tx.update(ref, {
              'streak': newStreak + streakIncrementIfNewDay,
              'lastReadDate': today,
              'updatedAt': FieldValue.serverTimestamp(),
            });
            return;
          }
        }
      } catch (_) {}

      // jika bukan yesterday -> reset ke 1
      tx.update(ref, {
        'streak': 1,
        'lastReadDate': today,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> addPoints(int amount) async {
    final user = _auth.currentUser;
    if (user == null) return;
    final ref = _db
        .collection('users')
        .doc(user.uid)
        .collection('stats')
        .doc('stats');
    await ref.set({
      'points': FieldValue.increment(amount),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getStats() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final ref = _db
        .collection('users')
        .doc(user.uid)
        .collection('stats')
        .doc('stats');
    final snap = await ref.get();
    if (!snap.exists) return {'points': 0, 'streak': 0};
    return snap.data();
  }

  Future<void> deductPoints(int amount) async {
    final user = _auth.currentUser;
    if (user == null) return;
    final ref = _db
        .collection('users')
        .doc(user.uid)
        .collection('stats')
        .doc('stats');

    // Menggunakan FieldValue.increment dengan nilai negatif untuk mengurangi poin
    await ref.update({'points': FieldValue.increment(-amount)});
  }
}