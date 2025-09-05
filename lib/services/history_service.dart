import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aksara/models/history_model.dart';
import 'package:flutter/cupertino.dart';


class HistoryService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveHistory({
    required String bookId,
    required String chapterId,
    required int score,
  }) async {
    // Ambil pengguna yang sedang login saat ini
    final user = _auth.currentUser;

    // Periksa apakah pengguna sudah login. Jika tidak, hentikan fungsi.
    if (user == null) {
      // Cetak pesan error untuk debugging
      debugPrint("Error: Pengguna belum login. Tidak dapat menyimpan riwayat.");
      return;
    }

    final uid = user.uid;
    final historyRef = _db.collection("users").doc(uid).collection("history").doc();

    try {
      await historyRef.set({
        "bookId": bookId,
        "chapterId": chapterId,
        "score": score,
        "finishedAt": FieldValue.serverTimestamp(),
      });
      debugPrint("Riwayat berhasil disimpan untuk buku: $bookId");
    } catch (e) {
      // Tangani error jika terjadi masalah saat menyimpan ke Firestore
      debugPrint("Gagal menyimpan riwayat: $e");
    }
  }

  /// Ambil riwayat baca sebagai stream.
  Stream<List<HistoryModel>> getHistoryStream() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value([]); // Kembalikan stream kosong jika tidak ada pengguna
    }

    return _db
        .collection("users")
        .doc(user.uid)
        .collection("history")
        .orderBy("finishedAt", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => HistoryModel.fromJson(doc.data(), doc.id))
        .toList());
  }

  Future<List<HistoryModel>> getHistory() async {
    final user = _auth.currentUser;
    final snap = await _db
        .collection("users")
        .doc(user?.uid)
        .collection("history")
        .orderBy("finishedAt", descending: true)
        .get();

    return snap.docs.map((d) => HistoryModel.fromJson(d.data(), d.id)).toList();
  }

  /// Perbarui skor riwayat setelah kuis selesai.
  Future<void> updateHistoryScore({
    required String bookId,
    required String chapterId,
    required int score,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      debugPrint("Error: Pengguna belum login. Tidak dapat memperbarui skor.");
      return;
    }

    final uid = user.uid;
    final querySnapshot = await _db
        .collection("users")
        .doc(uid)
        .collection("history")
        .where("bookId", isEqualTo: bookId)
        .where("chapterId", isEqualTo: chapterId)
        .orderBy("finishedAt", descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final docId = querySnapshot.docs.first.id;
      await _db
          .collection("users")
          .doc(uid)
          .collection("history")
          .doc(docId)
          .update({
        "score": score,
        "finishedAt": FieldValue.serverTimestamp(),
      });
      debugPrint("Skor berhasil diperbarui untuk buku: $bookId");
    } else {
      await saveHistory(bookId: bookId, chapterId: chapterId, score: score);
    }
  }
}