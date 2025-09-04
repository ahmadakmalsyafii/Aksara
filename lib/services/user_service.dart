import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> addPoints(int points) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final userRef = _db.collection('users').doc(uid);

    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);

      if (!snapshot.exists) {
        // Kalau user belum ada di Firestore, buat dulu
        transaction.set(userRef, {
          'points': points,
          'email': _auth.currentUser?.email,
        });
      } else {
        final currentPoints = snapshot['points'] ?? 0;
        transaction.update(userRef, {
          'points': currentPoints + points,
        });
      }
    });
  }

  Stream<int> getUserPoints() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return const Stream.empty();

    return _db.collection('users').doc(uid).snapshots().map((snap) {
      if (!snap.exists) return 0;
      return (snap['points'] ?? 0) as int;
    });
  }
}
