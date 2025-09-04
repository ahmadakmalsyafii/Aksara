import 'package:aksara/models/book_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final CollectionReference _bookRef =
  FirebaseFirestore.instance.collection("books");


  Future<List<BookModel>> getAllBooks() async {
    final snapshot = await FirebaseFirestore.instance.collection('books').get();
    return snapshot.docs.map((doc) => BookModel.fromJson(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }


  Future<List<BookModel>> searchBooks(String query) async {
    if (query.isEmpty) {
      final snapshot = await _bookRef.get();
      return snapshot.docs
          .map((doc) =>
          BookModel.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    }

    final snapshot = await _bookRef
        .where("judul", isGreaterThanOrEqualTo: query)
        .where("judul", isLessThanOrEqualTo: "$query\uf8ff")
        .get();

    return snapshot.docs
        .map((doc) =>
        BookModel.fromJson(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }



  Future<List<BookModel>> getBooksAll() async {
    final snapshot = await _db.collection('books').get();
    return snapshot.docs.map((doc) => BookModel.fromJson(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }


}