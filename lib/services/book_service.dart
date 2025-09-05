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

  Future<List<BookModel>> getBooksByCategory(String category) async {
    final snapshot = await _db
        .collection('books')
        .where('kategori', arrayContains: category)
        .get();

    return snapshot.docs.map((doc) => BookModel.fromJson(doc.data(), doc.id)).toList();
  }


  Future<List<BookModel>> searchBooks(String query) async {
    final snapshot = await _bookRef.get();
    final allBooks = snapshot.docs
        .map((doc) =>
        BookModel.fromJson(doc.data() as Map<String, dynamic>, doc.id))
        .toList();

    if (query.isEmpty) {
      return allBooks;
    }

    final lowerCaseQuery = query.toLowerCase();

    return allBooks.where((book) {
      final bookTitle = book.judul.toLowerCase();
      if (bookTitle.contains(lowerCaseQuery)) {
        return true;
      }

      final hasMatchingCategory = book.kategori.any((category) {
        return category.toLowerCase().contains(lowerCaseQuery);
      });

      return hasMatchingCategory;
    }).toList();
  }


}