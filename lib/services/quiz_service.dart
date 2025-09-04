import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chapter_model.dart';

class QuizService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveQuiz(String chapterId, Map<String, dynamic> quizJson) async {
    await _db.collection('quizzes').add({
      'chapterId': chapterId,
      'quiz': quizJson,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

}