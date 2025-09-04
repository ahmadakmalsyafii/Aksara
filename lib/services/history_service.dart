import 'package:aksara/models/history_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> saveHistory({
    required String bookId,
    required String chapterId,
    required int score,
  }) async {
    final historyRef = _db.collection("users").doc(uid).collection("history").doc();

    await historyRef.set({
      "bookId": bookId,
      "chapterId": chapterId,
      "score": score,
      "finishedAt": FieldValue.serverTimestamp(),
    });
  }

  /// 🔹 Ambil riwayat baca
  Future<List<HistoryModel>> getHistory() async {
    final snap = await _db
        .collection("users")
        .doc(uid)
        .collection("history")
        .orderBy("finishedAt", descending: true)
        .get();

    return snap.docs.map((d) => HistoryModel.fromJson(d.data(), d.id)).toList();
  }
}
