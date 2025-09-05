import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chapter_model.dart';

class ChapterService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<ChapterModel>> getChapters(String bookId) async {
    final snapshot = await _db
        .collection('books')
        .doc(bookId)
        .collection('chapters')
        .orderBy('order') // urutkan berdasarkan field "order"
        .get();

    return snapshot.docs
        .map((doc) => ChapterModel.fromJson(doc.id, doc.data()))
        .toList();
  }

  Future<int> getChaptersCount(String bookId) async {
    final snapshot = await _db
        .collection('books')
        .doc(bookId)
        .collection('chapters')
        .get();
    return snapshot.docs.length;
  }

}