// lib/services/unlock_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UnlockService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String? uid = FirebaseAuth.instance.currentUser?.uid;

  DocumentReference get _userDocRef => _db.collection('users').doc(uid);

  /// Menambah ID buku ke array 'unlockedBooks'
  Future<void> unlockBook(String bookId) async {
    if (uid == null) return;
    await _userDocRef.update({
      'unlockedBooks': FieldValue.arrayUnion([bookId])
    });
  }

  /// Mendapatkan stream daftar buku yang sudah di-unlock
  Stream<List<String>> getUnlockedBooksStream() {
    if (uid == null) return Stream.value([]);
    return _userDocRef.snapshots().map((snapshot) {
      if (!snapshot.exists) return [];
      final data = snapshot.data() as Map<String, dynamic>;
      // Pastikan untuk menangani jika field belum ada
      if (data.containsKey('unlockedBooks')) {
        return List<String>.from(data['unlockedBooks']);
      }
      return [];
    });
  }

}