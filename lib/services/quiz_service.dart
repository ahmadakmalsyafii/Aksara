import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chapter_model.dart';

class QuizService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveQuiz(String chapterId, Map<String, dynamic> quizJson) async {
    await _db.collection('quizzes').doc(chapterId).set({
      'chapterId': chapterId,
      'quiz': quizJson,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<Map<String, dynamic>?> getQuiz(String chapterId) async {
    final doc = await _db.collection('quizzes').doc(chapterId).get();
    return doc.exists ? doc.data() : null;
  }

  Future<void> deleteQuiz(String chapterId) async {
    final ref = _db.collection("quizzes").doc(chapterId);
    final snap = await ref.get();
    if (snap.exists) {
      await ref.delete();
      print("✅ Quiz untuk chapter $chapterId berhasil dihapus");
    } else {
      print("⚠️ Tidak ada quiz ditemukan untuk chapter $chapterId");
    }
  }

}