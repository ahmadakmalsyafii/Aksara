import 'package:cloud_firestore/cloud_firestore.dart';


class ProgressRepository {
  final _db = FirebaseFirestore.instance;


  Future<void> saveScore({
    required String uid,
    required String bookId,
    required String chapterId,
    required int total,
    required int correct,
  }) async {
    final ref = _db.collection('userProgress').doc(uid).collection('books').doc(bookId);
    await ref.set({
      'lastUpdated': FieldValue.serverTimestamp(),
      'scores': {chapterId: {'total': total, 'correct': correct, 'ts': FieldValue.serverTimestamp()}},
    }, SetOptions(merge: true));


// update chapter terakhir bila lulus
    if (correct >= (total * 0.6).round()) {
      await ref.set({'currentChapter': int.parse(chapterId) + 1}, SetOptions(merge: true));
    }
  }


  Future<int> getCurrentChapter({required String uid, required String bookId}) async {
    final snap = await _db.collection('userProgress').doc(uid).collection('books').doc(bookId).get();
    return (snap.data()?['currentChapter'] as int?) ?? 1;
  }
}