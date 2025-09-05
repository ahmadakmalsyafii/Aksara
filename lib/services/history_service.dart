// lib/services/history_service.dart

import 'package:aksara/models/history_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  // Pastikan user sudah login sebelum memanggil service ini
  final uid = FirebaseAuth.instance.currentUser!.uid;
  
  Future<void> saveOrUpdateHistory({
    required String bookId,
    required String chapterId,
    required int score,
  }) async {
    final historyCollection = _db.collection("users").doc(uid).collection("history");

    // 1. Cari riwayat yang cocok berdasarkan bookId dan chapterId
    final querySnapshot = await historyCollection
        .where("bookId", isEqualTo: bookId)
        .where("chapterId", isEqualTo: chapterId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // 2. Jika dokumen ditemukan, perbarui (update) skor dan waktunya
      final docId = querySnapshot.docs.first.id;
      await historyCollection.doc(docId).update({
        "score": score,
        "finishedAt": FieldValue.serverTimestamp(), // Selalu perbarui waktu selesai
      });
    } else {
      // 3. Jika tidak ditemukan, buat dokumen riwayat baru
      await historyCollection.doc().set({
        "bookId": bookId,
        "chapterId": chapterId,
        "score": score,
        "finishedAt": FieldValue.serverTimestamp(),
      });
    }
  }

  /// Mengambil semua data riwayat (tidak ada perubahan di sini)
  Future<List<HistoryModel>> getHistory() async {
    final snap = await _db
        .collection("users")
        .doc(uid)
        .collection("history")
        .orderBy("finishedAt", descending: true)
        .get();

    return snap.docs.map((d) => HistoryModel.fromJson(d.data(), d.id)).toList();
  }

  /// Stream untuk riwayat (tidak ada perubahan di sini)
  Stream<List<HistoryModel>> getHistoryStream() {
    return _db
        .collection("users")
        .doc(uid)
        .collection("history")
        .orderBy("finishedAt", descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => HistoryModel.fromJson(d.data(), d.id)).toList());
  }
}